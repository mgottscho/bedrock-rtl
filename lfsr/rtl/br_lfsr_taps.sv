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

// Bedrock-RTL LFSR Taps
//
// Taps for maximum-length Fibonacci LFSRs of given widths.

package br_lfsr_taps;
  localparam logic [1:0] TapsWidth2 = 2'h3;
  localparam logic [2:0] TapsWidth3 = 3'h6;
  localparam logic [3:0] TapsWidth4 = 4'hC;
  localparam logic [4:0] TapsWidth5 = 5'h14;
  localparam logic [5:0] TapsWidth6 = 6'h30;
  localparam logic [6:0] TapsWidth7 = 7'h60;
  localparam logic [7:0] TapsWidth8 = 8'hB8;
  localparam logic [8:0] TapsWidth9 = 9'h110;
  localparam logic [9:0] TapsWidth10 = 10'h240;
  localparam logic [10:0] TapsWidth11 = 11'h500;
  localparam logic [11:0] TapsWidth12 = 12'hE08;
  localparam logic [12:0] TapsWidth13 = 13'h1C80;
  localparam logic [13:0] TapsWidth14 = 14'h3802;
  localparam logic [14:0] TapsWidth15 = 15'h6000;
  localparam logic [15:0] TapsWidth16 = 16'hD008;
endpackage
