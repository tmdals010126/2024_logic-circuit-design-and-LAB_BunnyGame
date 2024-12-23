module lcd_custom_object_init(      //lcd에서 보여지는 캐릭터와 장애물을 설정하는 코드
    input clk,                      //
    output reg rs,
    output reg rw,
    output reg e,
    output reg [3:0] data,
    output reg init_end
);

    reg [4:0] heart_pattern[7:0]; // 패턴 저장
    reg [3:0] index = 0;
    reg [1:0] state = 0;
    reg [2:0] init_num = 0;
    reg [3:0] data_num;
    reg [1:0] clk_div = 0;
    reg clk_div_hz_one;
    reg clk_div_hz_two;

    initial begin
        heart_pattern[0] = 5'b00011;
        heart_pattern[1] = 5'b00011;
        heart_pattern[2] = 5'b00011;
        heart_pattern[3] = 5'b00011;
        heart_pattern[4] = 5'b00011;
        heart_pattern[5] = 5'b00011;
        heart_pattern[6] = 5'b00011;
        heart_pattern[7] = 5'b00011;
        data_num = 4'b0000;
        init_end <= 0;
        clk_div_hz_one = 0;
        clk_div_hz_two = 0;
    end


    always @(posedge clk)
    begin
        if (clk_div[1])
        begin
        clk_div = 0;	  
        clk_div_hz_one = ~ clk_div_hz_one;
        clk_div_hz_two = ~ clk_div_hz_one;
        end
        else 
        clk_div = clk_div + 1;
    end


    always @(posedge clk_div_hz_one) begin
        case (state)
            0: begin
                rs <= 0;          // 명령어 모드
                data <= 4'b0100;  // CGRAM 주소 지정 명령 상위 비트 (0x40 ~ 0x46) 사용할땐 0x0 ~ 0x6
            end
            1: begin
                e <= 0;           // 명령어 전송 완료
                data <= data_num;  // CGRAM 주소 하위 비트
            end
            2: begin
                e <= 0;
                rs <= 1;          // 데이터 모드로 변경
                data <= {3'b000,heart_pattern[index][4]}; // 상위 4비트 전송
            end
            3: begin
                e <= 0;
                data <= heart_pattern[index][3:0]; // 하위 4비트 전송
            end
        endcase
    end


    always @(posedge clk_div_hz_two) begin
        case (state)
            0: begin
                rs <= 0;          // 명령어 모드
                data <= 4'b0100;  // CGRAM 주소 지정 명령 상위 비트 (0x40 ~ 0x46) 사용할땐 0x0 ~ 0x6
                e <= 1;
                state <= 1;
            end
            1: begin
                e <= 0;           // 명령어 전송 완료
                data <= data_num;  // CGRAM 주소 하위 비트
                e <= 1;
                state <= 2;
            end
            2: begin
                e <= 0;
                rs <= 1;          // 데이터 모드로 변경
                data <= {3'b000,heart_pattern[index][4]}; // 상위 4비트 전송
                e <= 1;
                state <= 3;
            end
            3: begin
                e <= 0;
                data <= heart_pattern[index][3:0]; // 하위 4비트 전송
                e <= 1;
                index <= index + 1;
                if (index > 3'b111)begin
                    state <= 0; // 모든 패턴 전송 후 초기화
                    init_num = init_num + 1;
                    if(init_num == 0)begin
                        heart_pattern[0] = 5'b00011;
                        heart_pattern[1] = 5'b00011;
                        heart_pattern[2] = 5'b00011;
                        heart_pattern[3] = 5'b00011;
                        heart_pattern[4] = 5'b00011;
                        heart_pattern[5] = 5'b00011;
                        heart_pattern[6] = 5'b00011;
                        heart_pattern[7] = 5'b00011;
                        data_num = 4'b0000;
                    end
                    else if(init_num == 1)begin
                        heart_pattern[0] = 5'b01111;
                        heart_pattern[1] = 5'b01111;
                        heart_pattern[2] = 5'b01111;
                        heart_pattern[3] = 5'b01111;
                        heart_pattern[4] = 5'b01111;
                        heart_pattern[5] = 5'b01111;
                        heart_pattern[6] = 5'b01111;
                        heart_pattern[7] = 5'b01111;
                        data_num = 4'b0001;
                    end
                    else if(init_num == 2)begin
                        heart_pattern[0] = 5'b11111;
                        heart_pattern[1] = 5'b11111;
                        heart_pattern[2] = 5'b11111;
                        heart_pattern[3] = 5'b11111;
                        heart_pattern[4] = 5'b11111;
                        heart_pattern[5] = 5'b11111;
                        heart_pattern[6] = 5'b11111;
                        heart_pattern[7] = 5'b11111;
                        data_num = 4'b0010;
                    end
                    else if(init_num == 3)begin
                        heart_pattern[0] = 5'b11110;
                        heart_pattern[1] = 5'b11110;
                        heart_pattern[2] = 5'b11110;
                        heart_pattern[3] = 5'b11110;
                        heart_pattern[4] = 5'b11110;
                        heart_pattern[5] = 5'b11110;
                        heart_pattern[6] = 5'b11110;
                        heart_pattern[7] = 5'b11110;
                        data_num = 4'b0011;
                    end
                    else if(init_num == 4)begin
                        heart_pattern[0] = 5'b11000;
                        heart_pattern[1] = 5'b11000;
                        heart_pattern[2] = 5'b11000;
                        heart_pattern[3] = 5'b11000;
                        heart_pattern[4] = 5'b11000;
                        heart_pattern[5] = 5'b11000;
                        heart_pattern[6] = 5'b11000;
                        heart_pattern[7] = 5'b11000;
                        data_num = 4'b0100;
                    end
                    else if(init_num == 5)begin
                        heart_pattern[0] = 5'b00000;
                        heart_pattern[1] = 5'b00000;
                        heart_pattern[2] = 5'b00000;
                        heart_pattern[3] = 5'b00000;
                        heart_pattern[4] = 5'b00000;
                        heart_pattern[5] = 5'b00000;
                        heart_pattern[6] = 5'b00000;
                        heart_pattern[7] = 5'b00000;
                        data_num = 4'b0101;
                    end
                    else if(init_num == 6)begin                //캐릭터 모양 설정
                        heart_pattern[0] = 5'b00000;
                        heart_pattern[1] = 5'b01110;
                        heart_pattern[2] = 5'b01110;
                        heart_pattern[3] = 5'b01110;
                        heart_pattern[4] = 5'b01110;
                        heart_pattern[5] = 5'b01110;
                        heart_pattern[6] = 5'b01110;
                        heart_pattern[7] = 5'b00000;
                        data_num = 4'b0110;
                    end
                    else if(init_num == 7)begin
                        init_end <= 1; // 모든 패턴 추가 완료 init_end를 이용해 mux 활성화
                        init_num = 0;
                    end
                end
                else state <= 2;
            end
        endcase
    end
endmodule
