module instraw_LCD (
    input wire clk_1MHz, // 1 MHz clock input
    input wire rst,
    input wire [3:0] Din,

    output reg lcd_rs,               // 레지스터 선택 신호
    output reg lcd_rw,               // 읽기/쓰기 신호
    output reg lcd_en,                // Enable 신호
    output reg [7:0] lcd_data    // D4-D7 데이터 핀
);
    reg [15:0] state = 0;
    reg [7:0] line1_data [15:0];
    reg [7:0] line2_data [15:0];
    reg [3:0] pos = 0;
    reg [15:0] lcd_count = 0;

    initial begin
        ///////////////////////////////// init reg, output
        state = 0;
        lcd_count = 0;

        pos = 0;
        line1_data[0] = 8'h20;
        line1_data[1] = 8'h20;
        line1_data[2] = 8'h20;
        line1_data[3] = 8'h20;
        line1_data[4] = 8'h20;  //
        line1_data[5] = 8'h20;  //
        line1_data[6] = 8'h58;  //X
        line1_data[7] = 8'h4f;  //O
        line1_data[8] = 8'h52;  //R
        line1_data[9] = 8'h20;  //
        line1_data[10] = 8'h20; //
        line1_data[11] = 8'h20; //
        line1_data[12] = 8'h20;
        line1_data[13] = 8'h20;
        line1_data[14] = 8'h20;
        line1_data[15] = 8'h20;
        // 47 41 4d 45 4f 56 45 52

        line2_data[0] = 8'h20;
        line2_data[1] = 8'h20;  //S
        line2_data[2] = 8'h20;  //C
        line2_data[3] = 8'h20;  //O
        line2_data[4] = 8'h20;  //R
        line2_data[5] = 8'h20;  //E
        line2_data[6] = 8'h20;  //:
        line2_data[7] = 8'h20;  //0
        line2_data[8] = 8'h20;  //0
        line2_data[9] = 8'h20;  //0
        line2_data[10] = 8'h20; //0
        line2_data[11] = 8'h20; //0
        line2_data[12] = 8'h20; //0
        line2_data[13] = 8'h20; //0
        line2_data[14] = 8'h20; //0
        line2_data[15] = 8'h20;
        // 53 43 4f 52 45 3a 30 30 30 30 30 30 30 30
    end


    always @(posedge clk_1MHz or posedge rst) begin
        if(rst) begin
            state = 0;
            lcd_count = 0;

            pos = 0;
            line1_data[0] = 8'h20;
            line1_data[1] = 8'h20;
            line1_data[2] = 8'h20;
            line1_data[3] = 8'h20;
            line1_data[4] = 8'h20;  //
            line1_data[5] = 8'h20;  //
            line1_data[6] = 8'h58;  //X
            line1_data[7] = 8'h4f;  //O
            line1_data[8] = 8'h52;  //R
            line1_data[9] = 8'h20;  //
            line1_data[10] = 8'h20; //
            line1_data[11] = 8'h20; //
            line1_data[12] = 8'h20;
            line1_data[13] = 8'h20;
            line1_data[14] = 8'h20;
            line1_data[15] = 8'h20;
            // 47 41 4d 45 4f 56 45 52

            line2_data[0] = 8'h20;
            line2_data[1] = 8'h20;  //S
            line2_data[2] = 8'h20;  //C
            line2_data[3] = 8'h20;  //O
            line2_data[4] = 8'h20;  //R
            line2_data[5] = 8'h20;  //E
            line2_data[6] = 8'h20;  //:
            line2_data[7] = 8'h20;  //0
            line2_data[8] = 8'h20;  //0
            line2_data[9] = 8'h20;  //0
            line2_data[10] = 8'h20; //0
            line2_data[11] = 8'h20; //0
            line2_data[12] = 8'h20; //0
            line2_data[13] = 8'h20; //0
            line2_data[14] = 8'h20; //0
            line2_data[15] = 8'h20;

        end
        else begin
            if(Din == 4'b0001) begin
                line1_data[0] = 8'h20;
                line1_data[1] = 8'h20;
                line1_data[2] = 8'h20;
                line1_data[3] = 8'h20;
                line1_data[4] = 8'h20;  //
                line1_data[5] = 8'h20;  //
                line1_data[6] = 8'h58;  //X
                line1_data[7] = 8'h4f;  //O
                line1_data[8] = 8'h52;  //R
                line1_data[9] = 8'h20;  //
                line1_data[10] = 8'h20; //
                line1_data[11] = 8'h20; //
                line1_data[12] = 8'h20;
                line1_data[13] = 8'h20;
                line1_data[14] = 8'h20;
                line1_data[15] = 8'h20;
                // 47 41 4d 45 4f 56 45 52

                line2_data[0] = 8'h20;
                line2_data[1] = 8'h20;  //S
                line2_data[2] = 8'h20;  //C
                line2_data[3] = 8'h20;  //O
                line2_data[4] = 8'h20;  //R
                line2_data[5] = 8'h20;  //E
                line2_data[6] = 8'h20;  //:
                line2_data[7] = 8'h20;  //0
                line2_data[8] = 8'h20;  //0
                line2_data[9] = 8'h20;  //0
                line2_data[10] = 8'h20; //0
                line2_data[11] = 8'h20; //0
                line2_data[12] = 8'h20; //0
                line2_data[13] = 8'h20; //0
                line2_data[14] = 8'h20; //0
                line2_data[15] = 8'h20;
            end
            else if(Din == 4'b0010) begin
                line1_data[0] = 8'h20;
                line1_data[1] = 8'h20;
                line1_data[2] = 8'h20;
                line1_data[3] = 8'h20;
                line1_data[4] = 8'h20;  //
                line1_data[5] = 8'h20;  //
                line1_data[6] = 8'h4c;  //L
                line1_data[7] = 8'h45;  //E
                line1_data[8] = 8'h41;  //A
                line1_data[9] = 8'h20;  //
                line1_data[10] = 8'h20; //
                line1_data[11] = 8'h20; //
                line1_data[12] = 8'h20;
                line1_data[13] = 8'h20;
                line1_data[14] = 8'h20;
                line1_data[15] = 8'h20;
                // 47 41 4d 45 4f 56 45 52

                line2_data[0] = 8'h20;
                line2_data[1] = 8'h20;  //S
                line2_data[2] = 8'h20;  //C
                line2_data[3] = 8'h20;  //O
                line2_data[4] = 8'h20;  //R
                line2_data[5] = 8'h20;  //E
                line2_data[6] = 8'h20;  //:
                line2_data[7] = 8'h20;  //0
                line2_data[8] = 8'h20;  //0
                line2_data[9] = 8'h20;  //0
                line2_data[10] = 8'h20; //0
                line2_data[11] = 8'h20; //0
                line2_data[12] = 8'h20; //0
                line2_data[13] = 8'h20; //0
                line2_data[14] = 8'h20; //0
                line2_data[15] = 8'h20;
            end
            case(state)
                0: begin
                    lcd_en <= 1;
                    lcd_rs = 1'b0; lcd_rw = 1'b0;   lcd_data = 8'b00000001;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 1;
                        lcd_count = 0;
                    end
                end
                1: begin
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
                    lcd_rs = 1'b0;    lcd_rw = 1'b0;    lcd_data = 8'b00001100;
                    lcd_en <= 1;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 3;
                        lcd_count = 0;
                    end
                end
                3: begin
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 4;
                        lcd_count = 0;
                    end
                end
                4: begin
                    lcd_rs = 1'b0;    lcd_rw = 1'b0;    lcd_data = 8'b00111000;
                    lcd_en <= 1;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 5;
                        lcd_count = 0;
                    end
                end
                5: begin
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
                    lcd_rs <= 1'b0;    lcd_rw <= 1'b0;    lcd_data <= 8'b00000101;
                    lcd_en <= 1;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 7;
                        lcd_count = 0;
                    end
                end
                7: begin
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 8;
                        lcd_count = 0;
                    end
                end
                8: begin
                    lcd_rs <= 1'b0;    lcd_rw <= 1'b0;    lcd_data <= 8'b00000110;
                    lcd_en <= 1;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 9;
                        lcd_count = 0;
                    end
                end
                9: begin
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 10;
                        lcd_count = 0;
                    end
                end


                10: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 11;
                        lcd_count = 0;
                    end
                end
                11: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 12;
                        lcd_count = 0;
                    end
                end
                12: begin
                    // 문자 데이터 출력
                    lcd_data <= line1_data[pos]; // 캐릭터 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 13;
                        lcd_count = 0;
                    end
                end
                13: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        lcd_count = 0;
                        if(pos<15) begin
                            pos = pos + 1;
                            state <= 10;
                        end
                        else begin
                            pos = 0;
                            state <= 14;
                        end
                    end
                end
                14: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'b11000000 | pos);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 15;
                        lcd_count = 0;
                    end
                end
                15: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 16;
                        lcd_count = 0;
                    end
                end
                16: begin
                    // 문자 데이터 출력
                    lcd_data <= line2_data[pos]; // 캐릭터 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        state <= 17;
                        lcd_count = 0;
                    end
                end
                17: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    if(lcd_count<500) begin
                        lcd_count = lcd_count + 1;
                    end
                    else begin
                        if(pos<15) begin
                            pos = pos + 1;
                            state <= 14;
                        end
                        else begin
                            pos = 0;
                            state <= 10;
                        end
                        lcd_count = 0;
                    end
                end
            endcase
        end
    end
endmodule
