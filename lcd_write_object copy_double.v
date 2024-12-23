module lcd_write_object (
    input clk,           // 시스템 클럭
    input rst,           // 리셋 신호
    input zero_top_one_bottom,      // 장애물 위아래 위치
    input next,
    input [3:0] pos,             // 장애물 현재 위치 0xf ~ 0x0
    output reg [7:0] lcd_data, // LCD 데이터 버스
    output reg lcd_rs,        // 레지스터 선택 (명령/데이터 선택)
    output reg lcd_rw,               // 읽기/쓰기 신호
    output reg lcd_en         // Enable 신호
);

    // 상태 정의
    reg [3:0] state;
    reg [5:0] cnt;

    // 출력할 문자 코드 (CGRAM에 저장된 문자 코드)
    reg [7:0] display_data [15:0]; // 16개의 문자 (1행)
    reg [6:0] pos_now;
    reg [7:0] data_one;
    reg [7:0] data_two;

    integer i;
    initial begin
        state <= 0;
        cnt <= 0;
        lcd_data <= 8'b0;
        lcd_rs <= 0;
        lcd_rw <= 0;
        lcd_en <= 0;
        data_one <= 3;
        data_two <= 0;
        pos_now <= 0;
        // 1행에 사용자 정의 문자 0~3번을 출력
        // display_data[0] = 8'h00; // 사용자 정의 문자 0
        // display_data[1] = 8'h01; // 사용자 정의 문자 1
        // display_data[2] = 8'h02; // 사용자 정의 문자 2
        // display_data[3] = 8'h03; // 사용자 정의 문자 3
        // // 나머지는 빈 문자
        // for (i = 4; i < 16; i = i + 1)
        //     display_data[i] = 8'h20; // 공백 (ASCII ' ')
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            cnt <= 0;
            lcd_data <= 8'b0;
            lcd_rs <= 0;
            lcd_rw <= 0;
            lcd_en <= 0;
            data_one <= 3;
            data_two <= 0;
            pos_now <= 0;
        end else begin
            case (state)
                0: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    if(zero_top_one_bottom == 0)begin
                        pos_now = (7'h00 | (4'b1111 ^ pos));
                        lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        pos_now = (7'h40 | (4'b1111 ^ pos));
                        lcd_data <= (8'h80 | pos_now);
                    end
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 1;
                end
                1: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 2;
                end
                2: begin
                    // 문자 데이터 출력
                    lcd_data <= data_one; // 현재 출력할 데이터
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 3;
                end
                3: begin
                    // Enable 비활성화 (데이터 전송 완료)
                    lcd_en <= 0;
                    // cnt <= cnt + 1;
                    if(data_one>=5) begin
                        data_one = 8'h03;
                        state <= 4;
                    end
                    else begin
                        data_one = data_one + 1;
                        state <= 4;
                    end
                    // if (cnt == 15) state <= 4; // 모든 문자 출력 완료
                    // else state <= 2;          // 다음 문자 출력
                end
                4: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    if(zero_top_one_bottom == 0)begin
                        pos_now = (7'h00 | (4'b1111 ^ (pos+1)));
                        lcd_data <= 8'h80 | pos_now;  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        pos_now = 7'h40 | (4'b1111 ^ (pos+1));
                        lcd_data <= 8'h80 | pos_now;
                    end
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 5;
                end
                5: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 6;
                end
                6: begin
                    // 문자 데이터 출력
                    lcd_data <= data_two; // 현재 출력할 데이터
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 7;
                end
                7: begin
                    // Enable 비활성화 (데이터 전송 완료)
                    lcd_en <= 0;
                    // cnt <= cnt + 1;
                    if(data>=2) begin
                        data = 8'h00;
                        state <= 8;
                    end
                    else begin
                        data_two = data_two + 1;
                        state <= 0;
                    end
                    // if (cnt == 15) state <= 4; // 모든 문자 출력 완료
                    // else state <= 2;          // 다음 문자 출력
                end
                8: begin
                    // 대기 상태 (추가 작업 가능)
                    lcd_en <= 0;
                    lcd_data <= 0;
                    lcd_rs <= 0;
                    if(next) begin
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule
