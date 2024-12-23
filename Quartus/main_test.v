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
// CREATED		"Sun Dec 22 20:48:46 2024"

module main_test(
	clk,
	rst,
	topbottom,
	postition_rst,
	startBTN,
	rs,
	rw,
	e,
	init_end,
	life0,
	life1,
	life2,
	die,
	piezo,
	motorA,
	motorB,
	motorC,
	motorD,
	com,
	data,
	LED_B,
	LED_G,
	LED_R,
	segdata
);


input wire	clk;
input wire	rst;
input wire	topbottom;
input wire	postition_rst;
input wire	startBTN;
output wire	rs;
output wire	rw;
output wire	e;
output wire	init_end;
output wire	life0;
output wire	life1;
output wire	life2;
output wire	die;
output wire	piezo;
output wire	motorA;
output wire	motorB;
output wire	motorC;
output wire	motorD;
output wire	[7:0] com;
output wire	[7:0] data;
output wire	[3:0] LED_B;
output wire	[3:0] LED_G;
output wire	[3:0] LED_R;
output wire	[6:0] segdata;

wire	[7:0] random;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_87;
wire	SYNTHESIZED_WIRE_88;
wire	SYNTHESIZED_WIRE_89;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_90;
wire	SYNTHESIZED_WIRE_7;
wire	[7:0] SYNTHESIZED_WIRE_9;
wire	[7:0] SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_19;
wire	SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_22;
wire	SYNTHESIZED_WIRE_23;
wire	SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_26;
wire	SYNTHESIZED_WIRE_27;
wire	SYNTHESIZED_WIRE_28;
wire	SYNTHESIZED_WIRE_30;
wire	SYNTHESIZED_WIRE_31;
wire	SYNTHESIZED_WIRE_32;
wire	SYNTHESIZED_WIRE_91;
wire	SYNTHESIZED_WIRE_92;
wire	SYNTHESIZED_WIRE_35;
wire	SYNTHESIZED_WIRE_36;
wire	SYNTHESIZED_WIRE_38;
wire	SYNTHESIZED_WIRE_39;
wire	SYNTHESIZED_WIRE_41;
wire	SYNTHESIZED_WIRE_42;
wire	SYNTHESIZED_WIRE_44;
wire	SYNTHESIZED_WIRE_45;
wire	SYNTHESIZED_WIRE_47;
wire	[7:0] SYNTHESIZED_WIRE_49;
wire	[7:0] SYNTHESIZED_WIRE_50;
wire	SYNTHESIZED_WIRE_51;
wire	SYNTHESIZED_WIRE_53;
wire	SYNTHESIZED_WIRE_56;
wire	SYNTHESIZED_WIRE_93;
wire	SYNTHESIZED_WIRE_58;
wire	SYNTHESIZED_WIRE_59;
wire	SYNTHESIZED_WIRE_61;
wire	SYNTHESIZED_WIRE_62;
wire	SYNTHESIZED_WIRE_64;
wire	SYNTHESIZED_WIRE_65;
wire	[3:0] SYNTHESIZED_WIRE_66;
wire	[3:0] SYNTHESIZED_WIRE_67;
wire	[3:0] SYNTHESIZED_WIRE_68;
wire	[3:0] SYNTHESIZED_WIRE_69;
wire	[3:0] SYNTHESIZED_WIRE_70;
wire	[3:0] SYNTHESIZED_WIRE_71;
wire	[3:0] SYNTHESIZED_WIRE_72;
wire	[3:0] SYNTHESIZED_WIRE_73;
wire	SYNTHESIZED_WIRE_75;
wire	SYNTHESIZED_WIRE_76;
wire	SYNTHESIZED_WIRE_78;
wire	[7:0] SYNTHESIZED_WIRE_80;
wire	[7:0] SYNTHESIZED_WIRE_81;
wire	SYNTHESIZED_WIRE_82;
wire	SYNTHESIZED_WIRE_83;
wire	SYNTHESIZED_WIRE_86;

assign	init_end = SYNTHESIZED_WIRE_87;
assign	die = SYNTHESIZED_WIRE_90;
assign	SYNTHESIZED_WIRE_0 = 0;
assign	SYNTHESIZED_WIRE_5 = 0;
assign	SYNTHESIZED_WIRE_12 = 1;
assign	SYNTHESIZED_WIRE_24 = 0;
assign	SYNTHESIZED_WIRE_28 = 0;
assign	SYNTHESIZED_WIRE_32 = 0;
assign	SYNTHESIZED_WIRE_56 = 0;
assign	SYNTHESIZED_WIRE_61 = 0;
assign	SYNTHESIZED_WIRE_75 = 0;




mx_2x1	b2v_inst(
	.s_1(SYNTHESIZED_WIRE_0),
	.sel(SYNTHESIZED_WIRE_87),
	.s_0(clk),
	.m_out(SYNTHESIZED_WIRE_92));


trigger	b2v_inst1(
	.Din(topbottom),
	.CLK(clk),
	.rst_n(SYNTHESIZED_WIRE_88),
	.Dout(SYNTHESIZED_WIRE_82));


life_count_LED	b2v_inst10(
	.clk(clk),
	.rst(postition_rst),
	.hit(SYNTHESIZED_WIRE_89),
	.life_0(life0),
	.life_1(life1),
	.life_2(life2),
	.die(SYNTHESIZED_WIRE_90));


hit_COLORLED	b2v_inst11(
	.clk(clk),
	.rst(postition_rst),
	.hit(SYNTHESIZED_WIRE_89),
	.BLUE(LED_B),
	.GREEN(LED_G),
	.RED(LED_R));


mx_2x1	b2v_inst12(
	.s_1(SYNTHESIZED_WIRE_5),
	.sel(SYNTHESIZED_WIRE_90),
	.s_0(SYNTHESIZED_WIRE_7),
	.m_out(SYNTHESIZED_WIRE_93));




mx_8bit_2x1	b2v_inst15(
	.ce(SYNTHESIZED_WIRE_87),
	.s0(SYNTHESIZED_WIRE_9),
	.s1(SYNTHESIZED_WIRE_10),
	.m_out(SYNTHESIZED_WIRE_80));



PNU_CLK_DIV	b2v_inst17(
	.clk(clk),
	.rst_n(SYNTHESIZED_WIRE_88),
	.en(SYNTHESIZED_WIRE_12),
	.div_clk(SYNTHESIZED_WIRE_86));
	defparam	b2v_inst17.cnt_num = 5000;


mx_2x1	b2v_inst18(
	.s_1(SYNTHESIZED_WIRE_13),
	.sel(SYNTHESIZED_WIRE_87),
	.s_0(SYNTHESIZED_WIRE_15),
	.m_out(SYNTHESIZED_WIRE_53));


mx_2x1	b2v_inst19(
	.s_1(SYNTHESIZED_WIRE_16),
	.sel(SYNTHESIZED_WIRE_87),
	.s_0(SYNTHESIZED_WIRE_18),
	.m_out(SYNTHESIZED_WIRE_64));

assign	SYNTHESIZED_WIRE_88 =  ~rst;


mx_2x1	b2v_inst20(
	.s_1(SYNTHESIZED_WIRE_19),
	.sel(SYNTHESIZED_WIRE_87),
	.s_0(SYNTHESIZED_WIRE_21),
	.m_out(SYNTHESIZED_WIRE_78));


clk_speed	b2v_inst21(
	.clk(SYNTHESIZED_WIRE_22),
	.rst(postition_rst),
	.game_clk(SYNTHESIZED_WIRE_7),
	.scoreUP(SYNTHESIZED_WIRE_26));

assign	SYNTHESIZED_WIRE_87 =  ~SYNTHESIZED_WIRE_23;


mx_2x1	b2v_inst23(
	.s_1(SYNTHESIZED_WIRE_24),
	.sel(SYNTHESIZED_WIRE_90),
	.s_0(SYNTHESIZED_WIRE_26),
	.m_out(SYNTHESIZED_WIRE_35));



super_mario_music	b2v_inst25(
	.clk_1MHz(SYNTHESIZED_WIRE_27),
	.rst(postition_rst),
	.piezo(SYNTHESIZED_WIRE_38));


mx_2x1	b2v_inst26(
	.s_1(SYNTHESIZED_WIRE_28),
	.sel(SYNTHESIZED_WIRE_90),
	.s_0(SYNTHESIZED_WIRE_30),
	.m_out(SYNTHESIZED_WIRE_27));



start_LCD	b2v_inst28(
	.clk_1MHz(SYNTHESIZED_WIRE_31),
	.rst(postition_rst),
	.lcd_rs(SYNTHESIZED_WIRE_15),
	.lcd_rw(SYNTHESIZED_WIRE_18),
	.lcd_en(SYNTHESIZED_WIRE_21),
	.lcd_data(SYNTHESIZED_WIRE_9));


mx_2x1	b2v_inst29(
	.s_1(SYNTHESIZED_WIRE_32),
	.sel(SYNTHESIZED_WIRE_91),
	.s_0(SYNTHESIZED_WIRE_92),
	.m_out(SYNTHESIZED_WIRE_31));


array8_segment	b2v_inst3(
	.clk(clk),
	.rst(postition_rst),
	.scoreUP(SYNTHESIZED_WIRE_35),
	.com(com),
	.digit1(SYNTHESIZED_WIRE_66),
	.digit2(SYNTHESIZED_WIRE_67),
	.digit3(SYNTHESIZED_WIRE_68),
	.digit4(SYNTHESIZED_WIRE_69),
	.digit5(SYNTHESIZED_WIRE_70),
	.digit6(SYNTHESIZED_WIRE_71),
	.digit7(SYNTHESIZED_WIRE_72),
	.digit8(SYNTHESIZED_WIRE_73),
	.num_data(segdata));



mx_2x1	b2v_inst31(
	.s_1(SYNTHESIZED_WIRE_36),
	.sel(SYNTHESIZED_WIRE_90),
	.s_0(SYNTHESIZED_WIRE_38),
	.m_out(piezo));


mx_2x1	b2v_inst32(
	.s_1(SYNTHESIZED_WIRE_39),
	.sel(SYNTHESIZED_WIRE_90),
	.s_0(SYNTHESIZED_WIRE_41),
	.m_out(rs));


mx_2x1	b2v_inst33(
	.s_1(SYNTHESIZED_WIRE_42),
	.sel(SYNTHESIZED_WIRE_90),
	.s_0(SYNTHESIZED_WIRE_44),
	.m_out(rw));


mx_2x1	b2v_inst34(
	.s_1(SYNTHESIZED_WIRE_45),
	.sel(SYNTHESIZED_WIRE_90),
	.s_0(SYNTHESIZED_WIRE_47),
	.m_out(e));


mx_8bit_2x1	b2v_inst35(
	.ce(SYNTHESIZED_WIRE_90),
	.s0(SYNTHESIZED_WIRE_49),
	.s1(SYNTHESIZED_WIRE_50),
	.m_out(data));


mx_2x1	b2v_inst36(
	.s_1(SYNTHESIZED_WIRE_51),
	.sel(SYNTHESIZED_WIRE_91),
	.s_0(SYNTHESIZED_WIRE_53),
	.m_out(SYNTHESIZED_WIRE_41));


mx_2x1	b2v_inst37(
	.s_1(SYNTHESIZED_WIRE_92),
	.sel(SYNTHESIZED_WIRE_91),
	.s_0(SYNTHESIZED_WIRE_56),
	.m_out(SYNTHESIZED_WIRE_22));


start_game	b2v_inst38(
	.clk(clk),
	.rst(postition_rst),
	.start(startBTN),
	.gamestart(SYNTHESIZED_WIRE_91));



lcd_write_object_char	b2v_inst4(
	.clk(SYNTHESIZED_WIRE_93),
	.rst(postition_rst),
	.obj_zero_bottom_one_top(random[0]),
	.char_zero_bottom_one_top(SYNTHESIZED_WIRE_58),
	.next(SYNTHESIZED_WIRE_59),
	.lcd_rs(SYNTHESIZED_WIRE_51),
	.lcd_rw(SYNTHESIZED_WIRE_62),
	.lcd_en(SYNTHESIZED_WIRE_76),
	.next_output(SYNTHESIZED_WIRE_59),
	.hit(SYNTHESIZED_WIRE_83),
	.lcd_data(SYNTHESIZED_WIRE_81));


mx_2x1	b2v_inst40(
	.s_1(clk),
	.sel(SYNTHESIZED_WIRE_91),
	.s_0(SYNTHESIZED_WIRE_61),
	.m_out(SYNTHESIZED_WIRE_30));



mx_2x1	b2v_inst42(
	.s_1(SYNTHESIZED_WIRE_62),
	.sel(SYNTHESIZED_WIRE_91),
	.s_0(SYNTHESIZED_WIRE_64),
	.m_out(SYNTHESIZED_WIRE_44));


gamemover	b2v_inst43(
	.clk_1MHz(SYNTHESIZED_WIRE_65),
	.rst(postition_rst),
	.digit1(SYNTHESIZED_WIRE_66),
	.digit2(SYNTHESIZED_WIRE_67),
	.digit3(SYNTHESIZED_WIRE_68),
	.digit4(SYNTHESIZED_WIRE_69),
	.digit5(SYNTHESIZED_WIRE_70),
	.digit6(SYNTHESIZED_WIRE_71),
	.digit7(SYNTHESIZED_WIRE_72),
	.digit8(SYNTHESIZED_WIRE_73),
	.piezo(SYNTHESIZED_WIRE_36),
	.lcd_rs(SYNTHESIZED_WIRE_39),
	.lcd_rw(SYNTHESIZED_WIRE_42),
	.lcd_en(SYNTHESIZED_WIRE_45),
	.lcd_data(SYNTHESIZED_WIRE_50));


mx_2x1	b2v_inst44(
	.s_1(clk),
	.sel(SYNTHESIZED_WIRE_90),
	.s_0(SYNTHESIZED_WIRE_75),
	.m_out(SYNTHESIZED_WIRE_65));



mx_2x1	b2v_inst46(
	.s_1(SYNTHESIZED_WIRE_76),
	.sel(SYNTHESIZED_WIRE_91),
	.s_0(SYNTHESIZED_WIRE_78),
	.m_out(SYNTHESIZED_WIRE_47));


mx_8bit_2x1	b2v_inst47(
	.ce(SYNTHESIZED_WIRE_91),
	.s0(SYNTHESIZED_WIRE_80),
	.s1(SYNTHESIZED_WIRE_81),
	.m_out(SYNTHESIZED_WIRE_49));


toggle_keep	b2v_inst5(
	.in(SYNTHESIZED_WIRE_82),
	.clk(clk),
	.rst(postition_rst),
	.out(SYNTHESIZED_WIRE_58));


trigger	b2v_inst6(
	.Din(SYNTHESIZED_WIRE_83),
	.CLK(clk),
	.rst_n(SYNTHESIZED_WIRE_88),
	.Dout(SYNTHESIZED_WIRE_89));


motor	b2v_inst7(
	.clk(SYNTHESIZED_WIRE_93),
	.rst(postition_rst),
	.a(motorA),
	.b(motorB),
	.c(motorC),
	.d(motorD));


lcd_custom_object_init	b2v_inst8(
	.clk(SYNTHESIZED_WIRE_86),
	.rst(postition_rst),
	.lcd_rw(SYNTHESIZED_WIRE_16),
	.lcd_rs(SYNTHESIZED_WIRE_13),
	.lcd_en(SYNTHESIZED_WIRE_19),
	.init_end(SYNTHESIZED_WIRE_23),
	.lcd_data(SYNTHESIZED_WIRE_10));


lfsr_random	b2v_inst9(
	.clk(clk),
	.reset(postition_rst),
	.random(random));


endmodule
