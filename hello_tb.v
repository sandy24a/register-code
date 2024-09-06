`timescale 1ns/1ps

// Define the regFile module
module regFile (
    input [31:0] Ip1,
    input [3:0] sel_i1, sel_o1, sel_o2,
    input RD, WR,
    input EN, clk, rst,
    output reg [31:0] op1, op2
);

    reg [31:0] regFile [0:15];
    integer i;

    always @(posedge clk or posedge rst) begin
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

// Define the testbench module
module regFile_tb;

    reg [31:0] Ip1;
    reg [3:0] sel_i1;
    reg [3:0] sel_o1;
    reg [3:0] sel_o2;
    reg RD;
    reg WR;
    reg rst;
    reg EN;
    reg clk;
    wire [31:0] op1;
    wire [31:0] op2;

    // Instantiate the regFile module
    regFile dut (
        .Ip1(Ip1), 
        .sel_i1(sel_i1), 
        .op1(op1), 
        .sel_o1(sel_o1), 
        .op2(op2), 
        .sel_o2(sel_o2), 
        .RD(RD), 
        .WR(WR), 
        .rst(rst), 
        .EN(EN), 
        .clk(clk)
    );

    initial begin
        // VCD file generation
        $dumpfile("regFile_tb.vcd");  // Specify the VCD file name
        $dumpvars(0, regFile_tb);     // Dump all variables in the current module

        // Initial signal setup
        Ip1 = 32'b0;
        sel_i1 = 4'b0;
        sel_o1 = 4'b0;
        sel_o2 = 4'b0;
        RD = 1'b0;
        WR = 1'b0;
        rst = 1'b1;
        EN = 1'b0;
        clk = 1'b0;
        
        // Wait for 100 time units and then de-assert reset
        #100;
        rst = 1'b0;
        EN = 1'b1;
        
        // Write to register 0
        #20;
        WR = 1'b1;
        RD = 1'b0;
        Ip1 = 32'habcdefab;  // Corrected hex value assignment
        sel_i1 = 4'h0;
        
        // Write to register 1
        #20;
        Ip1 = 32'h01234567;
        sel_i1 = 4'h1;
        
        // Read from registers 0 and 1
        #20;
        WR = 1'b0;
        RD = 1'b1;
        sel_o1 = 4'h0;
        sel_o2 = 4'h1;

        // End simulation after a while
        #100;
        $finish;
    end

    // Clock generation
    always begin
        #10 clk = ~clk;
    end

endmodule
