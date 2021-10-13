// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Tue Aug 17 01:21:41 2021
// Host        : Darkwave running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/DarkWave/Desktop/WTFHE/wtfhe-fpga/v1_8_arm_version/wtfhe.srcs/sources_1/ip/xbip_dsp48_macro_1/xbip_dsp48_macro_1_sim_netlist.v
// Design      : xbip_dsp48_macro_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg484-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "xbip_dsp48_macro_1,xbip_dsp48_macro_v3_0_17,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "xbip_dsp48_macro_v3_0_17,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module xbip_dsp48_macro_1
   (CLK,
    SCLR,
    A,
    B,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:pcout_intf:carrycascout_intf:carryout_intf:bcout_intf:acout_intf:concat_intf:d_intf:c_intf:b_intf:a_intf:bcin_intf:acin_intf:pcin_intf:carryin_intf:carrycascin_intf:sel_intf, ASSOCIATED_RESET SCLR:SCLRD:SCLRA:SCLRB:SCLRCONCAT:SCLRC:SCLRM:SCLRP:SCLRSEL, ASSOCIATED_CLKEN CE:CED:CED1:CED2:CED3:CEA:CEA1:CEA2:CEA3:CEA4:CEB:CEB1:CEB2:CEB3:CEB4:CECONCAT:CECONCAT3:CECONCAT4:CECONCAT5:CEC:CEC1:CEC2:CEC3:CEC4:CEC5:CEM:CEP:CESEL:CESEL1:CESEL2:CESEL3:CESEL4:CESEL5, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [22:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [3:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [47:0]P;

  wire [22:0]A;
  wire [3:0]B;
  wire CLK;
  wire [47:0]P;
  wire SCLR;
  wire NLW_U0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_U0_CARRYOUT_UNCONNECTED;
  wire [29:0]NLW_U0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_U0_BCOUT_UNCONNECTED;
  wire [47:0]NLW_U0_PCOUT_UNCONNECTED;

  (* C_A_WIDTH = "23" *) 
  (* C_B_WIDTH = "4" *) 
  (* C_CONCAT_WIDTH = "48" *) 
  (* C_CONSTANT_1 = "1" *) 
  (* C_C_WIDTH = "48" *) 
  (* C_D_WIDTH = "18" *) 
  (* C_HAS_A = "1" *) 
  (* C_HAS_ACIN = "0" *) 
  (* C_HAS_ACOUT = "0" *) 
  (* C_HAS_B = "1" *) 
  (* C_HAS_BCIN = "0" *) 
  (* C_HAS_BCOUT = "0" *) 
  (* C_HAS_C = "0" *) 
  (* C_HAS_CARRYCASCIN = "0" *) 
  (* C_HAS_CARRYCASCOUT = "0" *) 
  (* C_HAS_CARRYIN = "0" *) 
  (* C_HAS_CARRYOUT = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_CEA = "0" *) 
  (* C_HAS_CEB = "0" *) 
  (* C_HAS_CEC = "0" *) 
  (* C_HAS_CECONCAT = "0" *) 
  (* C_HAS_CED = "0" *) 
  (* C_HAS_CEM = "0" *) 
  (* C_HAS_CEP = "0" *) 
  (* C_HAS_CESEL = "0" *) 
  (* C_HAS_CONCAT = "0" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_INDEP_CE = "0" *) 
  (* C_HAS_INDEP_SCLR = "0" *) 
  (* C_HAS_PCIN = "0" *) 
  (* C_HAS_PCOUT = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SCLRA = "0" *) 
  (* C_HAS_SCLRB = "0" *) 
  (* C_HAS_SCLRC = "0" *) 
  (* C_HAS_SCLRCONCAT = "0" *) 
  (* C_HAS_SCLRD = "0" *) 
  (* C_HAS_SCLRM = "0" *) 
  (* C_HAS_SCLRP = "0" *) 
  (* C_HAS_SCLRSEL = "0" *) 
  (* C_LATENCY = "128" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_OPMODES = "000000000010010100000000" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "47" *) 
  (* C_REG_CONFIG = "00000000000000000000000000000100" *) 
  (* C_SEL_WIDTH = "0" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  xbip_dsp48_macro_1_xbip_dsp48_macro_v3_0_17 U0
       (.A(A),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_U0_ACOUT_UNCONNECTED[29:0]),
        .B(B),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_U0_BCOUT_UNCONNECTED[17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_U0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYOUT(NLW_U0_CARRYOUT_UNCONNECTED),
        .CE(1'b1),
        .CEA(1'b1),
        .CEA1(1'b1),
        .CEA2(1'b1),
        .CEA3(1'b1),
        .CEA4(1'b1),
        .CEB(1'b1),
        .CEB1(1'b1),
        .CEB2(1'b1),
        .CEB3(1'b1),
        .CEB4(1'b1),
        .CEC(1'b1),
        .CEC1(1'b1),
        .CEC2(1'b1),
        .CEC3(1'b1),
        .CEC4(1'b1),
        .CEC5(1'b1),
        .CECONCAT(1'b1),
        .CECONCAT3(1'b1),
        .CECONCAT4(1'b1),
        .CECONCAT5(1'b1),
        .CED(1'b1),
        .CED1(1'b1),
        .CED2(1'b1),
        .CED3(1'b1),
        .CEM(1'b1),
        .CEP(1'b1),
        .CESEL(1'b1),
        .CESEL1(1'b1),
        .CESEL2(1'b1),
        .CESEL3(1'b1),
        .CESEL4(1'b1),
        .CESEL5(1'b1),
        .CLK(CLK),
        .CONCAT({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .P(P),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_U0_PCOUT_UNCONNECTED[47:0]),
        .SCLR(SCLR),
        .SCLRA(1'b0),
        .SCLRB(1'b0),
        .SCLRC(1'b0),
        .SCLRCONCAT(1'b0),
        .SCLRD(1'b0),
        .SCLRM(1'b0),
        .SCLRP(1'b0),
        .SCLRSEL(1'b0),
        .SEL(1'b0));
endmodule

(* C_A_WIDTH = "23" *) (* C_B_WIDTH = "4" *) (* C_CONCAT_WIDTH = "48" *) 
(* C_CONSTANT_1 = "1" *) (* C_C_WIDTH = "48" *) (* C_D_WIDTH = "18" *) 
(* C_HAS_A = "1" *) (* C_HAS_ACIN = "0" *) (* C_HAS_ACOUT = "0" *) 
(* C_HAS_B = "1" *) (* C_HAS_BCIN = "0" *) (* C_HAS_BCOUT = "0" *) 
(* C_HAS_C = "0" *) (* C_HAS_CARRYCASCIN = "0" *) (* C_HAS_CARRYCASCOUT = "0" *) 
(* C_HAS_CARRYIN = "0" *) (* C_HAS_CARRYOUT = "0" *) (* C_HAS_CE = "0" *) 
(* C_HAS_CEA = "0" *) (* C_HAS_CEB = "0" *) (* C_HAS_CEC = "0" *) 
(* C_HAS_CECONCAT = "0" *) (* C_HAS_CED = "0" *) (* C_HAS_CEM = "0" *) 
(* C_HAS_CEP = "0" *) (* C_HAS_CESEL = "0" *) (* C_HAS_CONCAT = "0" *) 
(* C_HAS_D = "0" *) (* C_HAS_INDEP_CE = "0" *) (* C_HAS_INDEP_SCLR = "0" *) 
(* C_HAS_PCIN = "0" *) (* C_HAS_PCOUT = "0" *) (* C_HAS_SCLR = "1" *) 
(* C_HAS_SCLRA = "0" *) (* C_HAS_SCLRB = "0" *) (* C_HAS_SCLRC = "0" *) 
(* C_HAS_SCLRCONCAT = "0" *) (* C_HAS_SCLRD = "0" *) (* C_HAS_SCLRM = "0" *) 
(* C_HAS_SCLRP = "0" *) (* C_HAS_SCLRSEL = "0" *) (* C_LATENCY = "128" *) 
(* C_MODEL_TYPE = "0" *) (* C_OPMODES = "000000000010010100000000" *) (* C_P_LSB = "0" *) 
(* C_P_MSB = "47" *) (* C_REG_CONFIG = "00000000000000000000000000000100" *) (* C_SEL_WIDTH = "0" *) 
(* C_TEST_CORE = "0" *) (* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "zynq" *) 
(* ORIG_REF_NAME = "xbip_dsp48_macro_v3_0_17" *) (* downgradeipidentifiedwarnings = "yes" *) 
module xbip_dsp48_macro_1_xbip_dsp48_macro_v3_0_17
   (CLK,
    CE,
    SCLR,
    SEL,
    CARRYCASCIN,
    CARRYIN,
    PCIN,
    ACIN,
    BCIN,
    A,
    B,
    C,
    D,
    CONCAT,
    ACOUT,
    BCOUT,
    CARRYOUT,
    CARRYCASCOUT,
    PCOUT,
    P,
    CED,
    CED1,
    CED2,
    CED3,
    CEA,
    CEA1,
    CEA2,
    CEA3,
    CEA4,
    CEB,
    CEB1,
    CEB2,
    CEB3,
    CEB4,
    CECONCAT,
    CECONCAT3,
    CECONCAT4,
    CECONCAT5,
    CEC,
    CEC1,
    CEC2,
    CEC3,
    CEC4,
    CEC5,
    CEM,
    CEP,
    CESEL,
    CESEL1,
    CESEL2,
    CESEL3,
    CESEL4,
    CESEL5,
    SCLRD,
    SCLRA,
    SCLRB,
    SCLRCONCAT,
    SCLRC,
    SCLRM,
    SCLRP,
    SCLRSEL);
  input CLK;
  input CE;
  input SCLR;
  input [0:0]SEL;
  input CARRYCASCIN;
  input CARRYIN;
  input [47:0]PCIN;
  input [29:0]ACIN;
  input [17:0]BCIN;
  input [22:0]A;
  input [3:0]B;
  input [47:0]C;
  input [17:0]D;
  input [47:0]CONCAT;
  output [29:0]ACOUT;
  output [17:0]BCOUT;
  output CARRYOUT;
  output CARRYCASCOUT;
  output [47:0]PCOUT;
  output [47:0]P;
  input CED;
  input CED1;
  input CED2;
  input CED3;
  input CEA;
  input CEA1;
  input CEA2;
  input CEA3;
  input CEA4;
  input CEB;
  input CEB1;
  input CEB2;
  input CEB3;
  input CEB4;
  input CECONCAT;
  input CECONCAT3;
  input CECONCAT4;
  input CECONCAT5;
  input CEC;
  input CEC1;
  input CEC2;
  input CEC3;
  input CEC4;
  input CEC5;
  input CEM;
  input CEP;
  input CESEL;
  input CESEL1;
  input CESEL2;
  input CESEL3;
  input CESEL4;
  input CESEL5;
  input SCLRD;
  input SCLRA;
  input SCLRB;
  input SCLRCONCAT;
  input SCLRC;
  input SCLRM;
  input SCLRP;
  input SCLRSEL;

  wire [22:0]A;
  wire [29:0]ACIN;
  wire [29:0]ACOUT;
  wire [3:0]B;
  wire [17:0]BCIN;
  wire [17:0]BCOUT;
  wire CARRYCASCIN;
  wire CARRYCASCOUT;
  wire CARRYOUT;
  wire CLK;
  wire [47:0]P;
  wire [47:0]PCIN;
  wire [47:0]PCOUT;
  wire SCLR;

  (* C_A_WIDTH = "23" *) 
  (* C_B_WIDTH = "4" *) 
  (* C_CONCAT_WIDTH = "48" *) 
  (* C_CONSTANT_1 = "1" *) 
  (* C_C_WIDTH = "48" *) 
  (* C_D_WIDTH = "18" *) 
  (* C_HAS_A = "1" *) 
  (* C_HAS_ACIN = "0" *) 
  (* C_HAS_ACOUT = "0" *) 
  (* C_HAS_B = "1" *) 
  (* C_HAS_BCIN = "0" *) 
  (* C_HAS_BCOUT = "0" *) 
  (* C_HAS_C = "0" *) 
  (* C_HAS_CARRYCASCIN = "0" *) 
  (* C_HAS_CARRYCASCOUT = "0" *) 
  (* C_HAS_CARRYIN = "0" *) 
  (* C_HAS_CARRYOUT = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_CEA = "0" *) 
  (* C_HAS_CEB = "0" *) 
  (* C_HAS_CEC = "0" *) 
  (* C_HAS_CECONCAT = "0" *) 
  (* C_HAS_CED = "0" *) 
  (* C_HAS_CEM = "0" *) 
  (* C_HAS_CEP = "0" *) 
  (* C_HAS_CESEL = "0" *) 
  (* C_HAS_CONCAT = "0" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_INDEP_CE = "0" *) 
  (* C_HAS_INDEP_SCLR = "0" *) 
  (* C_HAS_PCIN = "0" *) 
  (* C_HAS_PCOUT = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SCLRA = "0" *) 
  (* C_HAS_SCLRB = "0" *) 
  (* C_HAS_SCLRC = "0" *) 
  (* C_HAS_SCLRCONCAT = "0" *) 
  (* C_HAS_SCLRD = "0" *) 
  (* C_HAS_SCLRM = "0" *) 
  (* C_HAS_SCLRP = "0" *) 
  (* C_HAS_SCLRSEL = "0" *) 
  (* C_LATENCY = "128" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_OPMODES = "000000000010010100000000" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "47" *) 
  (* C_REG_CONFIG = "00000000000000000000000000000100" *) 
  (* C_SEL_WIDTH = "0" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  xbip_dsp48_macro_1_xbip_dsp48_macro_v3_0_17_viv i_synth
       (.A(A),
        .ACIN(ACIN),
        .ACOUT(ACOUT),
        .B(B),
        .BCIN(BCIN),
        .BCOUT(BCOUT),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(CARRYCASCIN),
        .CARRYCASCOUT(CARRYCASCOUT),
        .CARRYIN(1'b0),
        .CARRYOUT(CARRYOUT),
        .CE(1'b0),
        .CEA(1'b0),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEA3(1'b0),
        .CEA4(1'b0),
        .CEB(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEB3(1'b0),
        .CEB4(1'b0),
        .CEC(1'b0),
        .CEC1(1'b0),
        .CEC2(1'b0),
        .CEC3(1'b0),
        .CEC4(1'b0),
        .CEC5(1'b0),
        .CECONCAT(1'b0),
        .CECONCAT3(1'b0),
        .CECONCAT4(1'b0),
        .CECONCAT5(1'b0),
        .CED(1'b0),
        .CED1(1'b0),
        .CED2(1'b0),
        .CED3(1'b0),
        .CEM(1'b0),
        .CEP(1'b0),
        .CESEL(1'b0),
        .CESEL1(1'b0),
        .CESEL2(1'b0),
        .CESEL3(1'b0),
        .CESEL4(1'b0),
        .CESEL5(1'b0),
        .CLK(CLK),
        .CONCAT({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .P(P),
        .PCIN(PCIN),
        .PCOUT(PCOUT),
        .SCLR(SCLR),
        .SCLRA(1'b0),
        .SCLRB(1'b0),
        .SCLRC(1'b0),
        .SCLRCONCAT(1'b0),
        .SCLRD(1'b0),
        .SCLRM(1'b0),
        .SCLRP(1'b0),
        .SCLRSEL(1'b0),
        .SEL(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
mVSg04jx48ohF6ET+GPgL/18xNlqSjc68SAwWWVL7ETIEhL/N/IEEa794563sOuKxSt0Kl67y+94
UB0egY5nGg==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
lmyXeW6W5x34OcR/9HBy5DakFHbrAP2VPoaQ3ab68lLfG02ITRD3w7EdbM/TyvDE2AithtcpGANE
xoGGRFEy5XpfEmD0vRdB2QdH78Q3znXmRJJRNPPn0gBDy8HiV5ndsmD/LeinHmOe8eK7LpDgq37J
/At5o0EqFZW3WjRL3sk=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ScNmNM0W62HGNpFgTi5FAXgfrWYsig59kPYL2q8QE5KGweGkCLDCL7Hkobrafd5P88QLcDON+uhX
IyI83xgtYqHn9XvdBn8HqJzARuJNNTON3Zj7Cg0wwXEkJtSsBQmXcAr8B8YlHB5Ot1eWfmo01yW2
ucT2GUyoADNv1dAw9b6BSTAsVTnSGRaLEFNmWdsXqE9NxNE2TgfO5x/a8DTy3f4g5X7/hJLCKpg4
wudzUxG+uR7hx57H8Q09kX8BvU+C37l5Ltf3PNYwwUbKRz/EM4tLYtmrZC9s12buYcsYbj6wNTU7
3gzKdMayi7u7lq3LMlQDerpr0jYxylPt4GrIOA==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
e87Uz7OgoObx921b4TAOTFPf7RdEkGb5ZVAdacGLXY7GMiPCfCc7YMl+VeJl5YDir0JYQiTkbhLh
mLscEPt5ONOoiBzAJqkKFldx6auMyo+P/7DiauuYIbPgkW7umqOxwZfrmjnw20eMtarltmzr6AGp
6aopNGbAJEL+hwyM5JFo5kit3y/Ea4LUEzIW9ld9DY+p0Ihvdhdfy0zQmToIHb/Np9zzKX8tpOC3
Fa4uXF8qCvbeUJr6LjjXyQB+06m7Lz0C23RJ4hC9KIerHxpF3jfuAzHKSvlLatWH1Yh0cIKx7k/y
DKMp82d5B3CU6d7/9rRzzzXEniDDeg47rWYfDg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
N9AuFk0bI81JYG49sYg/AXtRGVFdClaczQEWHn/vG0tDAjhQ2qA0GYN+86AxMP6Eq5ZUOynxdshU
bN1lWaCpVjK938uUJqRzJ07jB62cIexo8C/g1/2x8b1jzFGqoZaH8XuvvhE2jws7SBqjDWp6QqwF
DccZxmM0BtqxnQ0vOxg=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ksqAObrv2EPWm9QjMQbS9Jri8+lbIuMSp3qiCFd7V5lqBbL7GPCdYLZeldgitO6uJU6g/HJUdlqY
vAtACW1AEC8JJxRRn91cFSbi+kvg64hC5Vnug+KdRN6vjapzUK4c/DIOy6/+2jRigEC+IX4vaS+x
i+Oi2k1i9ZiAzw7qzBPTCbiy3fIyNxT8GQf6HanMu/28I8MRYfhgvQ7ol1S003awbKh+hQ0F0PzV
QKh9CDlIz8s1WyXc+huI2QS1FG60KK6XWZ0aalbB+Lt5+x9Z8uV4zUAwJB1XlcNRMiM5SkjkIg9r
y6yFAGmNR5T5BqgWguE62jSBd9Zfnh8JXP2NOQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
yejHCke96a3eh+No32kwjUcXbwCyaPKyFR3prOsF6TJCbrqwfvvxDeC6TSDIUBXnczwcjZGdrJzh
kWpgjQJo/+Fhj4Ofu3XGUwSa6fkycuNX9V9NKeCjQKWKmMwRn7y3etJWdJ9gQzeiKRshRI1cO1mT
xKbyArTNkWP2ZyuWXsKVeN/uv2UAnGmIkXXlm+ydbtEEypSYfKGvayajQjpQkN9HKz13nMpeuMc9
6DMCTp2atZYYbmvMLGsYr48d8enLKwx68sd7DuvTAfi41FUDiRNDI4vopTU0JcRKcjXGPRMY8yoc
XZdRPSINaUGZCdPmtfc2gza4Uxt7sTq51XGfrg==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qGh3mlgVn/697cVM/wVbbB7SoNiFJgOKvbMq77owzjnL3crAcnY8GFt3Q08R5QyrP2hHuw8Lswju
dXYOZ3/oAi7aUy1kyPLhuKPWeWxo3+dYvubUpGt2JG+EAT+jldyl+H25jnvNn+t3heQmGgAsd2nd
MIq2UzPXQ2RVJZa9xZCPPHg1CnXHeNMi4uv/6DX4+JoQGVTyGQXjGOxnxJ5b8V7W4BbY/opssAME
iaFMorNt/wd5IaLUhZ9xN1hAax910Vrp1kXD6WAysFoxMIabE4Oq3hm6M7fi2AGw5K+4HIYSfrvh
X+3VnMAwckadGO97+iJkxqNFTAR1vyW1StWhFw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Pui+6jIzuAMgIrqBhLPkObysF1xlKfNhOoUcMAEnnCukOSOFRG7FlFnE35Y7dv5tVrcj1zyjpjBM
sXZv8anrAKSRvqeJBa6ob74VpJPjY03nbvpX9cKAy/35SoT0G/h13Vq3R2V8237P13necwIXQCfi
FgiqLcEwSK/bMDkKeuJaUpwJpR8qwpPU/FFCN+14kb6y7BVbAlPLvxPiBFnHkQ0W9XitUAeU5Av4
b/BxC9luLD7NZ4l0iN1eD7w84NtO4AbC9x8FYMuqAJcqo8/Zjs/UMMfZBMLhUGeSSe0TmZVZxuPo
q7heU5cfCjNVluZN/Uc2IX1ahWmYJ5tO7GDp5A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
g1TrSShnCDyceV/F4yVFenMqL5xOw5et/YRC+tGphJ4XcxWmKKsSsXvonqQT5+HoswNf9xkG1zTg
hl3mr92HzNCqE7HB/Bm4DVXXO+LEsMpcJL2PoVHekTv0P+BA/piVHsf+RpSet0Ry0WgxZRLFUezt
jKDOPXRo96Ad++JZus+CAneOgAMPSfJBEoHGkRSeSaTeP4eoudJh7QBcUAsENSXCaqMqO1HOkRKM
Sulxkoj6IjMvK7jJ8NThsHjF9RZsKgpZaiQMeWPMb1BjO+E4LeXUJL5L7xd1kqdFNs9GK2Ak/9DM
rVyjgRDeV60WKnKXpXCkYQiqvauoiyhGtgjsuA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fUCmhf19xJ47NaQa3J3HxM3Bg3FLPjM0yqYARTIjYsJ0NMAOEE+bzJ7sXPSMLja3f0EhoHmuaHKz
sXBbcwEL/3j861niQqpSJMdo8Ei6rp8ji6T/fwX3jPXjFBaANAEqj9Ap3qtTCVJcQ6U1vArVz9Mt
eg9NkuuMqnsrMIh0gUhex487Nrcws6m3L7T0aSXyJ+kr1msQE2EKjwE+hmTPKNcm51j+BEpWu9un
OM3nX5tjb4h6qQYwCNNG+VIwLwNp90sUhJ/9EWxWMdxM3Y6kEBCWANv0/MlGEKdtZRo9t2gD9/UA
npcPcPW5GzQxIc9r92ve7SfWX/Fg8Ow+JULbhQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 8816)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
