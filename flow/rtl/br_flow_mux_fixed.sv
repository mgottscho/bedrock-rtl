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

// Bedrock-RTL Flow-Controlled Multiplexer (Fixed-Priority)
//
// Combines fixed-priority arbitration with data path multiplexing.
// Grants a single request at a time with fixed (strict) priority
// where the lowest index flow has the highest priority.
// Uses ready-valid flow control for flows (push)
// and the grant (pop).
//
// Purely combinational (no delays).

`include "br_asserts.svh"

module br_flow_mux_fixed #(
    parameter int NumFlows = 2,  // Must be at least 2
    parameter int Width = 1  // Must be at least 1
) (
    // ri lint_check_waive NOT_READ HIER_NET_NOT_READ HIER_BRANCH_NOT_READ
    input  logic                           clk,         // Only used for assertions
    // ri lint_check_waive NOT_READ HIER_NET_NOT_READ HIER_BRANCH_NOT_READ
    input  logic                           rst,         // Only used for assertions
    output logic [NumFlows-1:0]            push_ready,
    input  logic [NumFlows-1:0]            push_valid,
    input  logic [NumFlows-1:0][Width-1:0] push_data,
    input  logic                           pop_ready,
    output logic                           pop_valid,
    output logic [   Width-1:0]            pop_data
);

  //------------------------------------------
  // Integration checks
  //------------------------------------------
  `BR_ASSERT_STATIC(num_requesters_gte_2_a, NumFlows >= 2)
  `BR_ASSERT_STATIC(datawidth_gte_1_a, Width >= 1)

  // Rely on submodule integration checks

  //------------------------------------------
  // Implementation
  //------------------------------------------
  logic [NumFlows-1:0] request;
  logic [NumFlows-1:0] can_grant;
  logic [NumFlows-1:0] grant;

  br_arb_fixed_internal #(
      .NumRequesters(NumFlows)
  ) br_arb_fixed_internal (
      .request,
      .can_grant,
      .grant
  );

  br_flow_mux_core #(
      .NumFlows(NumFlows),
      .Width(Width)
  ) br_flow_mux_core (
      .clk,
      .rst,
      .request,
      .can_grant,
      .grant,
      .enable_priority_update(),  // Not used
      .push_ready,
      .push_valid,
      .push_data,
      .pop_ready,
      .pop_valid,
      .pop_data
  );

  //------------------------------------------
  // Implementation checks
  //------------------------------------------
  // Rely on submodule implementation checks

endmodule : br_flow_mux_fixed
