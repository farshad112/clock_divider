////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: clock_divider.sv
// Author: Farshad
// Email: farshad112@gmail.com
// Date Created: 17-Nov-2018
// Description: Parameterized Clock divider module based of DFF
// License: MIT opensource License v3.0
// Copyright (c) 2018, Farshad
/* ###################### License Begin ##############################
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
######################### License End ################################ */
////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module clock_divider#(
						parameter DIV_WIDTH = 2,    						// Number of divider
						parameter FREQ_DIV_MODE = 2**DIV_WIDTH				// FREQ_DIV VALUE (n)
					) (
						input wire 					clk_in,					// clock in
						input wire [DIV_WIDTH-1:0]	div_ctrl,				// divider control
						input wire 					rstn,					// reset (active low)
						output reg					clk_out,			    // clock out
						output reg 					clk_out_b				// complementary clock out
					);
	
	wire [DIV_WIDTH-1:0] clk_div;
	wire [DIV_WIDTH-1:0] clk_div_b;
	wire [DIV_WIDTH-1:0] d_in;
	
	/*
		Equation of clk divider:
		clk_out = clk_in / (2 * 2^div_crtl)
	*/
	
	always_comb begin
		clk_out = !rstn ? 0 : clk_div[div_ctrl];
		clk_out_b = !rstn ? 1 : clk_div_b[div_ctrl];
	end
	
	genvar i;
	generate
		for(i=0; i< DIV_WIDTH; i++) begin : CLK_DIV
			not INV(d_in[i], clk_div[i]);
			if(i==0) begin				
				dff D(
						.D(d_in[i]),
						.clk(clk_in),
						.rstn(rstn),
						.Q(clk_div[i]),
						.Qb(clk_div_b[i])
					);
			end
			else begin
				dff D(
						.D(d_in[i]),
						.clk(clk_div[i-1]),
						.rstn(rstn),
						.Q(clk_div[i]),
						.Qb(clk_div_b[i])
					);
			end
		end		
	endgenerate
endmodule					