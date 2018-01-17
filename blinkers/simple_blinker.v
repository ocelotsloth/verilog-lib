/**
 * Blinker module turns an output on and off over time.
 *
 * Original code from:
 *   https://embeddedmicro.com/tutorials/mojo/synchronous-logic
 *
 * Descriptive comments courtesy of Mark Stenglein <mark@stengle.in>
 *
 * Example instantiation:
 *   blinker blink_one (
 *     .clk(clk),
 *     .rst(rst),
 *     .blink(led[0])
 *   );
 */
module simple_blinker(
  input clk,   // Clock input
  input rst,   // Reset input
  output blink // Oscillating output
);

// Reg stands for a "Register"
//
// Registers are different from wires in that they are
// required in order to drive a signal. Ultimately, in this case
// the important thing to remember is that a register is required
// to assign a value inside of an "always" block, which is coming
// up soon.
//
// Registers *can* be turned into a flip flop, and typically will
// become one, but not always.
//
// The d and q suffixs come from the logic diagram for a flip
// flop, and represent the signals for each.
reg [24:0] counter_d, counter_q;

// By assigning the output "blink" to the most significant digit
// in counter_q, the output will oscillate as the counter is
// filled and overloaded and filled again.
assign blink = counter_q[24];

// This is a combinational always block, which will cause the inner
// function to be run only under certain conditions.
//
// These conditions, called "sensitivities" are listed in the sensitivity
// list "@(<sensitivities here>)". In this case, the inner code block will
// run only when "counter_q" changes value.
always @(counter_q) begin
  // This line builds part of a loop. Whenever q changes, 1'b1 is added to
  // the value of d. In the next always block, the value of d is set to q.
  counter_d = counter_q + 1'b1;
end

// This is a synchronous always block. Basically, the "posedge" keyword
// means that this always block is only sensitive to the rising edge of
// "clk." In other words, it will not be triggered on the falling edge.
always @(posedge clk) begin
  if (rst) begin
    // This reset section resets the module to a known state when the reset
    // button is pressed by the user.
    counter_q <= 25'b0;
  end else begin
    counter_q <= counter_d;
  end
end

endmodule // simple_blinker