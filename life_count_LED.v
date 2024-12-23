module life_count_LED (
    input wire clk,        // 입력 클럭
    input wire rst,      // 리셋 신호
    input wire hit,
    output reg life_0,
    output reg life_1,
    output reg life_2,
    output reg die
);

    reg [3:0] count = 3;       // 목숨 카운트 레지스터

    initial begin
        count <= 4'h3;
        life_0 <= 1;
        life_1 <= 1;
        life_2 <= 1;
        die <= 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'h3;
            life_0 <= 1;
            life_1 <= 1;
            life_2 <= 1;
            die <= 0;
        end else begin
            if(hit)begin
                count = count -1;
            end
            case (count)
                3:begin
                    life_0 <= 1;
                    life_1 <= 1;
                    life_2 <= 1;
                    die <= 0;
                end
                2:begin
                    life_0 <= 1;
                    life_1 <= 1;
                    life_2 <= 0;
                    die <= 0;
                end
                1:begin
                    life_0 <= 1;
                    life_1 <= 0;
                    life_2 <= 0;
                    die <= 0;                    
                end
                0:begin
                    life_0 <= 0;
                    life_1 <= 0;
                    life_2 <= 0;
                    die <= 1;                    
                end
            endcase
        end
    end

endmodule
