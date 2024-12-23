module lcd_custom_object_init(      //lcd에서 보여지는 캐릭터와 장애물을 설정하는 코드
    input clk,          // 시스템 클럭
    input rst,          // 리셋 신호
    output reg [7:0] lcd_data,  // LCD 데이터
    output reg lcd_rw,
    output reg lcd_rs,       // 레지스터 선택 (명령/데이터 선택)
    output reg lcd_en,        // Enable 신호
    output reg init_end
);

    // 상태 정의
    reg [3:0] state;
    reg [5:0] cnt = 0;
    // reg [7:0] data_num;
    reg [2:0] init_num;
    // 사용자 정의 문자 데이터 (5x8 도트, 예제 1개)
    reg [7:0] custom_char [7:0];
    initial begin
        custom_char[0] = 8'b00000011;
        custom_char[1] = 8'b00000011;
        custom_char[2] = 8'b00000011;
        custom_char[3] = 8'b00000011;
        custom_char[4] = 8'b00000011;
        custom_char[5] = 8'b00000011;
        custom_char[6] = 8'b00000011;
        custom_char[7] = 8'b00000011;
        // data_num = 8'b01000000;
        init_num = 0;
        init_end = 0;
        state = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            cnt <= 0;
            lcd_data <= 8'b00000000;
            lcd_rs <= 0;
            lcd_en <= 0;
            lcd_rw <= 0;
            init_end <= 0;
            // data_num <= 8'b01000000;
            init_num <= 0;
            custom_char[0] = 8'b00000011;
            custom_char[1] = 8'b00000011;
            custom_char[2] = 8'b00000011;
            custom_char[3] = 8'b00000011;
            custom_char[4] = 8'b00000011;
            custom_char[5] = 8'b00000011;
            custom_char[6] = 8'b00000011;
            custom_char[7] = 8'b00000011;
        end else begin
            case (state)
                0: begin
                    lcd_en <= 1;
                    lcd_rs = 1'b0; lcd_rw = 1'b0;   lcd_data = 8'b00000001;
                    state <= 1;
                end
                1: begin
                    lcd_en <= 0;
                    state <= 2;
                end
                2: begin
                    lcd_rs = 1'b0;    lcd_rw = 1'b0;    lcd_data = 8'b00001100;
                    lcd_en <= 1;
                    state <= 3;
                end
                3: begin
                    lcd_en <= 0;
                    state <= 4;
                end
                4: begin
                    lcd_rs = 1'b0;    lcd_rw = 1'b0;    lcd_data = 8'b00111000;
                    lcd_en <= 1;
                    state <= 5;
                end
                5: begin
                    lcd_en <= 0;
                    state <= 6;
                end
                6: begin
                    // CGRAM 주소 설정 (0x40부터 시작)
                    lcd_data <= (8'b01000000|(init_num<<3)); 
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1;
                    state <= 7;
                end
                7: begin
                    lcd_en <= 0; // Enable 비활성화
                    state <= 8;
                end
                8: begin
                    // 사용자 정의 문자 데이터 쓰기
                    lcd_data <= custom_char[cnt];
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1;                    
                    state <= 9;
                end
                9: begin
                    lcd_en <= 0; // Enable 비활성화     
                    if (cnt < 7) begin
                        cnt = cnt + 1;
                        state <= 8;
                    end else begin
                        if(init_num > 6) begin
                            state <= 10; // 완료
                        end
                        else begin
                            state <= 6;
                            init_num = init_num + 1;
                            cnt = 0;
                            if(init_num == 0)begin
                                custom_char[0] = 8'b00000011;
                                custom_char[1] = 8'b00000011;
                                custom_char[2] = 8'b00000011;
                                custom_char[3] = 8'b00000011;
                                custom_char[4] = 8'b00000011;
                                custom_char[5] = 8'b00000011;
                                custom_char[6] = 8'b00000011;
                                custom_char[7] = 8'b00000011;
                            end
                            else if(init_num == 1)begin
                                custom_char[0] = 8'b00001111;
                                custom_char[1] = 8'b00001111;
                                custom_char[2] = 8'b00001111;
                                custom_char[3] = 8'b00001111;
                                custom_char[4] = 8'b00001111;
                                custom_char[5] = 8'b00001111;
                                custom_char[6] = 8'b00001111;
                                custom_char[7] = 8'b00001111;
                            end
                            else if(init_num == 2)begin
                                custom_char[0] = 8'b00011111;
                                custom_char[1] = 8'b00011111;
                                custom_char[2] = 8'b00011111;
                                custom_char[3] = 8'b00011111;
                                custom_char[4] = 8'b00011111;
                                custom_char[5] = 8'b00011111;
                                custom_char[6] = 8'b00011111;
                                custom_char[7] = 8'b00011111;
                            end
                            else if(init_num == 3)begin
                                custom_char[0] = 8'b00011110;
                                custom_char[1] = 8'b00011110;
                                custom_char[2] = 8'b00011110;
                                custom_char[3] = 8'b00011110;
                                custom_char[4] = 8'b00011110;
                                custom_char[5] = 8'b00011110;
                                custom_char[6] = 8'b00011110;
                                custom_char[7] = 8'b00011110;
                            end
                            else if(init_num == 4)begin
                                custom_char[0] = 8'b00011000;
                                custom_char[1] = 8'b00011000;
                                custom_char[2] = 8'b00011000;
                                custom_char[3] = 8'b00011000;
                                custom_char[4] = 8'b00011000;
                                custom_char[5] = 8'b00011000;
                                custom_char[6] = 8'b00011000;
                                custom_char[7] = 8'b00011000;
                            end
                            else if(init_num == 5)begin
                                custom_char[0] = 8'b00000000;
                                custom_char[1] = 8'b00000000;
                                custom_char[2] = 8'b00000000;
                                custom_char[3] = 8'b00000000;
                                custom_char[4] = 8'b00000000;
                                custom_char[5] = 8'b00000000;
                                custom_char[6] = 8'b00000000;
                                custom_char[7] = 8'b00000000;
                            end
                            else if(init_num == 6)begin                //캐릭터 모양 설정
                                custom_char[0] = 8'b00000000;
                                custom_char[1] = 8'b00000010;
                                custom_char[2] = 8'b00000010;
                                custom_char[3] = 8'b00000011;
                                custom_char[4] = 8'b00001111;
                                custom_char[5] = 8'b00011110;
                                custom_char[6] = 8'b00001010;
                                custom_char[7] = 8'b00001010;
                            end
                        end
                    end
                end
                10: begin
                    // 대기 상태
                    lcd_en <= 0;
                    init_end <= 1;
                    init_num <= 0;
                    lcd_rs <= 0;
                end
            endcase
        end
    end
endmodule
