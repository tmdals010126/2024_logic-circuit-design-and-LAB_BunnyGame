module hit_COLORLED (
    input wire clk,        // 입력 클럭
    input wire rst,      // 리셋 신호
    input wire hit,
    output reg [3:0] GREEN,
    output reg [3:0] RED,
    output reg [3:0] BLUE
);

    reg [3:0] toggle_hit;       // 목숨 토글 레지스터
    reg [31:0] counter;

    initial begin
        counter <= 0;
        toggle_hit <= 0;
        GREEN <= 4'b1111;
        RED <= 4'b0000;
        BLUE <= 4'b0000;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            toggle_hit <= 0;
            GREEN <= 4'b1111;
            RED <= 4'b0000;
            BLUE <= 4'b0000;
        end else begin
            if(hit)begin
                toggle_hit <= 1;
                counter <= 0;
            end
            else begin
                if(toggle_hit) begin
                    counter = counter + 1;
                    if(counter > 1000000) begin
                        counter = 0;
                        GREEN <= 4'b1111;
                        RED <= 4'b0000;
                        toggle_hit <= 0;
                    end
                    else begin
                        RED <= 4'b1111;
                        GREEN <= 4'b0000;
                    end
                end
            end
        end
    end
endmodule
