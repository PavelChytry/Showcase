// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Tue Aug 17 01:21:40 2021
// Host        : Darkwave running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top xbip_dsp48_macro_0 -prefix
//               xbip_dsp48_macro_0_ xbip_dsp48_macro_1_sim_netlist.v
// Design      : xbip_dsp48_macro_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg484-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "xbip_dsp48_macro_1,xbip_dsp48_macro_v3_0_17,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "xbip_dsp48_macro_v3_0_17,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module xbip_dsp48_macro_0
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
  xbip_dsp48_macro_0_xbip_dsp48_macro_v3_0_17 U0
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
(* downgradeipidentifiedwarnings = "yes" *) 
module xbip_dsp48_macro_0_xbip_dsp48_macro_v3_0_17
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
  xbip_dsp48_macro_0_xbip_dsp48_macro_v3_0_17_viv i_synth
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
UqPHqKi2fsXXhayaaLldpn+wuT65fePtapwb0nGxre7F1Dr0wCqKzkCxum3rTUiXlCDFotL7qcoq
D7pY6fGS/CHtHDLsAYXTniuEE2GtTNu0qH9XYPk0jMPQjGDK76/2R8ANwOswG93KqBl/KAIDI4lM
2czMVAQKyl69jt1gsvLj3wLp3wmBv+/gx0iG894SjAHAEHMQApRi6gGQyWgNkQDFBxArnkyFYWzt
uzTp/1sId4+/LRLDyW9+oe/Pf8pFhBCOhvC+F9LFp6rMPFsof9WVYHmRDQwZBKaQkDLhhzCcyvMP
Xc8HgaCluiTrgjTfkjQYTKxVKklXUotN8xcJEw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
IRE1oMrT9gnLKzHfdB8PHJN5Z6ZE+MBTNFWlPXNN5783uVN8cFdlHHoz1SPS5FN9OWgCrKTnvpPv
IJ3/WrcL/ghts7eLQFyVDlh19irjaN97WFOA/V09ny4ikkwDcTfMcMm0GLRdb9OiE2bD/KQVf4Sr
KpePa0wh9g7Pw6FMJ02RnzUu4Rf0AdyGhAUCv/DcuATh7cD47vPoTCsrhtdzOwDKN1iKS1Q80K0q
ltXYVR0nXVteTm44UYhqyWKobRYoW6hARXTw+WoBm5AbS4sT0so4q3l5/eu4SLo+XAwJjo306Agw
q5uOYHkZqT6OXGEerc021PREk6UKxgB2++HYpw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 8672)
`pragma protect data_block
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
cXWgi6RgA7Q=
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
