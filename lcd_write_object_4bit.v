module lcd_write_object(            //E 신호를 클럭에 한번만 수정이 가능하기에 클럭을 나눠서 따로 구현 해야한다. 으악
    input clk,                   // 클럭 입력
    input reset,                 // 리셋 입력
    input zero_top_one_bottom,      // 장애물 위아래 위치
    input [3:0] pos,             // 장애물 현재 위치 0xf ~ 0x0
    //input [7:0] data,            // 쓰고자 하는 문자 (ASCII 코드)
    output reg rs,               // 레지스터 선택 신호
    output reg rw,               // 읽기/쓰기 신호
    output reg e,                // Enable 신호
    output reg [3:0] lcd_data,    // D4-D7 데이터 핀
    output reg is_end
);

    reg [1:0] state = 0;         // 상태 변수
    reg [7:0] ddram_address;     // DDRAM 주소
    reg [3:0] data;
    reg [6:0] pos_now;
    reg clk_2div = 0;
    // reg clk_div_hz_one;
    // reg clk_div_hz_two;
    integer i;

    initial begin
        rs = 0;
        rw = 0;
        e = 0;
        lcd_data = 4'b0000;
        is_end = 0;
        // clk_div_hz_one = 0;
        // clk_div_hz_two = 0;


        pos_now = 7'h00;                //첫번째줄 장애물위치 = 0x00|pos  2번쨰줄 장애물위치 = 0x40|pos
        data = 4'h0;                   //장애물 object 번호 0x00 ~ 0x05
    end

    always @(posedge reset or posedge clk)
    begin
        if (reset)
        begin
            state <= 0;
            ddram_address <= 8'h80; // 기본 위치를 첫 번째 라인 시작 주소로 설정
            pos_now = 7'h00 | (4'b1111 ^ pos);
            clk_2div = 2'b00;
        end
        else if (!clk_2div)
        begin
        clk_2div = clk_2div + 1;	  
            case (state)
                0: begin
                    // DDRAM 주소 설정
                    rs <= 0;                   // 명령 모드
                    rw <= 0;                   // 쓰기 모드
                    e <= 0;
                    if(zero_top_one_bottom == 0)begin
                        pos_now = 7'h00 | (4'b1111 ^ pos);
                        ddram_address <= 8'h80 | pos_now;  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        pos_now = 7'h40 | (4'b1111 ^ pos);
                        ddram_address <= 8'h80 | pos_now;
                    end
                    lcd_data <= ddram_address[7:4]; // 상위 4비트 전송
                end
                1: begin
                    e <= 0;                      // Enable 신호 OFF
                    lcd_data <= ddram_address[3:0]; // 하위 4비트 전송
                end
                2: begin
                    e <= 0;
                    // 데이터 전송
                    rs <= 1;                    // 데이터 모드
                    lcd_data <= 4'b0000;
                end
                3: begin
                    e <= 0;
                    lcd_data <= data[3:0];      // 하위 4비트 전송 
                end
            endcase

        end
        else begin
            clk_2div = 0;

            case (state)
                0: begin
                    // DDRAM 주소 설정
                    rs <= 0;                   // 명령 모드
                    rw <= 0;                   // 쓰기 모드
                    e <= 0;
                    if(zero_top_one_bottom == 0)begin
                        pos_now = 7'h00 | (4'b1111 ^ pos);
                        ddram_address <= 8'h80 | pos_now;  // 첫 라인 시작 주소와 입력 위치를 OR 연산
                    end
                    else begin
                        pos_now = 7'h40 | (4'b1111 ^ pos);
                        ddram_address <= 8'h80 | pos_now;
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
                    lcd_data <= data[3:0];      // 하위 4비트 전송 
                    data = data + 1;
                    if(data>5) begin
                        data = 4'h00;
                        is_end <= 1;
                    end
                    e <= 1;
                    state <= 0;                // 상태 초기화
                end
            endcase

        end
    end
endmodule
