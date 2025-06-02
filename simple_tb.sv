`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2025 12:12:36 PM
// Design Name: 
// Module Name: simple_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module simple_tb(

    );
    
    parameter CLK_PRD = 10;
    parameter HLD_TIME = 2;
    
    logic clk;
    initial begin 
        clk = 0;
        forever #(CLK_PRD/2) clk = ~clk;
    end
    
    initial begin #(1000*CLK_PRD) $finish; end
    
    
    logic rst, load, done;
    logic [7:0] val_in;
    logic [7:0] val_out;
    gcd_thread dut(
    .clk(clk),
    .rst(rst),
    .val_in(val_in),
    .load(load),
    .val_out(val_out),
    .done(done));
    
    //gcd_thread dut(.*);
    
    initial
    begin
        rst = 1;
        load = 0;
        val_in = 0;
        #100;
        
        @(posedge clk);
        #HLD_TIME;
        rst = 0;
        
        #CLK_PRD;
        
        load = 1;
        
        #CLK_PRD;
        
        load = 0;
        
        val_in = 8;
        
        #CLK_PRD;
        
        val_in = 20;
        
        #CLK_PRD;
        
        val_in = 0;
        
        @ (posedge done);
        
        $display("The value of the GCD for 8 and 20 is %0d", val_out);
        
        test_gcd(18, 45);
        
        test_gcd(28, 49);
        
        $finish;
    end
    
    
  task test_gcd(input [7:0] a, b);
    @(posedge clk);
    #HLD_TIME;
    load = 1;
    #CLK_PRD;
    val_in = a;
    load = 0;
    #CLK_PRD;
    val_in = b;
    #CLK_PRD;
    val_in = 0;
    @(posedge done);
    $display("The value of the GCD for %0d and %0d is %0d ", a, b, val_out);
  endtask   
  
endmodule
