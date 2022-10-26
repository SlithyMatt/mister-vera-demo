
module verademo
(
	input         clk,
	input         reset,

	input         scandouble,
	
	output reg    ce_pix,

	output reg    HBlank,
	output reg    HSync,
	output reg    VBlank,
	output reg    VSync,

	output  [23:0] video
);

// External bus interface
reg       extbus_cs_n = 0;     //* Chip select */
reg       extbus_rd_n = 0;     //* Read strobe */
reg       extbus_wr_n = 0;     //* Write strobe */
reg [4:0] extbus_a = 5'b00000; //* Address */
wire [7:0] extbus_d;           //* Data (bi-directional) */
wire      extbus_irq_n;        //* IRQ */

// VGA interface
wire  [3:0] vga_r;       //* synthesis syn_useioff = 1 */
wire  [3:0] vga_g;       //* synthesis syn_useioff = 1 */
wire  [3:0] vga_b;       //* synthesis syn_useioff = 1 */

// SPI interface
wire       spi_sck;
wire       spi_mosi;
reg        spi_miso = 0;
wire       spi_ssel_n_sd;

// Audio output
wire       audio_lrck;
wire       audio_bck;
wire       audio_data;

vera vera(
	.clk25(clk),
	.extbus_cs_n(extbus_cs_n),
	.extbus_rd_n(extbus_rd_n),
	.extbus_wr_n(extbus_wr_n),
	.extbus_a(extbus_a),
	.extbus_d(extbus_d),
	.extbus_irq_n(extbus_irq_n),
	.vga_r(vga_r),
	.vga_g(vga_g),
	.vga_b(vga_b),
	.vga_hsync(HSync),
	.vga_vsync(VSync),
	.vga_hblank(HBlank),
	.vga_vblank(VBlank),
	.spi_sck(spi_sck),
   .spi_mosi(spi_mosi),
   .spi_miso(spi_miso),
   .spi_ssel_n_sd(spi_ssel_n_sd),
	.audio_lrck(audio_lrck),
   .audio_bck(audio_bck),
   .audio_data(audio_data)
);

assign video = {vga_r, vga_r, vga_g, vga_g, vga_b, vga_b};

always @(posedge clk) begin
	if(scandouble) ce_pix <= 1;
		else ce_pix <= ~ce_pix;

	if (reset) begin
		extbus_cs_n <= 0;
		extbus_rd_n <= 0;
		extbus_wr_n <= 0;
		extbus_a <= 5'b00000;
		extbus_d <= 8'h00;
		spi_miso <= 0;
	end
end



endmodule
