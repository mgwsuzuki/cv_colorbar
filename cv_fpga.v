// -*- text -*-
`timescale 1 ps / 1 ps

module cv_fpga (
  inout [14:0] DDR_addr,
  inout  [2:0] DDR_ba,
  inout        DDR_cas_n,
  inout        DDR_ck_n,
  inout        DDR_ck_p,
  inout        DDR_cke,
  inout        DDR_cs_n,
  inout  [3:0] DDR_dm,
  inout [31:0] DDR_dq,
  inout  [3:0] DDR_dqs_n,
  inout  [3:0] DDR_dqs_p,
  inout        DDR_odt,
  inout        DDR_ras_n,
  inout        DDR_reset_n,
  inout        DDR_we_n,
  inout        FIXED_IO_ddr_vrn,
  inout        FIXED_IO_ddr_vrp,
  inout [53:0] FIXED_IO_mio,
  inout        FIXED_IO_ps_clk,
  inout        FIXED_IO_ps_porb,
  inout        FIXED_IO_ps_srstb,

  input        reset,
  output       seri_r_p,
  output       seri_r_n,
  output       seri_g_p,
  output       seri_g_n,
  output       seri_b_p,
  output       seri_b_n,
  output       seri_clk_p,
  output       seri_clk_n,
  output       led1,
  output       led0
);

////////////////////////////////////////
wire       clk;
wire       clk10x;
wire       resetn;
wire       oserdes_reset;
wire [9:0] hdmi_r;
wire [9:0] hdmi_g;
wire [9:0] hdmi_b;
wire       seri_r;
wire       seri_g;
wire       seri_b;
wire       seri_clk;

////////////////////////////////////////
  design_1 ps0 (
    .DDR_addr          (DDR_addr),
    .DDR_ba            (DDR_ba),
    .DDR_cas_n         (DDR_cas_n),
    .DDR_ck_n          (DDR_ck_n),
    .DDR_ck_p          (DDR_ck_p),
    .DDR_cke           (DDR_cke),
    .DDR_cs_n          (DDR_cs_n),
    .DDR_dm            (DDR_dm),
    .DDR_dq            (DDR_dq),
    .DDR_dqs_n         (DDR_dqs_n),
    .DDR_dqs_p         (DDR_dqs_p),
    .DDR_odt           (DDR_odt),
    .DDR_ras_n         (DDR_ras_n),
    .DDR_reset_n       (DDR_reset_n),
    .DDR_we_n          (DDR_we_n),
    .FIXED_IO_ddr_vrn  (FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp  (FIXED_IO_ddr_vrp),
    .FIXED_IO_mio      (FIXED_IO_mio),
    .FIXED_IO_ps_clk   (FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb  (FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb (FIXED_IO_ps_srstb),
    .resetn            (resetn),
    .clk               (clk),
    .clk10x            (clk10x));

assign resetn = ~reset;

cv_colorbar c0 (
  .clk           (clk),
  .reset         (reset),
  .oserdes_reset (oserdes_reset),

  .hdmi_r (hdmi_r),
  .hdmi_g (hdmi_g),
  .hdmi_b (hdmi_b)
);

oserdese2_10b sr0 (
  .clk    (clk10x),
  .clkdiv (clk),
  .reset  (oserdes_reset),
  .din    (hdmi_r),
  .dout   (seri_r)
);

oserdese2_10b sg0 (
  .clk    (clk10x),
  .clkdiv (clk),
  .reset  (oserdes_reset),
  .din    (hdmi_b),
  .dout   (seri_b)
);

oserdese2_10b sb0 (
  .clk    (clk10x),
  .clkdiv (clk),
  .reset  (oserdes_reset),
  .din    (hdmi_g),
  .dout   (seri_g)
);

oserdese2_10b sc0 (
  .clk    (clk10x),
  .clkdiv (clk),
  .reset  (oserdes_reset),
  .din    (10'b00000_11111),
  .dout   (seri_clk)
);

OBUFDS #(
  .IOSTANDARD ("TMDS_33")) obufr0 (
  .I  (seri_r),
  .O  (seri_r_p),
  .OB (seri_r_n));

OBUFDS #(
  .IOSTANDARD ("TMDS_33")) obufg0 (
  .I  (seri_g),
  .O  (seri_g_p),
  .OB (seri_g_n));

OBUFDS #(
  .IOSTANDARD ("TMDS_33")) obufb0 (
  .I  (seri_b),
  .O  (seri_b_p),
  .OB (seri_b_n));

OBUFDS #(
  .IOSTANDARD ("TMDS_33")) obufc0 (
  .I  (seri_clk),
  .O  (seri_clk_p),
  .OB (seri_clk_n));

////////////////////////////////////////
// hb
cv_hb # (
  .CLKFREQ(65000000)) hb0 (
  .clk   (clk),
  .reset (reset),
  .hbout (led0)
);

cv_hb # (
  .CLKFREQ(325000000)) hb1 (
  .clk   (clk10x),
  .reset (reset),
  .hbout (led1)
);

endmodule

