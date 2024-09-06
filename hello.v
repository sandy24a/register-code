module regfile(
    input [31:0] Ip1,
    input [3:0] sel_i1, sel_o1, sel_o2,
    input RD, WR,
    input EN, clk, rst,
    output reg [31:0] op1, op2
);

reg [31:0] regFile [0:15];
integer i;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        // Reset all registers to 0
        for (i = 0; i < 16; i = i + 1) begin
            regFile[i] <= 32'h0;
        end
        op1 <= 32'hx;
        op2 <= 32'hx;
    end else if (EN) begin
        case ({RD, WR})
            2'b00: begin
                // No operation
            end
            2'b01: begin
                // Write to register
                regFile[sel_i1] <= Ip1;
            end
            2'b10: begin
                // Read from registers
                op1 <= regFile[sel_o1];
                op2 <= regFile[sel_o2];
            end
            2'b11: begin
                // Read from registers and write to a register
                op1 <= regFile[sel_o1];
                op2 <= regFile[sel_o2];
                regFile[sel_i1] <= Ip1;
            end
        endcase
    end
end

endmodule
