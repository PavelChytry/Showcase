// https://blog.mbedded.ninja/programming/operating-systems/linux/linux-serial-ports-using-c-cpp/#basic-setup-in-c

// C library headers
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

// Linux headers
#include <fcntl.h> // Contains file controls like O_RDWR
#include <errno.h> // Error integer and strerror() function
#include <termios.h> // Contains POSIX terminal control definitions
#include <unistd.h> // write(), read(), close()

#include <iostream>
#include <fstream>
#include <unistd.h>

#include <time.h>
#include <chrono>

using namespace std;

const unsigned int N = 32; //32
const unsigned int PI = 3; //
const unsigned int DIM = 4;
const unsigned int K = 1;
const unsigned int L = 5; //5
const unsigned int TAU = 22; //22
const unsigned int GAMMA = 3;
const unsigned int NUM_OF_NN = 3;
const unsigned int signum[8] = { 0, 1, 1, 1, 0, 7, 7, 7 }; //negacyclic signum function

														   //coeff[0] == a * x^0, coeff[1] == a * x^1 etc.
struct polynomial {
	unsigned int coeff[N];
};

// 
struct matrix {
	unsigned int rows;
	unsigned int cols;
	unsigned int *coeff;
};

// TLWE Sample
struct TLWE {
	unsigned int coeff[DIM + 1];
};

// TRLWE Sample
struct TRLWE {
	polynomial poly[(K + 1)];
};

// TRGSW Sample
struct TRGSW {
	polynomial poly[(K + 1)][(K + 1) * L];
};

// Function headers
void encrypt_fn(unsigned int* input_vector, TRLWE* poly);
void encrypt(unsigned int* key, unsigned int input, TLWE* poly);
int decrypt(unsigned int* key, TLWE* poly);
void gen_TRGSW(TRGSW* matrices, unsigned int* key, unsigned int* input);
void matrix_multiply(matrix synapses, TLWE** input, unsigned int *tlwe_rows);
void pt_multiply(matrix synapses, unsigned int** input, unsigned int* length);
unsigned int pt_signum(unsigned int input);
void neural_demo(int serial_port, termios* tty);
int uart_setup(termios* tty, int serial_port);
void load_matrices(matrix* nn);
void cycle_poly(polynomial* x);
void poly_multiply(polynomial t, polynomial y, polynomial* r);
void gen_TRGSW(TRGSW* matrices, unsigned int* key);
void send_TRGSW(int serial_port, TRGSW* matrices);
void send_TRLWE(int serial_port, TRLWE trlwe_inst);
void send_TLWE(int serial_port, TLWE c_in);
void read_TLWE(int serial_port, TLWE* c_in);

// Main
int main(int argc, char *argv[]) {
	// Init timers and rng
	setbuf(stdout, NULL);
	time_t start, end;
	chrono::steady_clock::time_point begin = chrono::steady_clock::now();
	srand(time(NULL));

	// Init serial port
	int serial_port = open("/dev/ttyUSB0", O_RDWR);
	// Check for errors
	if (serial_port < 0) {
		printf("Error %i from open: %s\n", errno, strerror(errno));
		return 1;
	}

	struct termios tty;

	// Check for errors
	if (tcgetattr(serial_port, &tty) != 0) {
		printf("Error %i from tcgetattr: %s\n", errno, strerror(errno));
		return 2;
	}

	// Check correct initialization of serial port
	if (uart_setup(&tty, serial_port) != 0) return 3;

	// run WTFHE demo
	neural_demo(serial_port, &tty);

	// Clean up
	close(serial_port);

	chrono::steady_clock::time_point done = chrono::steady_clock::now();
	cout << "Time difference = " << chrono::duration_cast<std::chrono::microseconds>(done - begin).count() << "[µs]" << endl;
	return 0;
}

// WTFHE Demo
void neural_demo(int serial_port, termios* tty) {
	// Timer and result file init
	ofstream results;
	results.open("test.dat", ios::out | ios::app);
	results << endl << "v1.7 100 cyklu" << endl;

	chrono::steady_clock::time_point begin = chrono::steady_clock::now();
	chrono::steady_clock::time_point end = chrono::steady_clock::now();

	chrono::steady_clock::time_point bsbegin = chrono::steady_clock::now();
	chrono::steady_clock::time_point bsend = chrono::steady_clock::now();

	// generate bootstrapping matrices
	unsigned int key[DIM] = { 1,1,0,1 };
	TRGSW matrices[(DIM * 3 / 2)];
	gen_TRGSW(matrices, key);

	// loop whole neural network evaluation to get measurements
	for (int big_loop = 0; big_loop < 1; big_loop++) {
		printf("loop: %u ", big_loop); fflush(stdout);
		results << big_loop << " ";

		unsigned int pt_length = 3; // plain text length
		unsigned int test_vector[DIM] = { 0,1,1,1 }; // encrypted function
		unsigned int input_vector[pt_length] = { 1,1,0 }; // plain text
		unsigned int output_vector[pt_length]; // output plain text
		unsigned int tlwe_rows = 3; // number of tlwe instances

									// init cipher text
		TLWE* c_in;
		c_in = (TLWE*)malloc(tlwe_rows * sizeof(TLWE));

		// init second plain text for unencrypted evaluation
		unsigned int* p_in;
		p_in = (unsigned int*)malloc(pt_length);

		for (int i = 0; i < pt_length; i++) {
			p_in[i] = input_vector[i];
		}

		// load definition of neural matrices
		matrix nn[NUM_OF_NN];
		load_matrices(nn);

		// encrypt plain text to TLWE Sample
		for (int i = 0; i < 3; i++) {
			encrypt(key, input_vector[i], &c_in[i]);
		}

		// encrypt evaluated function into TRLWE Sample
		TRLWE trlwe_inst;
		encrypt_fn(test_vector, &trlwe_inst);

		bsbegin = chrono::steady_clock::now();
		// send TRGSW Samples once
		send_TRGSW(serial_port, matrices);

		// bootstrapping over neural matrices
		for (int iter = 0; iter < NUM_OF_NN; iter++) { // iterate over neural matrices
			printf("iter: %u\n", iter); fflush(stdout);

			// perceptron eval for cipher and plain text
			matrix_multiply(nn[iter], &c_in, &tlwe_rows); // calc new c_in
			pt_multiply(nn[iter], &p_in, &pt_length); // calc new p_in	

													  // bootstrapping loop -- bootstrap every TLWE Sample
			for (int row = 0; row < tlwe_rows; row++) {
				begin = chrono::steady_clock::now();
				//send data
				send_TRLWE(serial_port, trlwe_inst);
				send_TLWE(serial_port, c_in[row]);

				// read result
				read_TLWE(serial_port, &c_in[row]);

				// save duration of one bootstrapping
				end = chrono::steady_clock::now();
				results << chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << " ";
			}
			//print first result
			if (big_loop == 0) {
				for (int row = 0; row < tlwe_rows; row++) {
					for (int c = 0; c < DIM + 1; c++) {
						printf("%u ", c_in[row].coeff[c]);
					} printf("\n");
				}
			}
		}

		// decrypt TLWE Sample to plain text
		for (int i = 0; i < 3; i++) {
			output_vector[i] = decrypt(key, &c_in[i]);
		}

		// print decrypted cipher text and homomorphically evaluated unencrypted plain text
		for (int i = 0; i < pt_length; i++) {
			cout << output_vector[i] << " ";
		} cout << endl;

		for (int i = 0; i < pt_length; i++) {
			cout << p_in[i] << " ";
		} cout << endl;

		// save duration of whole NN evaluation
		bsend = chrono::steady_clock::now();
		results << chrono::duration_cast<std::chrono::microseconds>(bsend - bsbegin).count() << endl;

		//clean up
		free(c_in);
		free(p_in);
		for (int i = 0; i < 3; i++) {
			free(nn[i].coeff);
		}
		printf("\n"); fflush(stdout);
	}


	results.close();
	return;
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
		trlwe_inst->poly[1].coeff[i] = ((1 << PI) - tmp.coeff[(i + N / (int)pow(2, PI)) % N] << (TAU - PI)) % (1 << TAU);
		trlwe_inst->poly[0].coeff[i] = 0;
	}
}

// encrypt plain text into TLWE Sample
void encrypt(unsigned int* key, unsigned int input, TLWE* poly) {
	//init a with random values
	for (int i = 0; i < DIM; i++) {
		poly->coeff[i] = rand() % (1 << TAU);
	}
	//calculate b
	poly->coeff[DIM] = input << (TAU - PI);
	for (int i = 0; i < DIM; i++) {
		poly->coeff[DIM] += key[i] * poly->coeff[i];
	}
	poly->coeff[DIM] += (rand() % 3) - 1; // add noise <-1,0,1>
	poly->coeff[DIM] = poly->coeff[DIM] % (1 << TAU);
	return;
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
	unsigned int* res = (unsigned int*)malloc(synapses.rows);
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

// UART setup
// src: https://blog.mbedded.ninja/programming/operating-systems/linux/linux-serial-ports-using-c-cpp/#basic-setup-in-c
int uart_setup(termios* tty, int serial_port) {
	tty->c_cflag &= ~PARENB; // Clear parity bit, disabling parity (most common)
	tty->c_cflag &= ~CSTOPB;

	tty->c_cflag &= ~CSIZE;
	tty->c_cflag |= CS8;
	tty->c_cflag &= ~CRTSCTS;
	tty->c_cflag |= CREAD | CLOCAL;

	tty->c_lflag &= ~ICANON;
	tty->c_lflag &= ~ECHO; // Disable echo
	tty->c_lflag &= ~ECHOE; // Disable erasure
	tty->c_lflag &= ~ECHONL; // Disable new-line echo
	tty->c_lflag &= ~ISIG;

	tty->c_iflag &= ~(IXON | IXOFF | IXANY);
	tty->c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL);

	tty->c_oflag &= ~OPOST; // Prevent special interpretation of output bytes (e.g. newline chars)
	tty->c_oflag &= ~ONLCR; // Prevent conversion of newline to carriage return/line feed

	tty->c_cc[VTIME] = 0;
	tty->c_cc[VMIN] = (DIM + 1) * 4; // block until we get the whole result

									 // Set in/out baud rate to be 115200
	cfsetispeed(tty, B115200);
	cfsetospeed(tty, B115200);

	// Save tty settings, also checking for error
	if (tcsetattr(serial_port, TCSANOW, tty) != 0) {
		printf("Error %i from tcsetattr: %s\n", errno, strerror(errno));
		return 1;
	}
	return 0;
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
			}
		}
	}

	//calculate second column
	for (int il = 0; il < (DIM * 3 / 2); il++) {
		for (int j = 0; j < (K + 1) * L; j++) {
			poly_multiply(matrices[il].poly[0][j], ext_key, &matrices[il].poly[1][j]);
			for (int i = 0; i < N; i++) {
				matrices[il].poly[1][j].coeff[i] += (rand() % 3) - 1; // add noise <-1,0,1>
				matrices[il].poly[1][j].coeff[i] = matrices[il].poly[1][j].coeff[i] % (1 << TAU);
			}
		}
	}

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

// send TRGSW Samples over UART
void send_TRGSW(int serial_port, TRGSW* matrices) {
	//printf("matrices\n");
	// BK matrices
	unsigned char msg[4] = { 0x4D, 0x4F, 0x4F, 0x4E }; // control code
	write(serial_port, msg, sizeof(msg));
	for (int il = 0; il < (DIM * 3 / 2); il++) {
		for (int j = 0; j < (K + 1) * L; j++) {
			for (int ik = 0; ik < (K + 1); ik++) {
				for (int i = 0; i < N; i++) {
					msg[3] = static_cast<unsigned char>(matrices[il].poly[ik][j].coeff[i] & 0xFF);
					msg[2] = static_cast<unsigned char>((matrices[il].poly[ik][j].coeff[i] >> 8) & 0xFF);
					msg[1] = static_cast<unsigned char>((matrices[il].poly[ik][j].coeff[i] >> 16) & 0xFF);
					msg[0] = static_cast<unsigned char>((matrices[il].poly[ik][j].coeff[i] >> 24) & 0xFF);
					write(serial_port, msg, sizeof(msg));
				}
			}
		}
	}
}

// send TRLWE Samples over UART
void send_TRLWE(int serial_port, TRLWE trlwe_inst) {
	//printf("polynomials\n");
	// two polynomials
	unsigned char msg[4] = { 0x59, 0x4F, 0x4C, 0x4F }; // control code
	write(serial_port, msg, sizeof(msg));
	for (int j = 0; j < (K + 1); j++) {
		for (int i = 0; i < N; i++) {
			msg[3] = static_cast<unsigned char>(trlwe_inst.poly[j].coeff[i] & 0xFF);
			msg[2] = static_cast<unsigned char>((trlwe_inst.poly[j].coeff[i] >> 8) & 0xFF);
			msg[1] = static_cast<unsigned char>((trlwe_inst.poly[j].coeff[i] >> 16) & 0xFF);
			msg[0] = static_cast<unsigned char>((trlwe_inst.poly[j].coeff[i] >> 24) & 0xFF);
			write(serial_port, msg, sizeof(msg));
		}
	}
}

// send TLWE Sample over UART
void send_TLWE(int serial_port, TLWE c_in) {
	//printf("tlwe\n");
	// TLWE
	unsigned char msg[4] = { 0,0,0,0 };
	for (int i = 0; i < (DIM + 1); i++) {
		msg[3] = static_cast<unsigned char>(c_in.coeff[i] & 0xFF);
		msg[2] = static_cast<unsigned char>((c_in.coeff[i] >> 8) & 0xFF);
		msg[1] = static_cast<unsigned char>((c_in.coeff[i] >> 16) & 0xFF);
		msg[0] = static_cast<unsigned char>((c_in.coeff[i] >> 24) & 0xFF);
		write(serial_port, msg, sizeof(msg));
	}
}

// receive TLWE Sample from UART
void read_TLWE(int serial_port, TLWE* c_in) {
	unsigned char read_buf[4 * (DIM + 1)];
	int bytes = read(serial_port, &read_buf, sizeof(read_buf));
	//printf("recv: %d\n", bytes);
	for (int i = 0; i < (DIM + 1); i++) {
		c_in->coeff[i] = (read_buf[i * 4] << 24) + (read_buf[i * 4 + 1] << 16) + (read_buf[i * 4 + 2] << 8) + read_buf[i * 4 + 3];
	}
}