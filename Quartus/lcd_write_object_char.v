module lcd_write_object_char (
    input clk,           // 시스템 클럭
    input rst,           // 리셋 신호
    input obj_zero_bottom_one_top,      // 장애물 위아래 위치
    input char_zero_bottom_one_top,
    input next,
    // input [3:0] pos,             // 장애물 현재 위치 0xf ~ 0x0
    output reg [7:0] lcd_data, // LCD 데이터 버스
    output reg lcd_rs,        // 레지스터 선택 (명령/데이터 선택)
    output reg lcd_rw,               // 읽기/쓰기 신호
    output reg lcd_en,         // Enable 신호
    output reg next_output,
    output reg hit
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
    
    reg [6:0] pos_top;
    reg [6:0] pos_bottom;
    reg position;
    reg obj_position;
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
        hit <= 0;

        pos_top = 7'h00;                //첫번째줄 1번칸
        pos_bottom = 7'h40;             //두번째줄 1번칸
        position = 0;
        obj_position = 0;
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
            hit <= 0;
            position <= 0;
            obj_position <= 0;

        end else begin
            case (state)
                0: begin
                    lcd_en <= 1;
                    lcd_rs <= 1'b0; lcd_rw <= 1'b0;   lcd_data <= 8'b00000001; // 화면초기화
                    state <= 1;
                end
                1: begin
                    lcd_en <= 0;
                    state <= 2;
                end
                2: begin
                    lcd_rs <= 1'b0;    lcd_rw <= 1'b0;    lcd_data <= 8'b00001100; // 디스플레이 on
                    lcd_en <= 1;
                    state <= 3;
                end
                3: begin
                    lcd_en <= 0;
                    state <= 4;
                end
                4: begin
                    // lcd_rs <= 1'b0;    lcd_rw <= 1'b0;    lcd_data <= 8'b00010000; //lcd 전체 화면이 이동하는것을 방지
                    lcd_rs <= 1'b0;    lcd_rw <= 1'b0;    lcd_data <= 8'b00000110; //lcd 전체 화면이 이동하는것을 방지
                    // displaymode = 0x2|0x00
                    // 0x04  | (displaymode & (~0x01))
                    lcd_en <= 1;
                    state <= 5;
                    if(obj_position)begin
                        pos = 4'b0000;
                        pos_now = (7'h00 | 4'b1111);
                        // lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        // pos_now = (7'h40 | (4'b1111 ^ pos));
                        pos = 4'b0000;                        
                        pos_now = (7'h40 | 4'b1111);
                        // lcd_data <= (8'h80 | pos_now);
                    end
                end
                5: begin
                    lcd_en <= 0;
                    state <= 130; // 캐릭터 출력부로 이동
                end
                40: begin
                    lcd_en <= 1;
                    lcd_rs <= 1'b0; lcd_rw <= 1'b0;   lcd_data <= 8'b00000001;
                    state <= 41;
                end
                41: begin
                    lcd_en <= 0;
                    state <= 50;
                end

                50: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                        // pos_now = (7'h40 | (4'b1111 ^ pos));
                    lcd_data <= (8'h80 | pos_now);
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
                end
                91: begin
                    lcd_en <= 0;
                    state <= 100;
                end

                100: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_now);
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
                    lcd_data <= (8'h80 | (pos_now + 1));
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
                    if(data_two == 8'h5) begin
                        lcd_data <= 8'h20;
                    end
                    else begin
                        lcd_data <= data_two; // 현재 출력할 데이터
                    end
                    // lcd_data <= data_two; // 현재 출력할 데이터
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
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_now);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 191;
                end
                191: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 192;
                end
                192: begin
                    // 문자 데이터 출력
                    lcd_data <= data_one; // 현재 출력할 데이터
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 193;
                end
                193: begin
                    // Enable 비활성화 (데이터 전송 완료)
                    lcd_en <= 0;
                    // cnt <= cnt + 1;
                    if(data_one>=2) begin
                        data_one = 8'h00;
                        state <= 194;
                    end
                    else begin
                        data_one = (data_one + 1);
                        state <= 194;
                    end
                    // if (cnt == 15) state <= 4; // 모든 문자 출력 완료
                    // else state <= 2;          // 다음 문자 출력
                end
                194: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | (pos_now + 1));
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 195;
                end
                195: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 196;
                end
                196: begin
                    // 문자 데이터 출력
                    if(data_two == 8'h5) begin
                        lcd_data <= 8'h20;
                    end
                    else begin
                        lcd_data <= data_two; // 현재 출력할 데이터
                    end
                    // lcd_data <= data_two; // 현재 출력할 데이터
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 197;
                end
                197: begin
                    // Enable 비활성화 (데이터 전송 완료)
                    lcd_en <= 0;
                    // cnt <= cnt + 1;
                    if(data_two>=5) begin
                        data_two = 8'h03;
                        state <= 200;
                    end
                    else begin
                        data_two = (data_two + 1);
                        state <= 190;
                    end
                    // if (cnt == 15) state <= 4; // 모든 문자 출력 완료
                    // else state <= 2;          // 다음 문자 출력
                end

                200: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_now);
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
                    if(data_two == 8'h5) begin
                        lcd_data <= 8'h20;
                    end
                    else begin
                        lcd_data <= data_two; // 현재 출력할 데이터
                    end
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
                        if(hit == 1) begin
                            if(position)begin
                                state <= 120;
                            end
                            else begin
                                state <= 130;
                            end                            
                        end
                        else begin
                            state <= 255;
                        end
                    end
                    else begin
                        data_two = (data_two + 1);
                        state <= 200;
                    end
                    // if (cnt == 15) state <= 4; // 모든 문자 출력 완료
                    // else state <= 2;          // 다음 문자 출력
                end


/////////////////////////////////////// 캐릭터 출력부분 시작
                120: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_bottom);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 121;
                end
                121: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 122;
                end
                122: begin
                    // 문자 데이터 출력
                    lcd_data <= 8'h20; // 캐릭터 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 123;
                end
                123: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 124;
                end
                124: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_top);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 125;
                end
                125: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 126;
                end
                126: begin
                    // 문자 데이터 출력
                    lcd_data <= 8'h06; // 캐릭터 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 127;
                end
                127: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 255;
                end
///////////////////////////////////////// 캐릭터 상단 출력

///////////////////////////////////////// 캐릭터 하단 출력
                130: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_top);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 131;
                end
                131: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 132;
                end
                132: begin
                    // 문자 데이터 출력
                    lcd_data <= 8'h20; // 빈칸 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 133;
                end
                133: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 134;
                end
                134: begin
                    // LCD 초기화: 명령으로 첫 번째 행 시작 주소 설정 (0x80)
                    lcd_data <= (8'h80 | pos_bottom);
                    // lcd_data <= 8'b10000000; // DDRAM 0x00 (첫 번째 행 시작 주소)
                    lcd_rs <= 0; // 명령 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 135;
                end
                135: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 136;
                end
                136: begin
                    // 문자 데이터 출력
                    lcd_data <= 8'h06; // 캐릭터 출력
                    lcd_rs <= 1; // 데이터 모드
                    lcd_en <= 1; // Enable 활성화
                    state <= 137;
                end
                137: begin
                    // Enable 비활성화 (명령 전송 완료)
                    lcd_en <= 0;
                    state <= 255;
                end
////////////////////////////////////////// 캐릭터 처리부분 종료

                255: begin
                    // 대기 상태 (추가 작업 가능)
                    lcd_en <= 0;
                    lcd_data <= 0;
                    lcd_rs <= 0;
                    next_output <= 1;
                    hit <= 0;
                    if(char_zero_bottom_one_top != position) begin
                        position <= char_zero_bottom_one_top;
                        if(char_zero_bottom_one_top)begin
                            state <= 120;
                        end
                        else begin
                            state <= 130;
                        end
                    end
                    else if(next) begin
                        data_one <= 0;
                        data_two <= 3;
                        next_output <= 0;
                        pos = pos + 1;
                        pos_now = pos_now - 1;
                        if(pos == 4'b0000) begin
                            state <= 50;
                            obj_position = obj_zero_bottom_one_top;
                            if(obj_position)begin
                                pos_now = (7'h00 | 4'b1111);
                                // lcd_data <= (8'h80 | pos_now);  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                            end
                            else begin
                                // pos_now = (7'h40 | (4'b1111 ^ pos));
                                pos_now = (7'h40 | 4'b1111);
                                // lcd_data <= (8'h80 | pos_now);
                            end
                        end
                        else if(pos == 4'b1111) begin
                            state <= 190;
                            if(obj_position == position) begin
                                hit <= 1;
                            end
                        end
                        else begin
                            state <= 100;
                        end
                    end
                end



            endcase
        end
    end
endmodule
