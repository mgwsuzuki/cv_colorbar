// -*- text -*-
`timescale 1ns/1ps

module cv_colorbar (
  input        clk,
  input        reset,

  output       oserdes_reset,

  output [9:0] hdmi_r,
  output [9:0] hdmi_g,
  output [9:0] hdmi_b
);

////////////////////////////////////////
wire       h_front;
wire       h_sync;
wire       h_back;
wire       h_preamble;
wire       h_guard;
wire       h_active;
wire [9:0] h_count;
wire       v_front;
wire       v_sync;
wire       v_back;
wire       v_active;
wire [9:0] v_count;

wire [1:0] ctrl_r;
wire [1:0] ctrl_g;
wire [1:0] ctrl_b;
wire [9:0] ctrl_encout_r;
wire [9:0] ctrl_encout_g;
wire [9:0] ctrl_encout_b;

wire [9:0] data_encout_r;
wire [9:0] data_encout_g;
wire [9:0] data_encout_b;

reg  [9:0] hdmi_r_reg;
reg  [9:0] hdmi_g_reg;
reg  [9:0] hdmi_b_reg;

reg  [2:0] reset_reg;

////////////////////////////////////////
cv_timing tmg0 (
  .clk        (clk),
  .reset      (reset),
  .cs         (1'b1),
  .h_front    (h_front),
  .h_sync     (h_sync),
  .h_back     (h_back),
//  .h_preamble (h_preamble),
//  .h_guard    (h_guard),
  .h_preamble (),
  .h_guard    (),
  .h_active   (h_active),
  .h_count    (h_count),
  .v_front    (v_front),
  .v_sync     (v_sync),
  .v_back     (v_back),
  .v_active   (v_active),
  .v_count    (v_count)
);

assign h_preamble = 1'b0;
assign h_guard = 1'b0;

////////////////////////////////////////
assign ctrl_b = {v_sync, h_sync};
assign ctrl_g = (h_preamble == 1'b1 ? 2'b01 : 2'b00);
assign ctrl_r = 2'b00;

cv_2b10b b2b10b (
  .din  (ctrl_b),
  .dout (ctrl_encout_b));

cv_2b10b b2b10g (
  .din  (ctrl_g),
  .dout (ctrl_encout_g));

cv_2b10b b2b10r (
  .din  (ctrl_r),
  .dout (ctrl_encout_r));

////////////////////////////////////////
cv_dataenc denc0 (
  .clk    (clk),
  .reset  (reset),
  .cs     (v_active),
  .din    ({h_count[9:8], 6'b0}),
  .din_en (h_active),
  .dout   (data_encout_r));

cv_dataenc denc1 (
  .clk    (clk),
  .reset  (reset),
  .cs     (v_active),
  .din    ({h_count[7:6], 6'b0}),
  .din_en (h_active),
  .dout   (data_encout_g));

cv_dataenc denc2 (
  .clk    (clk),
  .reset  (reset),
  .cs     (v_active),
  .din    ({h_count[5:4], 6'b0}),
  .din_en (h_active),
  .dout   (data_encout_b));

////////////////////////////////////////
always @ (posedge clk, posedge reset)
begin
  if (reset == 1'b1) begin
    hdmi_b_reg <= 1'b0;
    hdmi_g_reg <= 1'b0;
    hdmi_r_reg <= 1'b0;
  end else begin
    hdmi_b_reg <= (h_guard == 1'b1  ? 10'b10_1100_1100 :
       	      	   h_active == 1'b1 ? data_encout_b : ctrl_encout_b);
    hdmi_g_reg <= (h_guard == 1'b1  ? 10'b01_0011_0011 :
       	      	   h_active == 1'b1 ? data_encout_g : ctrl_encout_g);
    hdmi_r_reg <= (h_guard == 1'b1  ? 10'b10_1100_1100 :
       	      	   h_active == 1'b1 ? data_encout_r : ctrl_encout_r);
  end
end

assign hdmi_b = hdmi_b_reg;
assign hdmi_g = hdmi_g_reg;
assign hdmi_r = hdmi_r_reg;

////////////////////////////////////////
always @ (posedge clk, posedge reset)
begin
  if (reset == 1'b1)
    reset_reg <= 3'b111;
  else
    reset_reg <= {reset_reg[1:0], 1'b0};
end

assign oserdes_reset = reset_reg[2];

endmodule
