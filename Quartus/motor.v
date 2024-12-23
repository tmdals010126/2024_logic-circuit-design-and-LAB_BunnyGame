module motor(
    input clk,        // 입력 클럭
    input rst,        // 리셋 신호
    output reg a,     // 출력 핀 a
    output reg b,     // 출력 핀 b
    output reg c,     // 출력 핀 c
    output reg d      // 출력 핀 d
);

reg [1:0] count = 0;     // 2비트 카운터 (0~3까지 카운트)
reg [15:0] counter = 0;

initial begin
    count <= 0;
    counter = 0;;
    a = 0; b = 0; c = 0; d = 0;
end

// 카운터와 핀 출력 초기화
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        counter = 0;;
    end else begin
        counter = counter + 1;
        if(counter > 4) begin
            count <= count + 2'b01;  // 카운터 증가 (0 -> 1 -> 2 -> 3 -> 0)
            counter = 0;
        end        
    end
end

// 카운터 값에 따라 핀 출력 설정
always @(count) begin
    case (count)
        2'b00: begin a = 1; b = 0; c = 0; d = 0; end
        2'b01: begin a = 0; b = 1; c = 0; d = 0; end
        2'b10: begin a = 0; b = 0; c = 1; d = 0; end
        2'b11: begin a = 0; b = 0; c = 0; d = 1; end
        default: begin a = 0; b = 0; c = 0; d = 0; end
    endcase
end

endmodule
