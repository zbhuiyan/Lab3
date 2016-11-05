// TODO: Move these tests into the main file after we consolidate.

`include "cpu.v"

module testDavidsStuff ();

  reg clk;

  // DUT.
  CPU dut ();

  // Start the clock.
  initial clk = 1;
  always #1 clk = !clk;

  reg dutPassed;

  initial begin

    $dumpfile("cpu.vcd");
    $dumpvars;
    dutPassed = 1;

    // J =======================================================================

    // JR ======================================================================

    // JAL =====================================================================

    // JSUB ====================================================================

    $finish;
  end
endmodule
