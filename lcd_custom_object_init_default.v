module lcd_custom_object_1_init(
    input clk,
    output reg rs,
    output reg rw,
    output reg e,
    output reg [3:0] data
);

    reg [7:0] heart_pattern[7:0]; // 하트 모양 패턴 저장
    reg [2:0] index = 0;
    reg [1:0] state = 0;

    initial begin
        heart_pattern[0] = 5'b11111;
        heart_pattern[1] = 5'b11111;
        heart_pattern[2] = 5'b11111;
        heart_pattern[3] = 5'b11111;
        heart_pattern[4] = 5'b11111;
        heart_pattern[5] = 5'b11111;
        heart_pattern[6] = 5'b11111;
        heart_pattern[7] = 5'b11111;
    end

    always @(posedge clk) begin
        case (state)
            0: begin
                rs <= 0;          // 명령어 모드
                data <= 4'b0100;  // CGRAM 주소 지정 명령 상위 비트 (0x40)
                e <= 1;
                state <= 1;
            end
            1: begin
                e <= 0;           // 명령어 전송 완료
                data <= 4'b0000;  // CGRAM 주소 하위 비트
                e <= 1;
                state <= 2;
            end
            2: begin
                e <= 0;
                rs <= 1;          // 데이터 모드로 변경
                data <= heart_pattern[index][7:4]; // 상위 4비트 전송
                e <= 1;
                state <= 3;
            end
            3: begin
                e <= 0;
                data <= heart_pattern[index][3:0]; // 하위 4비트 전송
                e <= 1;
                index <= index + 1;
                if (index == 7) state <= 0; // 모든 패턴 전송 후 초기화
                else state <= 2;
            end
        endcase
    end
endmodule
