
module super_mario_music (
    input wire clk_1MHz, // 1 MHz clock input
    input wire rst,
    // input wire level,   // 추후 레벨 설정을 위한 input
    output reg piezo     // Output for piezo module
);
    // Notes array
    // Appended Notes
    reg [8*4-1:0] notes [612:0];
    // Durations array
    reg [31:0] durations [612:0];
    reg [3:0] divisions = 8;
    integer note_index = 0;       // Current note index
    reg [31:0] counter = 0;       // PWM counter for frequency
    reg [31:0] duration_counter = 0; // Duration counter for each note

    reg [15:0] tempo = 200;
    reg [31:0] tempo_count = 0;
 
    initial begin
        notes[0] = "E5"; durations[0] = 8;
        notes[1] = "E5"; durations[1] = 8;
        notes[2] = "REST"; durations[2] = 8;
        notes[3] = "E5"; durations[3] = 8;
        notes[4] = "REST"; durations[4] = 8;
        notes[5] = "C5"; durations[5] = 8;
        notes[6] = "E5"; durations[6] = 8;
        notes[7] = "G5"; durations[7] = 4;
        notes[8] = "REST"; durations[8] = 4;
        notes[9] = "G4"; durations[9] = 8;
        notes[10] = "REST"; durations[10] = 4;
        notes[11] = "C5"; durations[11] = 6;
        notes[12] = "G4"; durations[12] = 8;
        notes[13] = "REST"; durations[13] = 4;
        notes[14] = "E4"; durations[14] = 6;
        notes[15] = "A4"; durations[15] = 4;
        notes[16] = "B4"; durations[16] = 4;
        notes[17] = "AS4"; durations[17] = 8;
        notes[18] = "A4"; durations[18] = 4;
        notes[19] = "G4"; durations[19] = 12;
        notes[20] = "E5"; durations[20] = 12;
        notes[21] = "G5"; durations[21] = 12;
        notes[22] = "A5"; durations[22] = 4;
        notes[23] = "F5"; durations[23] = 8;
        notes[24] = "G5"; durations[24] = 8;
        notes[25] = "REST"; durations[25] = 8;
        notes[26] = "E5"; durations[26] = 4;
        notes[27] = "C5"; durations[27] = 8;
        notes[28] = "D5"; durations[28] = 8;
        notes[29] = "B4"; durations[29] = 6;
        notes[30] = "C5"; durations[30] = 6;
        notes[31] = "G4"; durations[31] = 8;
        notes[32] = "REST"; durations[32] = 4;
        notes[33] = "E4"; durations[33] = 6;
        notes[34] = "A4"; durations[34] = 4;
        notes[35] = "B4"; durations[35] = 4;
        notes[36] = "AS4"; durations[36] = 8;
        notes[37] = "A4"; durations[37] = 4;
        notes[38] = "G4"; durations[38] = 12;
        notes[39] = "E5"; durations[39] = 12;
        notes[40] = "G5"; durations[40] = 12;
        notes[41] = "A5"; durations[41] = 4;
        notes[42] = "F5"; durations[42] = 8;
        notes[43] = "G5"; durations[43] = 8;
        notes[44] = "REST"; durations[44] = 8;
        notes[45] = "E5"; durations[45] = 4;
        notes[46] = "C5"; durations[46] = 8;
        notes[47] = "D5"; durations[47] = 8;
        notes[48] = "B4"; durations[48] = 6;
        notes[49] = "REST"; durations[49] = 4;
        notes[50] = "G5"; durations[50] = 8;
        notes[51] = "FS5"; durations[51] = 8;
        notes[52] = "F5"; durations[52] = 8;
        notes[53] = "DS5"; durations[53] = 4;
        notes[54] = "E5"; durations[54] = 8;
        notes[55] = "REST"; durations[55] = 8;
        notes[56] = "GS4"; durations[56] = 8;
        notes[57] = "A4"; durations[57] = 8;
        notes[58] = "C4"; durations[58] = 8;
        notes[59] = "REST"; durations[59] = 8;
        notes[60] = "A4"; durations[60] = 8;
        notes[61] = "C5"; durations[61] = 8;
        notes[62] = "D5"; durations[62] = 8;
        notes[63] = "REST"; durations[63] = 4;
        notes[64] = "DS5"; durations[64] = 4;
        notes[65] = "REST"; durations[65] = 8;
        notes[66] = "D5"; durations[66] = 6;
        notes[67] = "C5"; durations[67] = 2;
        notes[68] = "REST"; durations[68] = 2;
        notes[69] = "REST"; durations[69] = 4;
        notes[70] = "G5"; durations[70] = 8;
        notes[71] = "FS5"; durations[71] = 8;
        notes[72] = "F5"; durations[72] = 8;
        notes[73] = "DS5"; durations[73] = 4;
        notes[74] = "E5"; durations[74] = 8;
        notes[75] = "REST"; durations[75] = 8;
        notes[76] = "GS4"; durations[76] = 8;
        notes[77] = "A4"; durations[77] = 8;
        notes[78] = "C4"; durations[78] = 8;
        notes[79] = "REST"; durations[79] = 8;
        notes[80] = "A4"; durations[80] = 8;
        notes[81] = "C5"; durations[81] = 8;
        notes[82] = "D5"; durations[82] = 8;
        notes[83] = "REST"; durations[83] = 4;
        notes[84] = "DS5"; durations[84] = 4;
        notes[85] = "REST"; durations[85] = 8;
        notes[86] = "D5"; durations[86] = 6;
        notes[87] = "C5"; durations[87] = 2;
        notes[88] = "REST"; durations[88] = 2;
        notes[89] = "C5"; durations[89] = 8;
        notes[90] = "C5"; durations[90] = 4;
        notes[91] = "C5"; durations[91] = 8;
        notes[92] = "REST"; durations[92] = 8;
        notes[93] = "C5"; durations[93] = 8;
        notes[94] = "D5"; durations[94] = 4;
        notes[95] = "E5"; durations[95] = 8;
        notes[96] = "C5"; durations[96] = 4;
        notes[97] = "A4"; durations[97] = 8;
        notes[98] = "G4"; durations[98] = 2;
        notes[99] = "C5"; durations[99] = 8;
        notes[100] = "C5"; durations[100] = 4;
        notes[101] = "C5"; durations[101] = 8;
        notes[102] = "REST"; durations[102] = 8;
        notes[103] = "C5"; durations[103] = 8;
        notes[104] = "D5"; durations[104] = 8;
        notes[105] = "E5"; durations[105] = 8;
        notes[106] = "REST"; durations[106] = 1;
        notes[107] = "C5"; durations[107] = 8;
        notes[108] = "C5"; durations[108] = 4;
        notes[109] = "C5"; durations[109] = 8;
        notes[110] = "REST"; durations[110] = 8;
        notes[111] = "C5"; durations[111] = 8;
        notes[112] = "D5"; durations[112] = 4;
        notes[113] = "E5"; durations[113] = 8;
        notes[114] = "C5"; durations[114] = 4;
        notes[115] = "A4"; durations[115] = 8;
        notes[116] = "G4"; durations[116] = 2;
        notes[117] = "E5"; durations[117] = 8;
        notes[118] = "E5"; durations[118] = 8;
        notes[119] = "REST"; durations[119] = 8;
        notes[120] = "E5"; durations[120] = 8;
        notes[121] = "REST"; durations[121] = 8;
        notes[122] = "C5"; durations[122] = 8;
        notes[123] = "E5"; durations[123] = 4;
        notes[124] = "G5"; durations[124] = 4;
        notes[125] = "REST"; durations[125] = 4;
        notes[126] = "G4"; durations[126] = 4;
        notes[127] = "REST"; durations[127] = 4;
        notes[128] = "C5"; durations[128] = 6;
        notes[129] = "G4"; durations[129] = 8;
        notes[130] = "REST"; durations[130] = 4;
        notes[131] = "E4"; durations[131] = 6;
        notes[132] = "A4"; durations[132] = 4;
        notes[133] = "B4"; durations[133] = 4;
        notes[134] = "AS4"; durations[134] = 8;
        notes[135] = "A4"; durations[135] = 4;
        notes[136] = "G4"; durations[136] = 12;
        notes[137] = "E5"; durations[137] = 12;
        notes[138] = "G5"; durations[138] = 12;
        notes[139] = "A5"; durations[139] = 4;
        notes[140] = "F5"; durations[140] = 8;
        notes[141] = "G5"; durations[141] = 8;
        notes[142] = "REST"; durations[142] = 8;
        notes[143] = "E5"; durations[143] = 4;
        notes[144] = "C5"; durations[144] = 8;
        notes[145] = "D5"; durations[145] = 8;
        notes[146] = "B4"; durations[146] = 6;
        notes[147] = "C5"; durations[147] = 6;
        notes[148] = "G4"; durations[148] = 8;
        notes[149] = "REST"; durations[149] = 4;
        notes[150] = "E4"; durations[150] = 6;
        notes[151] = "A4"; durations[151] = 4;
        notes[152] = "B4"; durations[152] = 4;
        notes[153] = "AS4"; durations[153] = 8;
        notes[154] = "A4"; durations[154] = 4;
        notes[155] = "G4"; durations[155] = 12;
        notes[156] = "E5"; durations[156] = 12;
        notes[157] = "G5"; durations[157] = 12;
        notes[158] = "A5"; durations[158] = 4;
        notes[159] = "F5"; durations[159] = 8;
        notes[160] = "G5"; durations[160] = 8;
        notes[161] = "REST"; durations[161] = 8;
        notes[162] = "E5"; durations[162] = 4;
        notes[163] = "C5"; durations[163] = 8;
        notes[164] = "D5"; durations[164] = 8;
        notes[165] = "B4"; durations[165] = 6;
        notes[166] = "E5"; durations[166] = 8;
        notes[167] = "C5"; durations[167] = 4;
        notes[168] = "G4"; durations[168] = 8;
        notes[169] = "REST"; durations[169] = 4;
        notes[170] = "GS4"; durations[170] = 4;
        notes[171] = "A4"; durations[171] = 8;
        notes[172] = "F5"; durations[172] = 4;
        notes[173] = "F5"; durations[173] = 8;
        notes[174] = "A4"; durations[174] = 2;
        notes[175] = "D5"; durations[175] = 12;
        notes[176] = "A5"; durations[176] = 12;
        notes[177] = "A5"; durations[177] = 12;
        notes[178] = "A5"; durations[178] = 12;
        notes[179] = "G5"; durations[179] = 12;
        notes[180] = "F5"; durations[180] = 12;
        notes[181] = "E5"; durations[181] = 8;
        notes[182] = "C5"; durations[182] = 4;
        notes[183] = "A4"; durations[183] = 8;
        notes[184] = "G4"; durations[184] = 2;
        notes[185] = "E5"; durations[185] = 8;
        notes[186] = "C5"; durations[186] = 4;
        notes[187] = "G4"; durations[187] = 8;
        notes[188] = "REST"; durations[188] = 4;
        notes[189] = "GS4"; durations[189] = 4;
        notes[190] = "A4"; durations[190] = 8;
        notes[191] = "F5"; durations[191] = 4;
        notes[192] = "F5"; durations[192] = 8;
        notes[193] = "A4"; durations[193] = 2;
        notes[194] = "B4"; durations[194] = 8;
        notes[195] = "F5"; durations[195] = 4;
        notes[196] = "F5"; durations[196] = 8;
        notes[197] = "F5"; durations[197] = 12;
        notes[198] = "E5"; durations[198] = 12;
        notes[199] = "D5"; durations[199] = 12;
        notes[200] = "C5"; durations[200] = 8;
        notes[201] = "E4"; durations[201] = 4;
        notes[202] = "E4"; durations[202] = 8;
        notes[203] = "C4"; durations[203] = 2;
        notes[204] = "E5"; durations[204] = 8;
        notes[205] = "C5"; durations[205] = 4;
        notes[206] = "G4"; durations[206] = 8;
        notes[207] = "REST"; durations[207] = 4;
        notes[208] = "GS4"; durations[208] = 4;
        notes[209] = "A4"; durations[209] = 8;
        notes[210] = "F5"; durations[210] = 4;
        notes[211] = "F5"; durations[211] = 8;
        notes[212] = "A4"; durations[212] = 2;
        notes[213] = "D5"; durations[213] = 12;
        notes[214] = "A5"; durations[214] = 12;
        notes[215] = "A5"; durations[215] = 12;
        notes[216] = "A5"; durations[216] = 12;
        notes[217] = "G5"; durations[217] = 12;
        notes[218] = "F5"; durations[218] = 12;
        notes[219] = "E5"; durations[219] = 8;
        notes[220] = "C5"; durations[220] = 4;
        notes[221] = "A4"; durations[221] = 8;
        notes[222] = "G4"; durations[222] = 2;
        notes[223] = "E5"; durations[223] = 8;
        notes[224] = "C5"; durations[224] = 4;
        notes[225] = "G4"; durations[225] = 8;
        notes[226] = "REST"; durations[226] = 4;
        notes[227] = "GS4"; durations[227] = 4;
        notes[228] = "A4"; durations[228] = 8;
        notes[229] = "F5"; durations[229] = 4;
        notes[230] = "F5"; durations[230] = 8;
        notes[231] = "A4"; durations[231] = 2;
        notes[232] = "B4"; durations[232] = 8;
        notes[233] = "F5"; durations[233] = 4;
        notes[234] = "F5"; durations[234] = 8;
        notes[235] = "F5"; durations[235] = 12;
        notes[236] = "E5"; durations[236] = 12;
        notes[237] = "D5"; durations[237] = 12;
        notes[238] = "C5"; durations[238] = 8;
        notes[239] = "E4"; durations[239] = 4;
        notes[240] = "E4"; durations[240] = 8;
        notes[241] = "C4"; durations[241] = 2;
        notes[242] = "C5"; durations[242] = 8;
        notes[243] = "C5"; durations[243] = 4;
        notes[244] = "C5"; durations[244] = 8;
        notes[245] = "REST"; durations[245] = 8;
        notes[246] = "C5"; durations[246] = 8;
        notes[247] = "D5"; durations[247] = 8;
        notes[248] = "E5"; durations[248] = 8;
        notes[249] = "REST"; durations[249] = 1;
        notes[250] = "C5"; durations[250] = 8;
        notes[251] = "C5"; durations[251] = 4;
        notes[252] = "C5"; durations[252] = 8;
        notes[253] = "REST"; durations[253] = 8;
        notes[254] = "C5"; durations[254] = 8;
        notes[255] = "D5"; durations[255] = 4;
        notes[256] = "E5"; durations[256] = 8;
        notes[257] = "C5"; durations[257] = 4;
        notes[258] = "A4"; durations[258] = 8;
        notes[259] = "G4"; durations[259] = 2;
        notes[260] = "E5"; durations[260] = 8;
        notes[261] = "E5"; durations[261] = 8;
        notes[262] = "REST"; durations[262] = 8;
        notes[263] = "E5"; durations[263] = 8;
        notes[264] = "REST"; durations[264] = 8;
        notes[265] = "C5"; durations[265] = 8;
        notes[266] = "E5"; durations[266] = 4;
        notes[267] = "G5"; durations[267] = 4;
        notes[268] = "REST"; durations[268] = 4;
        notes[269] = "G4"; durations[269] = 4;
        notes[270] = "REST"; durations[270] = 4;
        notes[271] = "E5"; durations[271] = 8;
        notes[272] = "C5"; durations[272] = 4;
        notes[273] = "G4"; durations[273] = 8;
        notes[274] = "REST"; durations[274] = 4;
        notes[275] = "GS4"; durations[275] = 4;
        notes[276] = "A4"; durations[276] = 8;
        notes[277] = "F5"; durations[277] = 4;
        notes[278] = "F5"; durations[278] = 8;
        notes[279] = "A4"; durations[279] = 2;
        notes[280] = "D5"; durations[280] = 12;
        notes[281] = "A5"; durations[281] = 12;
        notes[282] = "A5"; durations[282] = 12;
        notes[283] = "A5"; durations[283] = 12;
        notes[284] = "G5"; durations[284] = 12;
        notes[285] = "F5"; durations[285] = 12;
        notes[286] = "E5"; durations[286] = 8;
        notes[287] = "C5"; durations[287] = 4;
        notes[288] = "A4"; durations[288] = 8;
        notes[289] = "G4"; durations[289] = 2;
        notes[290] = "E5"; durations[290] = 8;
        notes[291] = "C5"; durations[291] = 4;
        notes[292] = "G4"; durations[292] = 8;
        notes[293] = "REST"; durations[293] = 4;
        notes[294] = "GS4"; durations[294] = 4;
        notes[295] = "A4"; durations[295] = 8;
        notes[296] = "F5"; durations[296] = 4;
        notes[297] = "F5"; durations[297] = 8;
        notes[298] = "A4"; durations[298] = 2;
        notes[299] = "B4"; durations[299] = 8;
        notes[300] = "F5"; durations[300] = 4;
        notes[301] = "F5"; durations[301] = 8;
        notes[302] = "F5"; durations[302] = 12;
        notes[303] = "E5"; durations[303] = 12;
        notes[304] = "D5"; durations[304] = 12;
        notes[305] = "C5"; durations[305] = 8;
        notes[306] = "E4"; durations[306] = 4;
        notes[307] = "E4"; durations[307] = 8;
        notes[308] = "C4"; durations[308] = 2;

        ///////////////////////////////// init reg, output
        note_index = 0;
        counter = 0;
        duration_counter = 0;
        tempo = 200;
        tempo_count = 0;
        piezo <= 0;
    end


    always @(posedge clk_1MHz or posedge rst) begin
        if(rst) begin
            note_index = 0;
            counter = 0;
            duration_counter = 0;
            tempo = 200;
            tempo_count = 0;
            piezo <= 0;
        end
        else begin
            if(frequency(notes[note_index])==0)begin
                piezo <= 0;
            end
            else if (counter >= ((1000000 / frequency(notes[note_index])) / 2)) begin
                piezo <= ~piezo; // Toggle piezo signal
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
            // (durations/divisions)*(60/tempo)*clk
            if (duration_counter >= (((4*60)*1000000)/(durations[note_index]*tempo))) begin
                duration_counter <= 0;
                note_index <= note_index + 1;

                if (note_index == 309) begin // Reset if all notes are played
                    note_index <= 0;
                end
            end else begin
                duration_counter <= duration_counter + 1;
            end
            if(tempo_count >= 5000000) begin
                tempo_count <= 0;
                tempo = tempo + 2;
                if(tempo >= 400)
                    tempo = 400;
                // level에 따라 tempo에 추가되는 숫자 변경하면 됨.
            end
            else begin
                tempo_count <= tempo_count + 1;
            end
        end
    end

    function [31:0] frequency(input [8*4-1:0] note);
        case (note)
            "B0": frequency = 31;
            "C1": frequency = 33;
            "CS1": frequency = 35;
            "D1": frequency = 37;
            "DS1": frequency = 39;
            "E1": frequency = 41;
            "F1": frequency = 44;
            "FS1": frequency = 46;
            "G1": frequency = 49;
            "GS1": frequency = 52;
            "A1": frequency = 55;
            "AS1": frequency = 58;
            "B1": frequency = 62;
            "C2": frequency = 65;
            "CS2": frequency = 69;
            "D2": frequency = 73;
            "DS2": frequency = 78;
            "E2": frequency = 82;
            "F2": frequency = 87;
            "FS2": frequency = 93;
            "G2": frequency = 98;
            "GS2": frequency = 104;
            "A2": frequency = 110;
            "AS2": frequency = 117;
            "B2": frequency = 123;
            "C3": frequency = 131;
            "CS3": frequency = 139;
            "D3": frequency = 147;
            "DS3": frequency = 156;
            "E3": frequency = 165;
            "F3": frequency = 175;
            "FS3": frequency = 185;
            "G3": frequency = 196;
            "GS3": frequency = 208;
            "A3": frequency = 220;
            "AS3": frequency = 233;
            "B3": frequency = 247;
            "C4": frequency = 262;
            "CS4": frequency = 277;
            "D4": frequency = 294;
            "DS4": frequency = 311;
            "E4": frequency = 330;
            "F4": frequency = 349;
            "FS4": frequency = 370;
            "G4": frequency = 392;
            "GS4": frequency = 415;
            "A4": frequency = 440;
            "AS4": frequency = 466;
            "B4": frequency = 494;
            "C5": frequency = 523;
            "CS5": frequency = 554;
            "D5": frequency = 587;
            "DS5": frequency = 622;
            "E5": frequency = 659;
            "F5": frequency = 698;
            "FS5": frequency = 740;
            "G5": frequency = 784;
            "GS5": frequency = 831;
            "A5": frequency = 880;
            "AS5": frequency = 932;
            "B5": frequency = 988;
            "C6": frequency = 1047;
            "CS6": frequency = 1109;
            "D6": frequency = 1175;
            "DS6": frequency = 1245;
            "E6": frequency = 1319;
            "F6": frequency = 1397;
            "FS6": frequency = 1480;
            "G6": frequency = 1568;
            "GS6": frequency = 1661;
            "A6": frequency = 1760;
            "AS6": frequency = 1865;
            "B6": frequency = 1976;
            "C7": frequency = 2093;
            "CS7": frequency = 2217;
            "D7": frequency = 2349;
            "DS7": frequency = 2489;
            "E7": frequency = 2637;
            "F7": frequency = 2794;
            "FS7": frequency = 2960;
            "G7": frequency = 3136;
            "GS7": frequency = 3322;
            "A7": frequency = 3520;
            "AS7": frequency = 3729;
            "B7": frequency = 3951;
            "C8": frequency = 4186;
            "CS8": frequency = 4435;
            "D8": frequency = 4699;
            "DS8": frequency = 4978;
            "REST": frequency = 0;
            default: frequency = 0;
        endcase
    endfunction
endmodule
