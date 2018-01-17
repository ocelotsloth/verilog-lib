/**
 * Blinker module which takes a vector input determining the delay.
 *
 * Doesn't work yet.
 *
 * Copyright 2018 Mark Stenglein <mark@stengle.in>
 */
module variable_blinker(
  input clk,   // Clock input
  input rst,   // Reset input
  input [9:0]rate, // Blink rate (multiples of 1.311 ms)
  output blink // Oscillating output
);

reg [16:0] counter_d, counter_q;
reg out;
wire out_n = ~out;

always @(counter_q) begin
  counter_d = counter_q + 1'b1;
end

reg [9:0] out_counter_d, out_counter_q;

always @(negedge counter_q[16]) begin
  out_counter_d = out_counter_q + 1'b1;
end

always @(posedge clk) begin
  if (rst) begin
    counter_q <= 17'b0;
    out_counter_q <= 9'b0;
    out <= 1'b0;
  end else begin
    if (out_counter_q >= rate) begin
      out <= ~out_n;
      out_counter_q <= 10'b0;
    end else begin
      out_counter_q <= out_counter_d;
    end

    counter_q <= counter_d;
  end
end

endmodule // variable_blinker