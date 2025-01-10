// Copyright 2024 The Bedrock-RTL Authors
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

// Bedrock-RTL FIFO Push Controller (Credit/Valid)

`include "br_asserts_internal.svh"
`include "br_registers.svh"
`include "br_unused.svh"

module br_fifo_push_ctrl_credit #(
    parameter int Depth = 2,
    parameter int Width = 1,
    parameter bit EnableBypass = 0,
    parameter int MaxCredit = Depth,
    parameter bit RegisterPushCredit = 0,
    // If 1, then assert there are no valid bits asserted and that the FIFO is
    // empty at the end of the test.
    parameter bit EnableAssertFinalNotValid = 1,
    localparam int AddrWidth = $clog2(Depth),
    localparam int CountWidth = $clog2(Depth + 1),
    localparam int CreditWidth = $clog2(MaxCredit + 1)
) (
    // Posedge-triggered clock.
    input logic clk,
    // Synchronous active-high reset.
    input logic rst,

    // Push-side interface.
    input  logic             push_credit_stall,
    output logic             push_credit,
    input  logic             push_valid,
    input  logic [Width-1:0] push_data,

    // Push-side status flags
    output logic                  full,
    output logic                  full_next,
    output logic [CountWidth-1:0] slots,
    output logic [CountWidth-1:0] slots_next,

    // Push-side credits
    input  logic [CreditWidth-1:0] credit_initial_push,
    input  logic [CreditWidth-1:0] credit_withhold_push,
    output logic [CreditWidth-1:0] credit_count_push,
    output logic [CreditWidth-1:0] credit_available_push,

    // Bypass interface
    // Bypass is only used when EnableBypass is 1, hence lint waiver.
    input logic bypass_ready,  // ri lint_check_waive INEFFECTIVE_NET
    output logic bypass_valid_unstable,
    output logic [Width-1:0] bypass_data_unstable,

    // RAM interface
    output logic                 ram_wr_valid,
    output logic [AddrWidth-1:0] ram_wr_addr,
    output logic [    Width-1:0] ram_wr_data,

    // Internal handshakes between push and pop controllers
    output logic push_beat,
    input  logic pop_beat
);

  //------------------------------------------
  // Integration checks
  //------------------------------------------
  `BR_ASSERT_STATIC(depth_must_be_at_least_one_a, Depth >= 2)
  `BR_ASSERT_STATIC(bit_width_must_be_at_least_one_a, Width >= 1)
  `BR_ASSERT_STATIC(credit_width_a, CreditWidth >= $clog2(Depth + 1))

  `BR_COVER_INTG(full_c, full)

  //------------------------------------------
  // Implementation
  //------------------------------------------

  // Flow control
  logic internal_valid;
  logic [Width-1:0] internal_data;

  br_credit_receiver #(
      .Width                    (Width),
      .MaxCredit                (MaxCredit),
      .RegisterPushCredit       (RegisterPushCredit),
      .EnableAssertFinalNotValid(EnableAssertFinalNotValid)
  ) br_credit_receiver (
      .clk,
      .rst,
      .push_credit_stall(push_credit_stall),
      .push_credit(push_credit),
      .push_valid(push_valid),
      .push_data(push_data),
      .pop_credit(pop_beat),
      .pop_valid(internal_valid),
      .pop_data(internal_data),
      .credit_initial(credit_initial_push),
      .credit_withhold(credit_withhold_push),
      .credit_count(credit_count_push),
      .credit_available(credit_available_push)
  );

  // Core flow-control logic
  br_fifo_push_ctrl_core #(
      .Depth(Depth),
      .Width(Width),
      .EnableBypass(EnableBypass),
      // The core push control should never be backpressured.
      .EnableCoverPushBackpressure(0),
      .EnableAssertFinalNotValid(EnableAssertFinalNotValid)
  ) br_fifo_push_ctrl_core (
      .clk,
      .rst,

      .push_ready(),
      .push_valid(internal_valid),
      .push_data (internal_data),

      .bypass_ready,
      .bypass_valid_unstable,  // ri lint_check_waive CONST_OUTPUT
      .bypass_data_unstable,  // ri lint_check_waive CONST_OUTPUT

      .ram_wr_valid,
      .ram_wr_addr,
      .ram_wr_data,

      .full,
      .push_beat
  );

  // Status flags
  br_counter #(
      .MaxValue(Depth),
      .EnableAssertFinalNotValid(EnableAssertFinalNotValid)
  ) br_counter_slots (
      .clk,
      .rst,

      .reinit(1'b0),
      .initial_value(CountWidth'($unsigned(Depth))),

      .incr_valid(pop_beat),
      .incr      (1'b1),

      .decr_valid(push_beat),
      .decr      (1'b1),

      .value     (slots),
      .value_next(slots_next)
  );

  assign full_next = slots_next == 0;
  `BR_REGL(full, full_next, push_beat || pop_beat)

  //------------------------------------------
  // Implementation checks
  //------------------------------------------
  `BR_ASSERT_IMPL(ram_wr_addr_in_range_a, ram_wr_valid |-> ram_wr_addr < Depth)

  // Flow control and latency
  `BR_ASSERT_IMPL(no_overflow_a, internal_valid |-> !full)
  `BR_ASSERT_IMPL(ram_push_and_bypass_mutually_exclusive_a,
                  !(ram_wr_valid && bypass_ready && bypass_valid_unstable))
  `BR_COVER_IMPL(bypass_unstable_c, !bypass_ready && bypass_valid_unstable)

  // Flags
  `BR_ASSERT_IMPL(slots_in_range_a, slots <= Depth)
  `BR_ASSERT_IMPL(slots_next_a, ##1 slots == $past(slots_next))
  `BR_ASSERT_IMPL(push_and_pop_slots_a, push_beat && pop_beat |-> slots_next == slots)
  `BR_ASSERT_IMPL(push_slots_a, push_beat && !pop_beat |-> slots_next == slots - 1)
  `BR_ASSERT_IMPL(pop_slots_a, !push_beat && pop_beat |-> slots_next == slots + 1)
  `BR_ASSERT_IMPL(full_a, full == (slots == 0))

endmodule : br_fifo_push_ctrl_credit
