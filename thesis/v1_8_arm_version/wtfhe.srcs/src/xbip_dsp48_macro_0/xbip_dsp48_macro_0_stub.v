// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Tue Aug 17 01:21:40 2021
// Host        : Darkwave running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top xbip_dsp48_macro_0 -prefix
//               xbip_dsp48_macro_0_ xbip_dsp48_macro_1_stub.v
// Design      : xbip_dsp48_macro_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-3
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "xbip_dsp48_macro_v3_0_17,Vivado 2020.1" *)
module xbip_dsp48_macro_0(CLK, SCLR, A, B, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,SCLR,A[22:0],B[3:0],P[47:0]" */;
  input CLK;
  input SCLR;
  input [22:0]A;
  input [3:0]B;
  output [47:0]P;
endmodule
