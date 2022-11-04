//`default_nettype none

module main_ram(
    input  wire        clk,

    // Slave bus interface
    input  wire [14:0] bus_addr,
    input  wire [31:0] bus_wrdata,
    input  wire  [3:0] bus_wrbytesel,
    output reg  [31:0] bus_rddata,
    input  wire        bus_write);

    wire blk10_cs = !bus_addr[14];
    wire blk32_cs = bus_addr[14];
    wire [31:0] blk10_rddata;
    wire [31:0] blk32_rddata;

    reg bus_addr14;
    always @(posedge clk) bus_addr14 <= bus_addr[14];

    always @* bus_rddata = bus_addr14 ? blk32_rddata : blk10_rddata;

    wire blk10_wren;
    assign blk10_wren = blk10_cs & |bus_wrbytesel & bus_write;
	 
    vram_bank #(.VRAM_BANK_INIT_FILE ("vram0.mif")) blk10
    (
        .address(bus_addr[13:0]),
        .byteena(bus_wrbytesel),
        .clock(clk),
        .data(bus_wrdata),
        .wren(blk10_wren),
        .q(blk10_rddata)
    );

	 
    wire blk32_wren;
    assign blk32_wren = blk32_cs & |bus_wrbytesel & bus_write;
	
    vram_bank #(.VRAM_BANK_INIT_FILE ("vram1.mif")) blk32
    (
        .address(bus_addr[13:0]),
        .byteena(bus_wrbytesel),
        .clock(clk),
        .data(bus_wrdata),
        .wren(blk32_wren),
        .q(blk32_rddata)
    );


endmodule
