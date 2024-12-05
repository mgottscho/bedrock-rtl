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

// Bedrock-RTL Flow-Controlled Arbiter Core
//
// This module is intended to work with one of the br_arb_* modules
// to implement a flow-controlled arbiter. Given two or more sets of
// ready-valid signals, it will arbitrate between them, granting one
// request per cycle if pop_ready is true.

`include "br_asserts_internal.svh"
`include "br_unused.svh"

module br_flow_arb_core #(
    // Must be at least 2
    parameter int NumFlows = 2
) (
    // ri lint_check_waive HIER_NET_NOT_READ HIER_BRANCH_NOT_READ INPUT_NOT_READ
    input logic clk,  // Only used for assertions
    // ri lint_check_waive HIER_NET_NOT_READ HIER_BRANCH_NOT_READ INPUT_NOT_READ
    input logic rst,  // Only used for assertions
    // Interface to base arbiter
    output logic [NumFlows-1:0] request,
    input logic [NumFlows-1:0] can_grant,
    input logic [NumFlows-1:0] grant,
    output logic enable_priority_update,
    // External-facing signals
    output logic [NumFlows-1:0] push_ready,
    input logic [NumFlows-1:0] push_valid,
    input logic pop_ready,
    output logic pop_valid
);

  //------------------------------------------
  // Integration checks
  //------------------------------------------

  // TODO(mgottscho): Add checks
  `BR_COVER_INTG(push_backpressure_a, |push_valid && !pop_ready)

  // Internal integration checks
  `BR_ASSERT_IMPL(request_implies_grant_a, |request |-> |grant)
  `BR_ASSERT_IMPL(grant_onehot0_a, $onehot0(grant))
  `BR_ASSERT_IMPL(grant_is_request_and_can_grant_a, grant == (request & can_grant))

  //------------------------------------------
  // Implementation
  //------------------------------------------

  assign request = push_valid;
  // only allow priority update if we actually grant
  assign enable_priority_update = pop_ready;
  assign push_ready = {NumFlows{pop_ready}} & can_grant;
  assign pop_valid = |push_valid;

  // grant is only used for assertions
  `BR_UNUSED(grant)

  //------------------------------------------
  // Implementation checks
  //------------------------------------------

  `BR_ASSERT_IMPL(push_handshake_onehot0_a, $onehot0(push_valid & push_ready))
  `BR_ASSERT_IMPL(pop_ready_equals_push_ready_or_a, pop_ready == |push_ready)
  `BR_ASSERT_IMPL(push_handshake_implies_pop_handshake_a,
                  |(push_valid & push_ready) |-> (pop_valid & pop_ready))
  `BR_ASSERT_IMPL(grant_equals_push_ready_and_valid_a, grant == (push_ready & push_valid))

endmodule : br_flow_arb_core