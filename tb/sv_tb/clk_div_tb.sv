`timescale 1ns/1ps

`define CLK_DIV_STAGE 3
`define CLK_FREQ  10e6  // Clock freq of 10MHz
`define CLK_PERIOD (1.0/`CLK_FREQ)
module clk_div_tb();
	reg clk_in;
	wire clk_out;
	wire clk_out_b;
	reg [`CLK_DIV_STAGE-1:0] div_ctrl;
	reg resetn;
	
	// freq measurement related variables
    real prev_time = 0;     // store previous clk posedge
    real curr_time = 0;     // store current clk posedge
    bit first_sample;       // Update measurement flag 
    real clk_freq;          // clk freq (measured)
    real exp_clk_freq;      // expected clk freq (calculated from equation)
	
	// clock generation block
	initial begin
		clk_in = 0;
		forever begin
			#((0.5/`CLK_FREQ) * 1s) clk_in = ~clk_in;
		end
	end
	
	// Test block
	initial begin
		// test reset
		resetn = 0;
		#(`CLK_PERIOD) resetn = 1;
		// test div_ctrl
		for(int i=0; i<`CLK_DIV_STAGE; i++) begin
			div_ctrl = i;
			repeat(10)
				#(`CLK_PERIOD *1s);
		end
	end
	
	// Monitor test settings
	initial begin
		$monitor("@:%t :: div_ctrl:%0d", $time, div_ctrl);
	end
	
	// Measure output clk freq
    always @(posedge clk_out) begin: FREQ_MEASURE
        if(!first_sample) begin
            prev_time = $time;
            first_sample = 1;
        end
        else begin
            curr_time = $time;
            // measure clk freq in hz
            clk_freq = (1.0 / (curr_time - prev_time)) * 1e9;
            $display("TimeDiff: %0e", (curr_time - prev_time));
            $display("@:%t clk_freq: %0e", $time, clk_freq);
            // calculate expected clk freq in hz
            exp_clk_freq = ( `CLK_FREQ/ (2 * 2**div_ctrl) );  
            $display("@:%t exp clk_freq: %0e", $time, exp_clk_freq);
            
            // freq check
            if(exp_clk_freq != clk_freq) begin
                $error("Expected and Measured Freq does not match. Expected Freq: %0e but Measured Freq: %0e", exp_clk_freq, clk_freq);
            end
            // update time 
            prev_time = curr_time;
        end
    end
	
	// reset the freq measurement
	always @(div_ctrl) begin
		first_sample = 0;
		disable FREQ_MEASURE;
	end
	
	// finish simulation using timeout
	initial begin
		# 1ms;
		$finish();
	end
	
	// Instantiation of DUT
	clock_divider#(
						.DIV_WIDTH(`CLK_DIV_STAGE)    		// Number of divider
					) DUT (
						.clk_in(clk_in),					// clock in
						.div_ctrl(div_ctrl),				// divider control
						.rstn(resetn),						// reset (active low)
						.clk_out(clk_out),			    	// clock out
						.clk_out_b(clk_out_b)				// complementary clock out
					);

endmodule