module gamemover (
    input wire clk_1MHz, // 1 MHz clock input
    input wire rst,
    input [3:0] digit1,  // 첫 번째 자리수 (0~9)
    input [3:0] digit2,  // 두 번째 자리수 (0~9)
    input [3:0] digit3,  // 세 번째 자리수 (0~9)
    input [3:0] digit4,  // 네 번째 자리수 (0~9)
    input [3:0] digit5,  // 다섯 번째 자리수 (0~9)
    input [3:0] digit6,  // 여섯 번째 자리수 (0~9)
    input [3:0] digit7,  // 일곱 번째 자리수 (0~9)
    input [3:0] digit8,  // 여덟 번째 자리수 (0~9)

    output reg piezo,     // Output for piezo module
    output reg lcd_rs,               // 레지스터 선택 신호
    output reg lcd_rw,               // 읽기/쓰기 신호
    output reg lcd_en,                // Enable 신호
    output reg [7:0] lcd_data    // D4-D7 데이터 핀
);
    // Notes array
    // Appended Notes
    reg [31:0] notes [12:0];
    // Durations array
    reg [31:0] durations [12:0];
    reg [3:0] divisions = 8;
    integer note_index = 0;       // Current note index
    reg [31:0] counter = 0;       // PWM counter for frequency
    reg [31:0] duration_counter = 0; // Duration counter for each note

    reg [15:0] tempo = 200;
    reg [15:0] state = 0;

    reg [7:0] line1_data [15:0];
    reg [7:0] line2_data [15:0];
    reg [3:0] pos = 0;
    reg [15:0] lcd_count = 0;

    initial begin
        notes[0] = "REST"; durations[0] = 8;
        notes[1] = "C5";   durations[1] = 6;
        notes[2] = "G4";   durations[2] = 6;
        notes[3] = "E4";   durations[3] = 4;
        notes[4] = "A4";   durations[4] = 12;
        notes[5] = "B4";   durations[5] = 12;
        notes[6] = "A4";   durations[6] = 12;
        notes[7] = "GS4";  durations[7] = 12;
        notes[8] = "AS4";  durations[8] = 12;
        notes[9] = "GS4";  durations[9] = 12;
        notes[10] = "G4";  durations[10] = 8;
        notes[11] = "D4";  durations[11] = 8;
        notes[12] = "E4";  durations[12] = 3;

        ///////////////////////////////// init reg, output
        note_index = 0;
        counter = 0;
        duration_counter = 0;
        tempo = 200;
        piezo <= 0;
        state = 0;
        lcd_count = 0;

        pos = 0;
        line1_data[0] = 8'h20;
        line1_data[1] = 8'h20;
        line1_data[2] = 8'h20;
        line1_data[3] = 8'h20;
        line1_data[4] = 8'h47;  //G
        line1_data[5] = 8'h41;  //A
        line1_data[6] = 8'h4d;  //M
        line1_data[7] = 8'h45;  //E
        line1_data[8] = 8'h4f;  //O
        line1_data[9] = 8'h56;  //V
        line1_data[10] = 8'h45; //E
        line1_data[11] = 8'h52; //R
        line1_data[12] = 8'h20;
        line1_data[13] = 8'h20;
        line1_data[14] = 8'h20;
        line1_data[15] = 8'h20;
        // 47 41 4d 45 4f 56 45 52

        line2_data[0] = 8'h20;
        line2_data[1] = 8'h53;  //S
        line2_data[2] = 8'h43;  //C
        line2_data[3] = 8'h4f;  //O
        line2_data[4] = 8'h52;  //R
        line2_data[5] = 8'h45;  //E
        line2_data[6] = 8'h3a;  //:
        line2_data[7] = 8'h30;  //0
        line2_data[8] = 8'h30;  //0
        line2_data[9] = 8'h30;  //0
        line2_data[10] = 8'h30; //0
        line2_data[11] = 8'h30; //0
        line2_data[12] = 8'h30; //0
        line2_data[13] = 8'h30; //0
        line2_data[14] = 8'h30; //0
        line2_data[15] = 8'h20;
        // 53 43 4f 52 45 3a 30 30 30 30 30 30 30 30
    end


    always @(posedge clk_1MHz or posedge rst) begin
        if(rst) begin
            note_index = 0;
            counter = 0;
            duration_counter = 0;
            tempo = 200;
            piezo <= 0;
            state = 0;
            lcd_count = 0;

            pos = 0;
            line1_data[0] = 8'h20;
            line1_data[1] = 8'h20;
            line1_data[2] = 8'h20;
            line1_data[3] = 8'h20;
            line1_data[4] = 8'h47;  //G
            line1_data[5] = 8'h41;  //A
            line1_data[6] = 8'h4d;  //M
            line1_data[7] = 8'h45;  //E
            line1_data[8] = 8'h4f;  //O
            line1_data[9] = 8'h56;  //V
            line1_data[10] = 8'h45; //E
            line1_data[11] = 8'h52; //R
            line1_data[12] = 8'h20;
            line1_data[13] = 8'h20;
            line1_data[14] = 8'h20;
            line1_data[15] = 8'h20;
            // 47 41 4d 45 4f 56 45 52

            line2_data[0] = 8'h20;
            line2_data[1] = 8'h53;  //S
            line2_data[2] = 8'h43;  //C
            line2_data[3] = 8'h4f;  //O
            line2_data[4] = 8'h52;  //R
            line2_data[5] = 8'h45;  //E
            line2_data[6] = 8'h3a;  //:
            line2_data[7] = 8'h30;  //0
            line2_data[8] = 8'h30;  //0
            line2_data[9] = 8'h30;  //0
            line2_data[10] = 8'h30; //0
            line2_data[11] = 8'h30; //0
            line2_data[12] = 8'h30; //0
            line2_data[13] = 8'h30; //0
            line2_data[14] = 8'h30; //0
            line2_data[15] = 8'h20;

        end
        else begin
            line2_data[7] = (digit8 | 8'h30);  //0
            line2_data[8] = (digit7 | 8'h30);  //0
            line2_data[9] = (digit6 | 8'h30);  //0
            line2_data[10] = (digit5 | 8'h30); //0
            line2_data[11] = (digit4 | 8'h30); //0
            line2_data[12] = (digit3 | 8'h30); //0
            line2_data[13] = (digit2 | 8'h30); //0
            line2_data[14] = (digit1 | 8'h30); //0
            case(state)
                0: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 1;
                        lcd_count = 0;
                    end
                end
                1: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 2;
                        lcd_count = 0;
                    end
                end
                2: begin
                    // 문자 데이터 출력
                    lcd_data <= line1_data[pos]; // 캐릭터 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 3;
                        lcd_count = 0;
                    end
                end
                3: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        lcd_count = 0;
                        if(pos<15) begin
                            pos = pos + 1;
                            state <= 0;
                        end
                        else begin
                            pos = 0;
                            state <= 4;
                        end
                    end
                end
                4: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'b11000000 | pos);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 5;
                        lcd_count = 0;
                    end
                end
                5: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 6;
                        lcd_count = 0;
                    end
                end
                6: begin
                    // 문자 데이터 출력
                    lcd_data <= line2_data[pos]; // 캐릭터 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 7;
                        lcd_count = 0;
                    end
                end
                7: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        if(pos<15) begin
                            pos = pos + 1;
                            state <= 4;
                        end
                        else begin
                            pos = 0;
                            state <= 8;
                        end
                        lcd_count = 0;
                    end
                end
                100: begin
                    piezo <= 0;
                end
                default: begin
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

                        if (note_index == 13) begin // Reset if all notes are played
                            note_index <= 0;
                            state = 100;
                        end
                    end else begin
                        duration_counter <= duration_counter + 1;
                    end
                end
            endcase
        end
    end

    function [31:0] frequency(input [31:0] note);
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
