-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
-- Date        : Tue Aug 17 01:21:41 2021
-- Host        : Darkwave running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/DarkWave/Desktop/WTFHE/wtfhe-fpga/v1_8_arm_version/wtfhe.srcs/sources_1/ip/xbip_dsp48_macro_1/xbip_dsp48_macro_1_stub.vhdl
-- Design      : xbip_dsp48_macro_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-3
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xbip_dsp48_macro_1 is
  Port ( 
    CLK : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 22 downto 0 );
    B : in STD_LOGIC_VECTOR ( 3 downto 0 );
    P : out STD_LOGIC_VECTOR ( 47 downto 0 )
  );

end xbip_dsp48_macro_1;

architecture stub of xbip_dsp48_macro_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK,SCLR,A[22:0],B[3:0],P[47:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "xbip_dsp48_macro_v3_0_17,Vivado 2020.1";
begin
end;
