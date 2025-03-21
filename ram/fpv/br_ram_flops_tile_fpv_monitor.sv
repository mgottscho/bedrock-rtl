// Copyright 2025 The Bedrock-RTL Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`include "br_asserts.svh"
`include "br_registers.svh"

module br_ram_flops_tile_fpv_monitor #(
    parameter int Depth = 1,  // Must be at least 1
    parameter int Width = 1,  // Must be at least 1
    parameter int NumWritePorts = 1,  // Must be at least 1
    parameter int NumReadPorts = 1,  // Must be at least 1
    // If 1, allow partial writes to the memory using the wr_word_en signal.
    // If 0, only full writes are allowed and wr_word_en is ignored.
    parameter bit EnablePartialWrite = 0,
    // The width of a word in the memory. This is the smallest unit of data that
    // can be written when partial write is enabled.
    // Must be at least 1 and at most Width.
    // Width must be evenly divisible by WordWidth.
    parameter int WordWidth = Width,
    // If 1, then if the read and write ports access the same address on the same cycle,
    // the write data is forwarded directly to the read data with zero delay.
    // If 0, then if the read and write ports access the same address on the same cycle,
    // then read data is the value stored in the memory prior to the write.
    parameter bit EnableBypass = 0,
    // If 1, then the memory elements are cleared to 0 upon reset.
    parameter bit EnableReset = 0,
    // If 1, use structured mux2 gates for the read mux instead of relying on synthesis.
    // This is required if write and read clocks are different.
    parameter bit UseStructuredGates = 0,
    // If 1, then assert there are no valid bits asserted at the end of the test.
    parameter bit EnableAssertFinalNotValid = 1,
    localparam int AddrWidth = br_math::clamped_clog2(Depth),
    localparam int NumWords = Width / WordWidth
) (
    input logic                                    wr_clk,
    input logic                                    wr_rst,
    input logic [NumWritePorts-1:0]                wr_valid,
    input logic [NumWritePorts-1:0][AddrWidth-1:0] wr_addr,
    input logic [NumWritePorts-1:0][    Width-1:0] wr_data,
    input logic [NumWritePorts-1:0][ NumWords-1:0] wr_word_en,


    input logic                                   rd_clk,
    input logic                                   rd_rst,
    input logic [NumReadPorts-1:0]                rd_addr_valid,
    input logic [NumReadPorts-1:0][AddrWidth-1:0] rd_addr,
    input logic [NumReadPorts-1:0]                rd_data_valid,
    input logic [NumReadPorts-1:0][    Width-1:0] rd_data
);

  // ----------FV assumptions----------
  for (genvar i = 0; i < NumWritePorts; i++) begin : gen_i
    `BR_ASSUME_CR(legal_wr_addr_a, wr_valid[i] |-> wr_addr[i] < Depth, wr_clk, wr_rst)
    for (genvar j = 0; j < NumWritePorts; j++) begin : gen_j
      if (i != j) begin : gen_asm
        `BR_ASSUME_CR(unique_wr_addr_a, wr_valid[i] && wr_valid[j] |-> wr_addr[i] != wr_addr[j],
                      wr_clk, wr_rst)
      end
    end
  end

  for (genvar r = 0; r < NumReadPorts; r++) begin : gen_r
    `BR_ASSUME_CR(legal_rd_addr_a, rd_addr_valid[r] |-> rd_addr[r] < Depth, rd_clk, rd_rst)
  end

  // ----------FV Modeling Code----------
  // pick a random reference addr
  logic [AddrWidth-1:0] fv_addr;
  `BR_ASSUME_CR(fv_addr_stable_w_a, $stable(fv_addr) && (fv_addr < Depth), wr_clk, wr_rst)
  `BR_ASSUME_CR(fv_addr_stable_r_a, $stable(fv_addr) && (fv_addr < Depth), rd_clk, rd_rst)

  // pick a random read port to check
  localparam int ReadPortWidth = NumReadPorts == 1 ? 1 : $clog2(NumReadPorts);
  logic [ReadPortWidth-1:0] fv_rd_port;
  `BR_ASSUME_CR(fv_rd_port_stable_a, $stable(fv_rd_port) && (fv_rd_port < NumReadPorts), rd_clk,
                rd_rst)

  // This is writing to fv_addr
  logic fv_wr_valid;
  logic [Width-1:0] fv_wr_data;
  logic [NumWords-1:0] fv_wr_word_en;
  // This is reading from fv_addr
  logic fv_rd_valid;
  logic [Width-1:0] fv_rd_data;

  // FV memory only keeps tracking of traffic accessing fv_addr
  logic [Width-1:0] fv_mem_nxt;
  logic [Width-1:0] fv_mem;

  // write seen flag
  logic fv_wr_seen;
  logic [NumWords-1:0] fv_word_written;

  // Each cycle, write to fv_addr is onehot, read is not
  always_comb begin
    fv_wr_valid = 1'b0;
    fv_wr_data = 'd0;
    fv_wr_word_en = 'd0;
    for (int w = 0; w < NumWritePorts; w++) begin
      if (wr_valid[w] && (wr_addr[w] == fv_addr)) begin
        fv_wr_valid = 1'b1;
        fv_wr_data = wr_data[w];
        fv_wr_word_en = EnablePartialWrite ? wr_word_en[w] : {NumWords{1'b1}};
      end
    end
  end

  for (genvar n = 0; n < NumWords; n++) begin : gen_data
    localparam int Msb = (n + 1) * WordWidth;
    localparam int Lsb = (n) * WordWidth;
    assign fv_mem_nxt[Msb-1:Lsb] = fv_wr_word_en[n] ? fv_wr_data[Msb-1:Lsb] : fv_mem[Msb-1:Lsb];
  end


  `BR_REGLX(fv_mem, fv_mem_nxt, fv_wr_valid, wr_clk, EnableReset & wr_rst)
  `BR_REGLX(fv_wr_seen, 1'b1, fv_wr_valid, wr_clk, wr_rst)

  always_ff @(posedge wr_clk or posedge wr_rst) begin
    if (wr_rst) begin
      fv_word_written <= 'd0;
    end else begin
      for (int nm = 0; nm < NumWords; nm++) begin
        if (fv_wr_valid & fv_wr_word_en[nm]) begin
          fv_word_written[nm] <= 1'd1;
        end
      end
    end
  end

  assign fv_rd_valid = rd_addr_valid[fv_rd_port] && (rd_addr[fv_rd_port] == fv_addr);
  assign fv_rd_data  = rd_data[fv_rd_port];

  // ----------FV assertions----------
  if (EnableReset) begin : gen_rst
    if (EnableBypass) begin : gen_bypass_rst
      `BR_ASSERT_CR(memory_reset_a,
                    fv_rd_valid && !fv_wr_seen && !fv_wr_valid |-> fv_rd_data == 'd0, rd_clk,
                    rd_rst)
    end else begin : gen_non_bypass_rst
      `BR_ASSERT_CR(memory_reset_a, fv_rd_valid && !fv_wr_seen |-> fv_rd_data == 'd0, rd_clk,
                    rd_rst)
    end
  end

  `BR_ASSERT_CR(rd_data_valid_a, rd_addr_valid[fv_rd_port] |-> rd_data_valid[fv_rd_port], rd_clk,
                rd_rst)

  // once a word has been written, fv_mem/RTL should not have uninitialized spurious data
  // otherwise, fv_mem and RTL mem unitialized initial data won't match
  for (genvar n = 0; n < NumWords; n++) begin : gen_ast
    localparam int FvLsb = n * WordWidth;
    localparam int FvMsb = (n + 1) * WordWidth;
    // verilog_lint: waive-start line-length
    if (EnableBypass) begin : gen_bypass
      `BR_ASSERT_CR(data_integrity_bypass_a,
                    fv_rd_valid && fv_wr_valid && fv_wr_word_en[n] |-> fv_rd_data[FvMsb-1:FvLsb] == fv_mem_nxt[FvMsb-1:FvLsb],
                    rd_clk, rd_rst)
      `BR_ASSERT_CR(data_integrity_a,
                    fv_rd_valid && !fv_wr_valid && fv_word_written[n] |-> fv_rd_data[FvMsb-1:FvLsb] == fv_mem[FvMsb-1:FvLsb],
                    rd_clk, rd_rst)
      // verilog_lint: waive-stop line-length
    end else begin : gen_no_bypass
      `BR_ASSERT_CR(
          data_integrity_a,
          fv_rd_valid && fv_word_written[n] |-> fv_rd_data[FvMsb-1:FvLsb] == fv_mem[FvMsb-1:FvLsb],
          rd_clk, rd_rst)
    end
  end

endmodule : br_ram_flops_tile_fpv_monitor

bind br_ram_flops_tile br_ram_flops_tile_fpv_monitor #(
    .Depth(Depth),
    .Width(Width),
    .NumWritePorts(NumWritePorts),
    .NumReadPorts(NumReadPorts),
    .EnablePartialWrite(EnablePartialWrite),
    .WordWidth(WordWidth),
    .EnableBypass(EnableBypass),
    .EnableReset(EnableReset),
    .UseStructuredGates(UseStructuredGates),
    .EnableAssertFinalNotValid(EnableAssertFinalNotValid)
) monitor (.*);
