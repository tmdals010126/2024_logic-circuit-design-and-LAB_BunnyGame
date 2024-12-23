module lcd_write_charactor(         //lcd에 캐릭터를 출력해주는 코드
    input clk,                   // 클럭 입력
    input reset,                 // 리셋 입력
    input char_zero_bottom_one_top,      // 캐릭터 위치 변경
    // input [6:0] pos,             // 쓰기 시작 위치
    // input [7:0] data,            // 쓰고자 하는 문자 (ASCII 코드)
    output reg lcd_rs,               // 레지스터 선택 신호
    output reg lcd_rw,               // 읽기/쓰기 신호
    output reg lcd_en,                // Enable 신호
    output reg [7:0] lcd_data    // D4-D7 데이터 핀
);

    reg [7:0] state = 0;         // 상태 변수
    reg [6:0] pos_top;
    reg [6:0] pos_bottom;
    reg position;

    initial begin
        lcd_rs = 0;
        lcd_rw = 0;
        lcd_en = 0;
        lcd_data = 4'b0000;
        position = 0;
        pos_top = 7'h00;                //첫번째줄 1번칸
        pos_bottom = 7'h40;             //두번째줄 1번칸
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 210;
            position <= 0;
        end else begin
            case (state)
                200: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_bottom);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 201;
                end
                201: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 202;
                end
                202: begin
                    // 문자 데이터 출력
                    lcd_data <= 8'h20; // 캐릭터 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 203;
                end
                203: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 204;
                end
                204: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_top);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 205;
                end
                205: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 206;
                end
                206: begin
                    // 문자 데이터 출력
                    lcd_data <= 8'h06; // 캐릭터 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 207;
                end
                207: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 255;
                end

                210: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_top);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 211;
                end
                211: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 212;
                end
                212: begin
                    // 문자 데이터 출력
                    lcd_data <= 8'h20; // 빈칸 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 213;
                end
                213: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 214;
                end
                214: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_bottom);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 215;
                end
                215: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 216;
                end
                216: begin
                    // 문자 데이터 출력
                    lcd_data <= 8'h06; // 캐릭터 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 217;
                end
                217: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 255;
                end

                255: begin
                    // 대기 상태 (추가 작업 가능)
                    lcd_en <= 0;
                    lcd_data <= 0;
                    lcd_rs <= 0;
                    if(char_zero_bottom_one_top != position) begin
                        position <= char_zero_bottom_one_top;
                        if(char_zero_bottom_one_top)begin
                            state <= 200;
                        end
                        else begin
                            state <= 210;
                        end
                    end
                end
            endcase
        end
    end
endmodule
