//`default_nettype none

module main_ram(
    input  wire        clk,

    // Slave bus interface
    input  wire [14:0] bus_addr,
    input  wire [31:0] bus_wrdata,
    input  wire  [3:0] bus_wrbytesel,
    output reg  [31:0] bus_rddata,
    input  wire        bus_write);



endmodule
