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

// Bedrock-RTL Credit Sender
//
// Manages the sender side of a credit-based flow control mechanism.
// Converts from ready/valid on the push interface to credit/valid on the pop interface.
//
// Push Interface:
//   - Accepts data to be sent (push_data) when push_valid is asserted.
//   - Indicates readiness to accept data via push_ready, which is high when there are available credits.
//
// Pop Interface:
//   - Credits are replenished when the receiver returns a credit (pop_credit asserted).
//   - Forwards data to the receiver via pop_data and asserts pop_valid when both push_valid and push_ready
//     are high.
//
// Credit Tracking (credit_count):
//   - Uses an internal credit counter to track the number of available credits.
//   - Initializes to initial_credit, allowing for adjustable initial credit values.
//
// Flow Control Mechanism:
//   - Decrements the credit count when a flit (data packet) is sent (pop_valid asserted).
//   - Increments the credit count when a credit is received from the receiver (pop_credit asserted).
//   - Data is only sent when there are available credits or a credit is being replenished the
//     same cycle.
//
// Latency:
//   - There are no registers on the datapath between the push and pop interfaces.
//   - There is a cut-through latency of 0 cycles from push to pop.
//   - There is a backpressure latency of 0 cycles from pop to push.
//   - Credits can be spent the same cycle that they are replenished.
//   - Users will likely want to register the push-side interface (e.g., with br_flow_reg_*)
//     and/or the pop-side interface (e.g., with br_delay_valid) to help close timing.
//
// Reset:
//   - If either this sender or the receiver resets, then the other side must also reset
//     to ensure they collectively have a coherent view of the total credits and an empty receiver
//     buffer.
//     - If there is no reset skew between sender and receiver, the pop_sender_in_reset and
//       pop_receiver_in_reset ports can be tied off to 0/left unused.
//     - If there is reset skew between sender and receiver, or if they are in different reset domains,
//       then the pop_sender_in_reset and pop_receiver_in_reset signals should be connected accordingly
//       between sender and receiver.
//     - Note that this is *NOT* a general-purpose substitute for a higher-level reset protocol and
//       architectural reset domain crossing (RDC). All it does is make sure the sender and receiver
//       can be reset with skew or completely independently without causing a permanent loss of credits and
//       broken flow control.
//   - When in reset (the rst port and/or the pop_receiver_in_reset port is high), this module:
//     - Does not send output flits on the pop interface.
//     - Ignores (drops) any incoming pop credits.
//     - Loads the initial value for the credit counter from the credit_initial port.
//     - Sets push_ready to 0.

`include "br_asserts_internal.svh"
`include "br_registers.svh"

module br_credit_sender #(
    // Width of the datapath in bits. Must be at least 1.
    parameter int Width = 1,
    // Maximum number of credits that can be stored (inclusive). Must be at least 1.
    parameter int MaxCredit = 1,
    // If 1, add 1 cycle of retiming to pop outputs.
    parameter bit RegisterPopOutputs = 0,
    // If 1, cover that the push side experiences backpressure.
    // If 0, assert that there is never backpressure.
    parameter bit EnableCoverPushBackpressure = 1,
    // If 1, assert that push_valid is stable when backpressured.
    // If 0, cover that push_valid can be unstable.
    parameter bit EnableAssertPushValidStability = EnableCoverPushBackpressure,
    // If 1, assert that push_data is stable when backpressured.
    // If 0, cover that push_data can be unstable.
    parameter bit EnableAssertPushDataStability = EnableAssertPushValidStability,
    // If 1, then assert there are no valid bits asserted at the end of the test.
    parameter bit EnableAssertFinalNotValid = 1,
    localparam int CounterWidth = $clog2(MaxCredit + 1)
) (
    // Posedge-triggered clock.
    input logic clk,
    // Synchronous active-high reset.
    input logic rst,

    // Ready/valid push interface.
    output logic push_ready,
    input logic push_valid,
    input logic [Width-1:0] push_data,

    // Credit/valid pop interface.
    // Indicates that this module is in reset.
    // Synchronous active-high.
    output logic pop_sender_in_reset,
    // Indicates that the receiver is in reset.
    // Synchronous active-high.
    input logic pop_receiver_in_reset,
    input logic pop_credit,
    output logic pop_valid,
    output logic [Width-1:0] pop_data,

    // Reset value for the credit counter
    input  logic [CounterWidth-1:0] credit_initial,
    // Dynamically withhold credits from circulation
    input  logic [CounterWidth-1:0] credit_withhold,
    // Credit counter state before increment/decrement/withhold.
    output logic [CounterWidth-1:0] credit_count,
    // Dynamic amount of available credit.
    output logic [CounterWidth-1:0] credit_available
);

  //------------------------------------------
  // Integration checks
  //------------------------------------------
  `BR_ASSERT_STATIC(width_in_range_a, Width >= 1)
  `BR_ASSERT_STATIC(max_credit_in_range_a, MaxCredit >= 1)

  br_flow_checks_valid_data_intg #(
      .NumFlows(1),
      .Width(Width),
      .EnableCoverBackpressure(EnableCoverPushBackpressure),
      .EnableAssertValidStability(EnableAssertPushValidStability),
      .EnableAssertDataStability(EnableAssertPushDataStability),
      .EnableAssertFinalNotValid(EnableAssertFinalNotValid)
  ) br_flow_checks_valid_data_intg (
      .clk,
      .rst,
      .ready(push_ready),
      .valid(push_valid),
      .data (push_data)
  );

  // Rely on submodule integration checks

  //------------------------------------------
  // Implementation
  //------------------------------------------
  logic either_rst;
  assign either_rst = rst || pop_receiver_in_reset;

  logic internal_push_ready;

  // Credit counter
  br_credit_counter #(
      .MaxValue(MaxCredit),
      .MaxChange(1),
      .EnableAssertFinalNotValid(EnableAssertFinalNotValid)
  ) br_credit_counter (
      .clk,
      .rst(either_rst),
      .incr_valid(pop_credit),
      .incr(1'b1),
      .decr_ready(internal_push_ready),
      .decr_valid(push_valid),
      .decr(1'b1),
      .initial_value(credit_initial),
      .withhold(credit_withhold),
      .value(credit_count),
      .available(credit_available)
  );

  logic internal_pop_valid;

  assign push_ready = internal_push_ready && !either_rst;
  assign internal_pop_valid = push_ready && push_valid;

  if (RegisterPopOutputs) begin : gen_reg_pop
    `BR_REGI(pop_sender_in_reset, 1'b0, 1'b1)
    `BR_REG(pop_valid, internal_pop_valid)
    `BR_REGL(pop_data, push_data, internal_pop_valid)
  end else begin : gen_passthru_pop
    assign pop_sender_in_reset = rst;
    assign pop_valid = internal_pop_valid;
    assign pop_data = push_data;
  end

  //------------------------------------------
  // Implementation checks
  //------------------------------------------
  `BR_ASSERT_IMPL(pop_follows_push_a,
                  (push_valid && push_ready) |-> ##(RegisterPopOutputs) pop_valid)
  `BR_ASSERT_IMPL(pop_with_zero_credits_a,
                  credit_count == '0 && internal_pop_valid |-> pop_credit && push_valid)
  `BR_ASSERT_IMPL(push_pop_unchanged_credit_count_a,
                  internal_pop_valid && pop_credit |=> credit_count == $past(credit_count))
  `BR_ASSERT_IMPL(withhold_and_spend_a,
                  credit_count == credit_withhold && internal_pop_valid |-> pop_credit)
  `BR_COVER_IMPL(pop_valid_and_pop_credit_c, pop_valid && pop_credit)

  // Reset
  `BR_ASSERT_INCL_RST_IMPL(push_ready_0_in_reset_a, rst |-> !push_ready)
  `BR_ASSERT_IMPL(pop_receiver_in_reset_no_push_ready_a, pop_receiver_in_reset |-> !push_ready)
  if (RegisterPopOutputs) begin : gen_assert_pop_reg
    `BR_ASSERT_INCL_RST_IMPL(pop_sender_in_reset_a, rst |=> pop_sender_in_reset)
    `BR_ASSERT_INCL_RST_IMPL(pop_valid_0_in_reset_a, rst |=> !pop_valid)
    `BR_ASSERT_IMPL(pop_receiver_in_reset_no_pop_valid_a, pop_receiver_in_reset |=> !pop_valid)
  end else begin : gen_assert_pop_no_reg
    `BR_ASSERT_INCL_RST_IMPL(pop_sender_in_reset_a, rst |-> pop_sender_in_reset)
    `BR_ASSERT_INCL_RST_IMPL(pop_valid_0_in_reset_a, rst |-> !pop_valid)
    `BR_ASSERT_IMPL(pop_receiver_in_reset_no_pop_valid_a, pop_receiver_in_reset |-> !pop_valid)
  end

  // Rely on submodule implementation checks

endmodule : br_credit_sender
