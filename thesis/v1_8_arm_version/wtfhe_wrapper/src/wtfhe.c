#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"
#include "xparameters_ps.h"
#include "xil_types.h"
#include "xgpiops.h"
#include "xscugic.h"
#include "xuartps.h"
#include "xtime_l.h"

// FPGA EMIO Control
#define rstFPGA		54
#define startFPGA	55

// delay before/after FPGA run to complete any pending transactions on AXI bus
#define AXI_DELAY	1000

// WTFHE Setup
#define N			32
#define PI			3
#define DIM			4
#define K			1
#define L			5
#define TAU			22
#define GAMMA		3
#define NUM_OF_NN	3
#define TRLWE_OFFSET	0x3C00 // 3840 * 4 = (Number of all 6 TRGSW Sample coefficients + 1) * 4 coz ARM is indexing bytes -- adress of first TRLWE coefficient
#define TLWE_OFFSET		0x3D00 // 3904 * 4 = TRLWE_OFFSET + (TRLWE Sample size * 4 coz ARM is indexing bytes) -- adress of first TLWE coefficient
#define PT_LENGTH		3

/* EMIO Controller */
static XGpioPs psGpioInstance;
static XGpioPs_Config* GpioConfig;

XScuGic InterruptController;
static volatile int FPGA_busy;

static unsigned int signum[8] = {0, 1, 1, 1, 0, 7, 7, 7}; // negacyclic extension of signum function

//coeff[0] == a * x^0, coeff[1] == a * x^1 etc.
typedef struct polynomial {
	unsigned int coeff[N];
} polynomial;

//
typedef struct matrix {
	unsigned int rows;
	unsigned int cols;
	unsigned int *coeff;
} matrix;

// TLWE Sample
typedef struct TLWE {
	unsigned int coeff[DIM+1];
} TLWE;

// TRLWE Sample
typedef struct TRLWE {
	polynomial poly[(K + 1)];
} TRLWE;

// TRGSW Sample
typedef struct TRGSW {
	polynomial poly[(K + 1)][(K + 1) * L];
} TRGSW;

// Function headers
void encrypt_fn(unsigned int* input_vector, TRLWE* poly);
void encrypt(unsigned int* key, unsigned int input, TLWE* poly);
int decrypt(unsigned int* key, TLWE* poly);
void matrix_multiply(matrix synapses, TLWE** input, unsigned int *tlwe_rows);
void pt_multiply(matrix synapses, unsigned int** input, unsigned int* length);
unsigned int pt_signum(unsigned int input);
void neural_demo(XGpioPs* psGpioInstancePtr);
void load_matrices(matrix* nn);
void cycle_poly(polynomial* x);
void poly_multiply(polynomial t, polynomial y, polynomial* r);
void gen_TRGSW(TRGSW* matrices, unsigned int* key);
void write_TRGSW(TRGSW* matrices);
void write_TRLWE(TRLWE* trlwe_inst);
void write_TLWE(TLWE* c_in);
void read_TLWE(TLWE* c_in);
void RunFPGA(XGpioPs* psGpioInstancePtr);

void ExtIrqHandler(void *CallBackRef) {
	FPGA_busy = 0;
}

static int SetupGPIO(u16 DeviceId) {
	int Status;

	GpioConfig = XGpioPs_LookupConfig(DeviceId);

	Status = XGpioPs_CfgInitialize(&psGpioInstance, GpioConfig, GpioConfig->BaseAddr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

static int SetupInterruptSystem(XScuGic *IntcInstancePtr, XUartPs *InstancePtr, void *IrqHandler, u16 IntrId, u16 DeviceId) {
	int Status;
	XScuGic_Config *IntcConfig; /* Config for interrupt controller */

	/* Initialize the interrupt controller driver */
	IntcConfig = XScuGic_LookupConfig(DeviceId);
	if (NULL == IntcConfig) {
		return XST_FAILURE;
	}

	Status = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig,
		IntcConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Xil_ExceptionInit();
	/*
	* Connect the interrupt controller interrupt handler to the
	* hardware interrupt handling logic in the processor.
	*/
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
		(Xil_ExceptionHandler)XScuGic_InterruptHandler,
		IntcInstancePtr);

	/*
	* Connect a device driver handler that will be called when an
	* interrupt for the device occurs, the device driver handler
	* performs the specific interrupt processing for the device
	*/
	Status = XScuGic_Connect(IntcInstancePtr, IntrId,
		(Xil_ExceptionHandler)IrqHandler, //XUartPs_InterruptHandler , IrqHandler
		(void *)InstancePtr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/* Enable the interrupt for the device */
	XScuGic_Enable(IntcInstancePtr, IntrId);

	/* Enable interrupts */
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}

int main() {
	init_platform();

	// init rand()
	XTime t;
	XTime_GetTime(&t);
	srand((unsigned) t);

	int Status = SetupGPIO(XPAR_PS7_GPIO_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("FPGA GPIO Init Failed\r\n");
		return XST_FAILURE;
	}

	// Setup Interrupt Controller for EMIO
	Status = SetupInterruptSystem(&InterruptController, NULL, ExtIrqHandler, XPS_FPGA0_INT_ID, XPAR_PS7_SCUGIC_0_DEVICE_ID);
	// Set priority 0x00 (highest) with trigger on RISING_EDGE (0x3)
	XScuGic_SetPriorityTriggerType(&InterruptController, XPS_FPGA0_INT_ID, 0x00, 0x3);
	if (Status != XST_SUCCESS) {
		xil_printf("FPGA Interrupt Init Failed\r\n");
		return XST_FAILURE;
	}

	// Init EMIO to PL
	FPGA_busy = 0;
	XGpioPs_SetDirectionPin(&psGpioInstance, rstFPGA, 1);
	XGpioPs_SetDirectionPin(&psGpioInstance, startFPGA, 1);

	printf("start %lld\r\n", t);

	//button press mby?
	//run NN evaluation
	neural_demo(&psGpioInstance);

	XTime_GetTime(&t);
	printf("done %lld\r\n", t);

	while (1) {}

	cleanup_platform();
	return 0;
}

void neural_demo(XGpioPs* psGpioInstancePtr) {

	TRGSW* matrices = (TRGSW*)malloc((DIM * 3 / 2) * sizeof(TRGSW));
	int errors = 0;

	// loop whole neural network evaluation to get measurements
	for (int big_loop = 0; big_loop < 100000; big_loop++) {
		if (big_loop % 250 == 0) {
			xil_printf("loop: %u errors: %u\r\n", big_loop, errors);
		}
		unsigned int key[DIM] = {1,1,0,1}; // private key
		unsigned int length = 3; // plain text length
		unsigned int test_vector[DIM] = {0,1,1,1}; // encrypted function
		unsigned int input_vector[PT_LENGTH] = {1,1,0}; // plain text
		unsigned int output_vector[PT_LENGTH]; // output plain text
		unsigned int tlwe_rows = 3; // number of tlwe instances

		// init cipher text
		TLWE* c_in;
		c_in = (TLWE*)malloc(tlwe_rows * sizeof(TLWE));

		// init second plain text for unencrypted evaluation
		unsigned int* p_in;
		p_in = (unsigned int*)malloc(PT_LENGTH);
		for (int i = 0; i < PT_LENGTH; i++) {
			p_in[i] = input_vector[i];
		}

		// load definition of neural matrices
		matrix nn[NUM_OF_NN];
		load_matrices(nn);

		// encrypt plain text to TLWE Sample
		for (int i = 0; i < tlwe_rows; i++) {
			encrypt(key, input_vector[i], &c_in[i]);
		}

		// encrypt evaluated function into TRLWE Sample
		TRLWE* trlwe_inst = (TRLWE*)malloc(1 * sizeof(TRLWE));
		encrypt_fn(test_vector, trlwe_inst);

		// generate new TRGSW Samples
		gen_TRGSW(matrices, key);
		// send TRGSW Samples once
		write_TRGSW(matrices);

		// bootstrapping over neural matrices
		for (int iter = 0; iter < NUM_OF_NN; iter++) { // iterate over neural matrices
			//xil_printf("iter: %u\r\n", iter);

			// perceptron eval for cipher and plain text
			matrix_multiply(nn[iter], &c_in, &tlwe_rows); // calc new c_in
			pt_multiply(nn[iter], &p_in, &length); // calc new p_in

			// bootstrapping loop -- bootstrap every TLWE Sample
			for (int row = 0; row < tlwe_rows; row++) {
				//send data
				write_TRLWE(trlwe_inst);
				write_TLWE(&c_in[row]);

				//run bootstrapping on FPGA
				usleep(AXI_DELAY); // delay for AXI writes
				RunFPGA(psGpioInstancePtr);
				usleep(AXI_DELAY); // delay for AXI read

				// read result
				read_TLWE(&c_in[row]);
			}
			// print decrypted cipher text and homomorphically evaluated unencrypted plain text
			/*for (int i = 0; i < tlwe_rows; i++) {
				output_vector[i] = decrypt(key, &c_in[i]);
			}
			xil_printf(""loop: %u decrypt: ", big_loop);
			for (int i = 0; i < tlwe_rows; i++) {
				xil_printf("%d ", output_vector[i]);
			} xil_printf(" plain: ");
			for (int i = 0; i < tlwe_rows; i++) {
				xil_printf("%d ", p_in[i]);
			}
			xil_printf("\r\n");
			xil_printf("done: %u\r\n", iter);*/
		}

		// decrypt TLWE Sample to plain text
		for (int i = 0; i < tlwe_rows; i++) {
			output_vector[i] = decrypt(key, &c_in[i]);
		}

		// print decrypted cipher text and homomorphically evaluated unencrypted plain text
		/*xil_printf("res: ");
		for (int i = 0; i < length; i++) {
			xil_printf("%08x ", c_in[i]);
		}
		xil_printf("decrypt: ");
		for (int i = 0; i < length; i++) {
			xil_printf("%d ", output_vector[i]);
		} xil_printf(" plain: ");
		for (int i = 0; i < length; i++) {
			xil_printf("%d ", p_in[i]);
		} xil_printf("\r\n");*/

		// print msg if the result is wrong
		for (int i = 0; i < length; i++) {
			if (output_vector[i] != p_in[i]) {
				//xil_printf("SOMETHING WENT WRONG %d\r\n", big_loop);
				errors++;
			}
		}

		//clean up
		free(c_in);
		free(p_in);
		for (int i = 0; i < 3; i++) {
			free(nn[i].coeff);
		}
		free(trlwe_inst);
	}

	xil_printf("Num of errors %d\r\n", errors);
	free(matrices);
	return;
}

// send START signal over EMIO to FPGA and wait for a completion
void RunFPGA(XGpioPs* psGpioInstance) {
	FPGA_busy = 1;
	XGpioPs_WritePin(psGpioInstance, startFPGA, 1);
	XGpioPs_WritePin(psGpioInstance, startFPGA, 0);

	while (FPGA_busy) {};
}

// encrypt test vector (arbitrary function) into TRLWE Sample
void encrypt_fn(unsigned int* input_vector, TRLWE* trlwe_inst) {
	polynomial tmp;
	//extend the array
	for (int i = 0; i < pow(2, PI - 1); i++) {
		for (int j = 0; j < N / pow(2, PI - 1); j++) {
			tmp.coeff[i * (N / (unsigned int)(pow(2, PI - 1))) + j] = input_vector[i] % (1 << PI);
		}
	}
	//center the array
	for (int i = 0; i < N - (N / (int)pow(2, PI)); i++) {
		trlwe_inst->poly[1].coeff[i] = tmp.coeff[i + N / (int)pow(2, PI)] << (TAU - PI);
		trlwe_inst->poly[0].coeff[i] = 0;
	}
	for (int i = N - (N / (int)pow(2, PI)); i < N; i++) {
		trlwe_inst->poly[1].coeff[i] = ((1 << PI) - (tmp.coeff[(i + N / (int)pow(2, PI)) % N] << (TAU - PI))) % (1 << TAU);
		trlwe_inst->poly[0].coeff[i] = 0;
	}
}

// encrypt plain text into TLWE Sample
void encrypt(unsigned int* key, unsigned int in, TLWE* poly) {
	//init a with random values
	for (int i = 0; i < DIM; i++) {
		poly->coeff[i] = rand() % (1 << TAU);
	}
	//calculate b
	poly->coeff[DIM] = in << (TAU - PI);
	for (int i = 0; i < DIM; i++) {
		poly->coeff[DIM] += key[i] * poly->coeff[i];
	}
	poly->coeff[DIM] += (rand() % 3) - 1; // add noise <-1,0,1>
	poly->coeff[DIM] = poly->coeff[DIM] % (1 << TAU);
}

// decrypt TLWE Sample into a plain text
int decrypt(unsigned int* key, TLWE* poly) {
	unsigned int res = poly->coeff[DIM];
	//calculate m
	for (int i = 0; i < DIM; i++) {
		res -= key[i] * poly->coeff[i];
	}
	res = res % (1 << TAU);
	unsigned int decimal = (res >> (TAU - PI - 1)) & 1; // extract first decimal bit
	res = res >> (TAU - PI); // conv from torus to int
	res += decimal; // round to a nearest integer
	return res % (1 << PI);
}

// Neural network evaluation over encrypted data
void matrix_multiply(matrix synapses, TLWE** input, unsigned int *tlwe_rows) {
	// prepare output matrix
	TLWE* res = (TLWE*)malloc(synapses.rows * sizeof(TLWE));
	for (int i = 0; i < synapses.rows; i++) {
	for (int j = 0; j < DIM + 1; j++) {
		res[i].coeff[j] = 0;
	}
	}
	TLWE* tmp = *input;
	// Multiplying first and second matrices and store the result
	for (int i = 0; i < synapses.rows; ++i) {
		for (int j = 0; j < DIM + 1; ++j) {
			for (int k = 0; k < synapses.cols; ++k) {
				res[i].coeff[j] += synapses.coeff[i * synapses.cols + k] * tmp[k].coeff[j];
				res[i].coeff[j] = res[i].coeff[j] % (1 << TAU);
			}
		}
	}

	// copy to output
	free(*input);
	(*tlwe_rows) = synapses.rows;
	*input = res;
	return;
}

// Neural network evaluation over unencrypted data
void pt_multiply(matrix synapses, unsigned int** input, unsigned int* length) {
	// prepare output matrix
	unsigned int* res = (unsigned int*)malloc(synapses.rows * sizeof(unsigned int));
	for (int i = 0; i < synapses.rows; i++) {
		res[i] = 0;
	}
	// Multiplying first and second matrices and store the result
	unsigned int* tmp = *input;
	for (int i = 0; i < synapses.rows; ++i) {
		for (int k = 0; k < synapses.cols; ++k) {
			res[i] += synapses.coeff[i * synapses.cols + k] * tmp[k];
		}
	}
	for (int i = 0; i < synapses.rows; i++) {
		res[i] = pt_signum(res[i]);
	}
	// copy to output
	free(*input);
	(*length) = synapses.rows;
	*input = res;
	return;
}


// singnum function definition
unsigned int pt_signum(unsigned int input) {
	return signum[input % (int)pow(2, PI)];
}

// neural network weights
void load_matrices(matrix* nn) {
	// for testing -- identical to Jakub's matrices
	nn[0].rows = 5;
	nn[0].cols = 3;
	nn[0].coeff = (unsigned int*)malloc(nn[0].rows * nn[0].cols * sizeof(unsigned int));

	nn[1].rows = 2;
	nn[1].cols = 5;
	nn[1].coeff = (unsigned int*)malloc(nn[1].rows * nn[1].cols * sizeof(unsigned int));

	nn[2].rows = 3;
	nn[2].cols = 2;
	nn[2].coeff = (unsigned int*)malloc(nn[2].rows * nn[2].cols * sizeof(unsigned int));

	nn[0].coeff[0] = 4;
	nn[0].coeff[1] = 6;
	nn[0].coeff[2] = 3;
	nn[0].coeff[3] = 2;
	nn[0].coeff[4] = 4;
	nn[0].coeff[5] = 3;
	nn[0].coeff[6] = 3;
	nn[0].coeff[7] = 0;
	nn[0].coeff[8] = 7;
	nn[0].coeff[9] = 2;
	nn[0].coeff[10] = 4;
	nn[0].coeff[11] = 6;
	nn[0].coeff[12] = 6;
	nn[0].coeff[13] = 0;
	nn[0].coeff[14] = 2;

	nn[1].coeff[0] = 2;
	nn[1].coeff[1] = 0;
	nn[1].coeff[2] = 3;
	nn[1].coeff[3] = 0;
	nn[1].coeff[4] = 5;
	nn[1].coeff[5] = 0;
	nn[1].coeff[6] = 3;
	nn[1].coeff[7] = 5;
	nn[1].coeff[8] = 4;
	nn[1].coeff[9] = 4;

	nn[2].coeff[0] = 7;
	nn[2].coeff[1] = 4;
	nn[2].coeff[2] = 5;
	nn[2].coeff[3] = 3;
	nn[2].coeff[4] = 1;
	nn[2].coeff[5] = 2;

	return;
}

// negacyclic rotation of a polynomial
void cycle_poly(polynomial* x) {
	unsigned int tmp = x->coeff[N - 1];
	for (int i = N - 1; i > 0; i--) {
		x->coeff[i] = x->coeff[i - 1];
	}
	x->coeff[0] = ((1 << TAU) - tmp) % (1 << TAU);
}


// multiply two polynomials and store in "r", does not reset value of "r"
void poly_multiply(polynomial t, polynomial y, polynomial* r) {
	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++) {
			r->coeff[j] += t.coeff[j] * y.coeff[i];
			r->coeff[j] = r->coeff[j] % (1 << TAU);
		}
		cycle_poly(&t);
	}
}

// instantiate TRGSW Samples
void gen_TRGSW(TRGSW* matrices, unsigned int* key) {
	//extend key
	polynomial ext_key;
	for (int i = 0; i < N - DIM; i++) {
		ext_key.coeff[i] = 0;
	}
	for (int i = 0; i < DIM; i++) {
		ext_key.coeff[N - DIM + i] = key[i];
	}

	//create key tripplets
	unsigned int b_keys[DIM * 3 / 2];
	for (int i = 0; i < DIM / 2; i++) {
		b_keys[i * 3] = key[i * 2] * key[i * 2 + 1];
		b_keys[i * 3 + 1] = key[i * 2] * (1 - key[i * 2 + 1]);
		b_keys[i * 3 + 2] = (1 - key[i * 2]) * key[i * 2 + 1];
	}

	//init first column to random noise
	for (int il = 0; il < (DIM * 3 / 2); il++) {
	for (int j = 0; j < (K + 1) * L; j++) {
	for (int i = 0; i < N; i++) {
		matrices[il].poly[0][j].coeff[i] = rand() % (1 << TAU);
		matrices[il].poly[1][j].coeff[i] = 0;
	}}}

	//calculate second column
	for (int il = 0; il < (DIM * 3 / 2); il++) {
	for (int j = 0; j < (K + 1) * L; j++) {
		poly_multiply(matrices[il].poly[0][j], ext_key, &matrices[il].poly[1][j]);
		for (int i = 0; i < N; i++) {
			matrices[il].poly[1][j].coeff[i] += (rand() % 3) - 1; // add noise <-1,0,1>
			matrices[il].poly[1][j].coeff[i] = matrices[il].poly[1][j].coeff[i] % (1 << TAU);
		}
	}}

	//add gadget matrix
	unsigned int gadget = 1 << (TAU - GAMMA * L);

	for (int i = 0; i < L; i++) {
		for (int j = 0; j < DIM * 3 / 2; j++) {
			if (b_keys[j] != 0) {
				for (int ii = 0; ii < K + 1; ii++) {
					matrices[j].poly[ii][L - i - 1 + ii * L].coeff[0] += gadget * b_keys[j];
					matrices[j].poly[ii][L - i - 1 + ii * L].coeff[0] = matrices[j].poly[ii][L - i - 1 + ii * L].coeff[0] % (1 << TAU);
				}

			}
		}
		gadget = gadget << GAMMA;
	}
}

// write TRGSW Samples to BRAM
void write_TRGSW(TRGSW* matrices) {
	int cnt = 0;
	for (int il = 0; il < (DIM * 3 / 2); il++) {
	for (int j = 0; j < (K + 1) * L; j++) {
	for (int ik = 0; ik < (K + 1); ik++) {
	for (int i = 0; i < N; i++) {
		Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + cnt * 4, matrices[il].poly[ik][j].coeff[i]);
		cnt++;
	}}}}
}

// write TRLWE Samples to BRAM
void write_TRLWE(TRLWE* trlwe_inst) {
	int cnt = 0;
	//for (int i = 0; i < N; i++) {
	for (int j = 0; j < (K + 1); j++) {
	for (int i = 0; i < N; i++) {
		Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + TRLWE_OFFSET + cnt * 4, trlwe_inst->poly[j].coeff[i]);
		cnt++;
	}}
}

// write TLWE Sample to BRAM
void write_TLWE(TLWE* c_in) {
	for (int i = 0; i < (DIM + 1); i++) {
		Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + TLWE_OFFSET + i * 4, c_in->coeff[i]);
	}
}

// read TLWE Sample from BRAM
void read_TLWE(TLWE* c_in) {
	for (int i = 0; i < (DIM + 1); i++) {
		c_in->coeff[i] = Xil_In32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + TLWE_OFFSET + i * 4);
	}
}
