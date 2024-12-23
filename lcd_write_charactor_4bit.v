module lcd_write_charactor(         //lcd에 캐릭터를 출력해주는 코드
    input clk,                   // 클럭 입력
    input reset,                 // 리셋 입력
    input zero_top_one_bottom,      // 캐릭터 위치 변경
    // input [6:0] pos,             // 쓰기 시작 위치
    // input [7:0] data,            // 쓰고자 하는 문자 (ASCII 코드)
    output reg rs,               // 레지스터 선택 신호
    output reg rw,               // 읽기/쓰기 신호
    output reg e,                // Enable 신호
    output reg [3:0] lcd_data    // D4-D7 데이터 핀
);

    reg [2:0] state = 0;         // 상태 변수
    reg [7:0] ddram_address;     // DDRAM 주소
    reg [7:0] data;
    reg [6:0] pos_top;
    reg [6:0] pos_bottom;

    initial begin
        rs = 0;
        rw = 0;
        e = 0;
        lcd_data = 4'b0000;

        pos_top = 7'h00;                //첫번째줄 1번칸
        pos_bottom = 7'h40;             //두번째줄 1번칸
        data = 8'h06;                   //캐릭터 오브젝트 번호 0x06
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            ddram_address <= 8'h80; // 기본 위치를 첫 번째 라인 시작 주소로 설정
        end else begin
            case (state)
                0: begin
                    // DDRAM 주소 설정
                    rs <= 0;                   // 명령 모드
                    rw <= 0;                   // 쓰기 모드
                    if(zero_top_one_bottom == 0)begin
                        ddram_address <= 8'h80 | pos_bottom;  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        ddram_address <= 8'h80 | pos_top;
                    end
                    lcd_data <= ddram_address[7:4]; // 상위 4비트 전송
                    e <= 1;
                    state <= 1;
                end
                1: begin
                    e <= 0;                      // Enable 신호 OFF
                    lcd_data <= ddram_address[3:0]; // 하위 4비트 전송
                    e <= 1;
                    state <= 2;
                end
                2: begin
                    e <= 0;
                    // 데이터 전송
                    rs <= 1;                    // 데이터 모드
                    lcd_data <= 4'b0000;
                    e <= 1;
                    state <= 3;
                end
                3: begin
                    e <= 0;
                    lcd_data <= 4'b0101;      // 하위 4비트 전송 빈칸 데이터는 0x5
                    e <= 1;
                    state <= 4;                // 상태 초기화
                end
                4: begin
                    // DDRAM 주소 설정
                    rs <= 0;                   // 명령 모드
                    rw <= 0;                   // 쓰기 모드
                    if(zero_top_one_bottom == 0)begin
                        ddram_address <= 8'h80 | pos_top;  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        ddram_address <= 8'h80 | pos_bottom;
                    end
                    lcd_data <= ddram_address[7:4]; // 상위 4비트 전송
                    e <= 1;
                    state <= 5;
                end
                5: begin
                    e <= 0;                      // Enable 신호 OFF
                    lcd_data <= ddram_address[3:0]; // 하위 4비트 전송
                    e <= 1;
                    state <= 6;
                end
                6: begin
                    e <= 0;
                    // 데이터 전송
                    rs <= 1;                    // 데이터 모드
                    lcd_data <= data[7:4];      // 상위 4비트 전송
                    e <= 1;
                    state <= 7;
                end
                7: begin
                    e <= 0;
                    lcd_data <= data[3:0];      // 하위 4비트 전송
                    e <= 1;
                    state <= 0;                // 상태 초기화
                end
            endcase
        end
    end
endmodule
