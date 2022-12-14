module sprite_ram(
    input wire          wr_clk_i,
    input wire          rd_clk_i,
    input wire          rst_i,
    input wire          wr_clk_en_i,
    input wire          rd_en_i,
    input wire          rd_clk_en_i,
    input wire          wr_en_i,
    input wire   [3:0]  ben_i,
    input wire   [31:0] wr_data_i,
    input wire   [7:0]  wr_addr_i,
    input wire   [7:0]  rd_addr_i,
    output logic [31:0] rd_data_o
);

logic unused_signals = &{ 1'b0, rst_i, wr_clk_en_i, rd_en_i, rd_clk_en_i };

// infer 16x256 color BRAM
logic [31:0] bram[0:255];

initial begin
    $readmemh("sprite_ram.mem", bram, 0);
end

// infer BRAM block
always_ff @(posedge wr_clk_i) begin
    if (wr_en_i) begin
        if (ben_i[3]) begin
            bram[wr_addr_i][31:24] <= wr_data_i[31:24];
        end
        if (ben_i[2]) begin
            bram[wr_addr_i][23:16] <= wr_data_i[23:16];
        end
        if (ben_i[1]) begin
            bram[wr_addr_i][15:8] <= wr_data_i[15:8];
        end
        if (ben_i[0]) begin
            bram[wr_addr_i][7:0] <= wr_data_i[7:0];
        end
    end
end

always_ff @(posedge rd_clk_i) begin
    rd_data_o <= bram[rd_addr_i];
end

endmodule
