module lcd_write_object_full (
    input clk,           // 시스템 클럭
    input rst,           // 리셋 신호
    input zero_top_one_bottom,      // 장애물 위아래 위치
    input next,
    // input [3:0] pos,             // 장애물 현재 위치 0xf ~ 0x0
    output reg [7:0] lcd_data, // LCD 데이터 버스
    output reg lcd_rs,        // 레지스터 선택 (명령/데이터 선택)
    output reg lcd_rw,               // 읽기/쓰기 신호
    output reg lcd_en,         // Enable 신호
    output reg next_output
);

    // 상태 정의
    reg [7:0] state;
    reg [5:0] cnt;

    reg [3:0] pos;
    // 출력할 문자 코드 (CGRAM에 저장된 문자 코드)
    // reg [7:0] display_data [15:0]; // 16개의 문자 (1행)
    reg [6:0] pos_now;
    // reg [7:0] data;
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
        // data <= 0;
        pos_now <= 0;
        data_one <= 0;
        data_two <= 3;
        next_output <= 0;
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
            // data <= 0;
            data_one <= 0;
            data_two <= 3;
            pos_now <= 0;
            next_output <= 0;
        end else begin
            case (state)
                0: begin
                    lcd_en <= 1;
                    lcd_rs <= 1'b0; lcd_rw <= 1'b0;   lcd_data <= 8'b00000001;
                    state <= 1;
                end
                1: begin
                    lcd_en <= 0;
                    state <= 2;
                end
                2: begin
                    lcd_rs <= 1'b0;    lcd_rw <= 1'b0;    lcd_data <= 8'b00000101;
                    lcd_en <= 1;
                    state <= 3;
                end
                3: begin
                    lcd_en <= 0;
                    state <= 4;
                end
                4: begin
                    lcd_rs <= 1'b0;    lcd_rw <= 1'b0;    lcd_data <= 8'b00010000;
                    lcd_en <= 1;
                    state <= 5;
                    if(zero_top_one_bottom)begin
                        pos_now = (7'h00 | pos);
                        // lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        // pos_now = (7'h40 | (4'b1111 ^ pos));
                        pos_now = (7'h40 | pos);
                        // lcd_data <= (8'h80 | pos_now);
                    end
                end
                5: begin
                    lcd_en <= 0;
                    state <= 50;
                end
                40: begin
                    lcd_en <= 1;
                    lcd_rs <= 1'b0; lcd_rw <= 1'b0;   lcd_data <= 8'b00000001;
                    state <= 41;
                    if(zero_top_one_bottom)begin
                        pos_now = (7'h00 | pos);
                        // lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        // pos_now = (7'h40 | (4'b1111 ^ pos));
                        pos_now = (7'h40 | pos);
                        // lcd_data <= (8'h80 | pos_now);
                    end
                end
                41: begin
                    lcd_en <= 0;
                    state <= 50;
                end

                50: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    if(zero_top_one_bottom)begin
                        // pos_now = (7'h00 | (4'b1111 ^ pos));
                        lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        // pos_now = (7'h40 | (4'b1111 ^ pos));
                        lcd_data <= (8'h80 | pos_now);
                    end
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 51;
                end
                51: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 52;
                end
                52: begin
                    // 문자 데이터 출력
                    lcd_data <= data_one; // 현재 출력할 데이터
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 53;
                end
                53: begin
                    // Enable 비활성화 (데이터 전송 완료)
                    lcd_en <= 0;
                    // cnt <= cnt + 1;
                    if(data_one>=2) begin
                        data_one = 8'h00;
                        state <= 255;
                    end
                    else begin
                        data_one = (data_one + 1);
                        state <= 50;
                    end
                    // if (cnt == 15) state <= 4; // 모든 문자 출력 완료
                    // else state <= 2;          // 다음 문자 출력
                end

                90: begin
                    lcd_en <= 1;
                    lcd_rs <= 1'b0; lcd_rw <= 1'b0;   lcd_data <= 8'b00000001;
                    state <= 91;
                    if(zero_top_one_bottom)begin
                        pos_now = (7'h00 | pos);
                        // lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        // pos_now = (7'h40 | (4'b1111 ^ pos));
                        pos_now = (7'h40 | pos);
                        // lcd_data <= (8'h80 | pos_now);
                    end
                end
                91: begin
                    lcd_en <= 0;
                    state <= 100;
                end

                100: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    if(zero_top_one_bottom)begin
                        // pos_now = (7'h00 | (4'b1111 ^ pos));
                        lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        // pos_now = (7'h40 | (4'b1111 ^ pos));
                        lcd_data <= (8'h80 | pos_now);
                    end
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 101;
                end
                101: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 102;
                end
                102: begin
                    // 문자 데이터 출력
                    lcd_data <= data_one; // 현재 출력할 데이터
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 103;
                end
                103: begin
                    // Enable 비활성화 (데이터 전송 완료)
                    lcd_en <= 0;
                    // cnt <= cnt + 1;
                    if(data_one>=2) begin
                        data_one = 8'h00;
                        state <= 150;
                    end
                    else begin
                        data_one = (data_one + 1);
                        state <= 150;
                    end
                    // if (cnt == 15) state <= 4; // 모든 문자 출력 완료
                    // else state <= 2;          // 다음 문자 출력
                end
                150: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    if(zero_top_one_bottom)begin
                        // pos_now = (7'h00 | (4'b1111 ^ pos));
                        lcd_data <= (8'h80 | (pos_now-1));  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        // pos_now = (7'h40 | (4'b1111 ^ pos));
                        lcd_data <= (8'h80 | (pos_now-1));
                    end
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 151;
                end
                151: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 152;
                end
                152: begin
                    // 문자 데이터 출력
                    lcd_data <= data_two; // 현재 출력할 데이터
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 153;
                end
                153: begin
                    // Enable 비활성화 (데이터 전송 완료)
                    lcd_en <= 0;
                    // cnt <= cnt + 1;
                    if(data_two>=5) begin
                        data_two = 8'h03;
                        state <= 255;
                    end
                    else begin
                        data_two = (data_two + 1);
                        state <= 100;
                    end
                    // if (cnt == 15) state <= 4; // 모든 문자 출력 완료
                    // else state <= 2;          // 다음 문자 출력
                end

                190: begin
                    lcd_en <= 1;
                    lcd_rs <= 1'b0; lcd_rw <= 1'b0;   lcd_data <= 8'b00000001;
                    state <= 191;
                    if(zero_top_one_bottom)begin
                        pos_now = (7'h00 | pos);
                        // lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        // pos_now = (7'h40 | (4'b1111 ^ pos));
                        pos_now = (7'h40 | pos);
                        // lcd_data <= (8'h80 | pos_now);
                    end
                end
                191: begin
                    lcd_en <= 0;
                    state <= 200;
                end

                200: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    if(zero_top_one_bottom)begin
                        // pos_now = (7'h00 | (4'b1111 ^ pos));
                        lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        // pos_now = (7'h40 | (4'b1111 ^ pos));
                        lcd_data <= (8'h80 | pos_now);
                    end
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
                    lcd_data <= data_two; // 현재 출력할 데이터
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 203;
                end
                203: begin
                    // Enable 비활성화 (데이터 전송 완료)
                    lcd_en <= 0;
                    // cnt <= cnt + 1;
                    if(data_two>=5) begin
                        data_two = 8'h03;
                        state <= 255;
                    end
                    else begin
                        data_two = (data_two + 1);
                        state <= 200;
                    end
                    // if (cnt == 15) state <= 4; // 모든 문자 출력 완료
                    // else state <= 2;          // 다음 문자 출력
                end

                255: begin
                    // 대기 상태 (추가 작업 가능)
                    lcd_en <= 0;
                    lcd_data <= 0;
                    lcd_rs <= 0;
                    next_output <= 1;
                    if(next) begin
                        data_one <= 0;
                        data_two <= 3;
                        next_output <= 0;
                        pos = pos + 1;
                        if(zero_top_one_bottom)begin
                            pos_now = (7'h00 | pos);
                            // lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                        end
                        else begin
                            // pos_now = (7'h40 | (4'b1111 ^ pos));
                            pos_now = (7'h40 | pos);
                            // lcd_data <= (8'h80 | pos_now);
                        end
                        if(pos == 4'b0000) begin
                            state <= 40;
                        end
                        else if(pos == 4'b1111) begin
                            state <= 190;
                        end
                        else begin
                            state <= 90;
                        end
                    end
                end



            endcase
        end
    end
endmodule
