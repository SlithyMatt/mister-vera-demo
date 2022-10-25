
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

reg   [9:0] hc;
reg   [9:0] vc;

always @(posedge clk) begin
	if(scandouble) ce_pix <= 1;
		else ce_pix <= ~ce_pix;

	if(reset) begin
		hc <= 0;
		vc <= 0;
	end
	else if(ce_pix) begin
		if(hc == 799) begin
			hc <= 0;
			if(vc == 524) begin 
				vc <= 0;
			end else begin
				vc <= vc + 1'd1;
			end
		end else begin
			hc <= hc + 1'd1;
		end

	end
end

always @(posedge clk) begin
	if (hc == 640) HBlank <= 1;
		else if (hc == 0) HBlank <= 0;

	if (hc == 656) begin
		HSync <= 1;

		if(vc == (scandouble ? 490 : 245)) VSync <= 1;
			else if (vc == (scandouble ? 492 : 246)) VSync <= 0;

		if(vc == (scandouble ? 480 : 240)) VBlank <= 1;
			else if (vc == 0) VBlank <= 0;
	end
	
	if (hc == 752) HSync <= 0;
end

always @(posedge clk) begin
	if(vc < (scandouble ? 320 : 160)) begin // vertical bars
		case (hc)
			0:	  video <= 24'hB4B4B4; // 75% white
			91:  video <= 24'hB4B410; // 75% yellow
			183: video <= 24'h10B4B4; // 75% cyan
			274: video <= 24'h10B410; // 75% green
			366: video <= 24'hB410B4; // 75% magenta
			457: video <= 24'hB41010; // 75% red
			549: video <= 24'h1010B4; // 75% blue
		endcase
	end
	else if (vc < (scandouble ? 373 : 187)) begin // castellations
		case (hc)
			0:	  video <= 24'h1010B4; // 75% blue
			91:  video <= 24'h101010; // 75% black
			183: video <= 24'hB410B4; // 75% magenta
			274: video <= 24'h101010; // 75% black
			366: video <= 24'h10B4B4; // 75% cyan
			457: video <= 24'h101010; // 75% black
			549: video <= 24'hB4B4B4; // 75% white
		endcase
	end
	else begin // squares
		case (hc)
			0:	  video <= 24'h10466A; // -I
			107: video <= 24'hEBEBEB; // 100% white
			213: video <= 24'h481076; // +Q
			320: video <= 24'h101010; // 75% black
		endcase
	end

end

endmodule
