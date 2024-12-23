// Copyright (C) 2020  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"
// CREATED		"Sun Nov 24 17:17:38 2024"

module mx_8bit_2x1(
	ce,
	s0,
	s1,
	m_out
);


input wire	ce;
input wire	[7:0] s0;
input wire	[7:0] s1;
output wire	[7:0] m_out;

wire	[7:0] l_s0;
wire	[7:0] l_s1;
wire	[7:0] m_line;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_17;
wire	SYNTHESIZED_WIRE_22;
wire	SYNTHESIZED_WIRE_23;




assign	SYNTHESIZED_WIRE_23 = l_s1[0] & ce;

assign	SYNTHESIZED_WIRE_1 = l_s1[1] & ce;

assign	m_line[1] = SYNTHESIZED_WIRE_0 | SYNTHESIZED_WIRE_1;

assign	m_line[2] = SYNTHESIZED_WIRE_2 | SYNTHESIZED_WIRE_3;

assign	m_line[3] = SYNTHESIZED_WIRE_4 | SYNTHESIZED_WIRE_5;

assign	SYNTHESIZED_WIRE_10 = SYNTHESIZED_WIRE_24 & l_s0[4];

assign	SYNTHESIZED_WIRE_12 = SYNTHESIZED_WIRE_24 & l_s0[5];

assign	SYNTHESIZED_WIRE_14 = SYNTHESIZED_WIRE_24 & l_s0[6];

assign	SYNTHESIZED_WIRE_16 = SYNTHESIZED_WIRE_24 & l_s0[7];

assign	SYNTHESIZED_WIRE_11 = l_s1[4] & ce;

assign	SYNTHESIZED_WIRE_13 = l_s1[5] & ce;

assign	SYNTHESIZED_WIRE_15 = l_s1[6] & ce;

assign	SYNTHESIZED_WIRE_3 = l_s1[2] & ce;

assign	SYNTHESIZED_WIRE_17 = l_s1[7] & ce;

assign	m_line[4] = SYNTHESIZED_WIRE_10 | SYNTHESIZED_WIRE_11;

assign	m_line[5] = SYNTHESIZED_WIRE_12 | SYNTHESIZED_WIRE_13;

assign	m_line[6] = SYNTHESIZED_WIRE_14 | SYNTHESIZED_WIRE_15;

assign	m_line[7] = SYNTHESIZED_WIRE_16 | SYNTHESIZED_WIRE_17;

assign	SYNTHESIZED_WIRE_5 = l_s1[3] & ce;

assign	SYNTHESIZED_WIRE_22 = SYNTHESIZED_WIRE_24 & l_s0[0];

assign	SYNTHESIZED_WIRE_0 = SYNTHESIZED_WIRE_24 & l_s0[1];

assign	SYNTHESIZED_WIRE_2 = SYNTHESIZED_WIRE_24 & l_s0[2];

assign	SYNTHESIZED_WIRE_4 = SYNTHESIZED_WIRE_24 & l_s0[3];

assign	SYNTHESIZED_WIRE_24 =  ~ce;

assign	m_line[0] = SYNTHESIZED_WIRE_22 | SYNTHESIZED_WIRE_23;

assign	m_out = m_line;
assign	l_s0 = s0;
assign	l_s1 = s1;

endmodule
