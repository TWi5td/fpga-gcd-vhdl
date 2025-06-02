`timescale 1ns / 1ps

module gcd_thread (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] val_in,
    output reg [7:0] val_out,
    output reg done
);
    
    reg [7:0] A, B;
    reg [1:0] state;
    
    localparam IDLE = 2'b00, LOAD_A = 2'b01, LOAD_B = 2'b10, COMPUTE = 2'b11;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            A <= 0;
            B <= 0;
            done <= 0;
            val_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (load) state <= LOAD_A;
                end
                
                LOAD_A: begin
                    A <= val_in;
                    state <= LOAD_B;
                end
                
                LOAD_B: begin
                    B <= val_in;
                    state <= COMPUTE;
                end
                
                COMPUTE: begin
                    if (B == 0) begin
                        val_out <= A;
                        done <= 1;
                        state <= IDLE;
                    end else begin
                        A <= B;
                        B <= A % B;
                    end
                end
            endcase
        end
    end
    
endmodule