// -*- text -*-
`timescale 1ns/1ps

module cv_dataenc (
  input        clk,
  input        reset,
  input        cs,
  input  [7:0] din,
  input        din_en,
  output [9:0] dout);

////////////////////////////////////////

wire [3:0] din_bit1;
wire [8:0] q_m;

wire [3:0] q_m_bit0;
wire [3:0] q_m_bit1;

reg  signed [7:0] cnt_reg;

wire       cnt_eq_zero;
wire       cnt_gt_zero;
wire       cnt_lt_zero;
wire       qm1_eq_qm0;
wire       qm1_gt_qm0;
wire       qm0_gt_qm1;

wire       eval1;
wire       eval2;
wire       eval3;

reg  [4:0] tblout;

////////////////////////////////////////
cv_countbit # (
  .ISIZE(8),
  .OSIZE(4),
  .CBIT (1)) cbit0 (
  .din  (din),
  .dout (din_bit1));

assign eval1 = (din_bit1 > 3'd4 || (din_bit1 == 3'd4 && din[0] == 0));
assign q_m[0] = din[0];
assign q_m[1] = eval1 ^ q_m[0] ^ din[1];
assign q_m[2] = eval1 ^ q_m[1] ^ din[2];
assign q_m[3] = eval1 ^ q_m[2] ^ din[3];
assign q_m[4] = eval1 ^ q_m[3] ^ din[4];
assign q_m[5] = eval1 ^ q_m[4] ^ din[5];
assign q_m[6] = eval1 ^ q_m[5] ^ din[6];
assign q_m[7] = eval1 ^ q_m[6] ^ din[7];
assign q_m[8] = ~eval1;

//////////////////////////////

cv_countbit # (
  .ISIZE(8),
  .OSIZE(4),
  .CBIT (0)) cbit1 (
  .din  (q_m[7:0]),
  .dout (q_m_bit0));

cv_countbit # (
  .ISIZE(8),
  .OSIZE(4),
  .CBIT (1)) cbit2 (
  .din  (q_m[7:0]),
  .dout (q_m_bit1));

assign qm1_eq_qm0 = (q_m_bit1 == q_m_bit0);
assign qm1_gt_qm0 = (q_m_bit1 > q_m_bit0);
assign qm0_gt_qm1 = (q_m_bit0 > q_m_bit1);

assign eval2 = (cnt_eq_zero | qm1_eq_qm0);
assign eval3 = ((cnt_gt_zero & qm1_gt_qm0) | (cnt_lt_zero & qm0_gt_qm1));

// eval2 eval3 qm[8] | qout[9] qout[7:0] next_cnt
//   1     -     0   | ~qm[8]  ~qm[7:0]       qm0 - qm1 (00)
//   1     -     1   | ~qm[8]   qm[7:0]       qm1 - qm0 (01)
//   0     1     0   |    1    ~qm[7:0]       qm0 - qm1 (00)
//   0     1     1   |    1    ~qm[7:0]   2 + qm0 - qm1 (10)
//   0     0     0   |    0     qm[7:0]  -2 + qm1 - qm0 (11)
//   0     0     1   |    0     qm[7:0]       qm1 - qm0 (01)

always @*
begin
  casex ({eval2, eval3, q_m[8]})
  3'b1x0: tblout = 5'b10_1_00;
  3'b1x1: tblout = 5'b10_0_01;
  3'b010: tblout = 5'b01_1_00;
  3'b011: tblout = 5'b01_1_10;
  3'b000: tblout = 5'b00_0_11;
  3'b001: tblout = 5'b00_0_01;
  endcase
end

always @ (posedge clk, posedge reset)
begin
  if (reset == 1'b1)
    cnt_reg <= 8'b0;
  else if (cs == 1'b0)
    cnt_reg <= 8'b0;
  else if (din_en == 1'b0)
    cnt_reg <= cnt_reg;
  else if (tblout[1:0] == 2'b00)   cnt_reg <= cnt_reg + q_m_bit0 - q_m_bit1;
  else if (tblout[1:0] == 2'b01)   cnt_reg <= cnt_reg + q_m_bit1 - q_m_bit0;
  else if (tblout[1:0] == 2'b10)   cnt_reg <= cnt_reg + q_m_bit0 - q_m_bit1 + 8'd2;
  else                             cnt_reg <= cnt_reg + q_m_bit1 - q_m_bit0 - 8'd2;
end

assign cnt_eq_zero = (cnt_reg == 8'b0);
assign cnt_gt_zero = (cnt_reg > 0);
assign cnt_lt_zero = (cnt_reg < 0);

assign dout[9] = (tblout[4:3] == 2'b00 ? 1'b0 :
       	       	  tblout[4:3] == 2'b01 ? 1'b1 : ~q_m[8]);
assign dout[8] = q_m[8];
assign dout[7:0] = (tblout[2] == 1'b1 ? ~q_m[7:0] : q_m[7:0]);

endmodule
