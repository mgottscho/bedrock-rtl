<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Verilog rules for Bazel.

<a id="rule_verilog_elab_test"></a>

## rule_verilog_elab_test

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "rule_verilog_elab_test")

rule_verilog_elab_test(<a href="#rule_verilog_elab_test-name">name</a>, <a href="#rule_verilog_elab_test-deps">deps</a>, <a href="#rule_verilog_elab_test-custom_tcl_body">custom_tcl_body</a>, <a href="#rule_verilog_elab_test-custom_tcl_header">custom_tcl_header</a>, <a href="#rule_verilog_elab_test-defines">defines</a>, <a href="#rule_verilog_elab_test-params">params</a>, <a href="#rule_verilog_elab_test-tool">tool</a>, <a href="#rule_verilog_elab_test-top">top</a>,
                       <a href="#rule_verilog_elab_test-verilog_runner_tool">verilog_runner_tool</a>)
</pre>

Tests that a Verilog or SystemVerilog design elaborates. Needs VERILOG_RUNNER_PLUGIN_PATH environment variable to be set correctly.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="rule_verilog_elab_test-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="rule_verilog_elab_test-deps"></a>deps |  The dependencies of the test.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="rule_verilog_elab_test-custom_tcl_body"></a>custom_tcl_body |  Tcl script file containing custom tool-specific commands to insert in the middle of the generated tcl script after the elaboration step.The tcl body (custom or not) is unconditionally followed by the tcl footer.Do not include Tcl commands that manipulate sources, headers, defines, or parameters, as those will be handled by the rule implementation.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_elab_test-custom_tcl_header"></a>custom_tcl_header |  Tcl script file containing custom tool-specific commands to insert at the beginning of the generated tcl script.The tcl header (custom or not) is unconditionally followed by analysis and elaborate commands, and then the tcl body.Do not include Tcl commands that manipulate sources, headers, defines, or parameters, as those will be handled by the rule implementation.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_elab_test-defines"></a>defines |  Preprocessor defines to pass to the Verilog compiler.   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_elab_test-params"></a>params |  Verilog module parameters to set in the instantiation of the top-level module.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="rule_verilog_elab_test-tool"></a>tool |  Elaboration tool to use. If not provided, default is decided by the Verilog Runner tool implementation with available plugins.   | String | optional |  `""`  |
| <a id="rule_verilog_elab_test-top"></a>top |  The top-level module; if not provided and there exists one dependency, then defaults to that dep's label name.   | String | optional |  `""`  |
| <a id="rule_verilog_elab_test-verilog_runner_tool"></a>verilog_runner_tool |  The Verilog Runner tool to use.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `"@bedrock-rtl//python/verilog_runner:verilog_runner.py"`  |


<a id="rule_verilog_fpv_sandbox"></a>

## rule_verilog_fpv_sandbox

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "rule_verilog_fpv_sandbox")

rule_verilog_fpv_sandbox(<a href="#rule_verilog_fpv_sandbox-name">name</a>, <a href="#rule_verilog_fpv_sandbox-deps">deps</a>, <a href="#rule_verilog_fpv_sandbox-analysis_opts">analysis_opts</a>, <a href="#rule_verilog_fpv_sandbox-custom_tcl_body">custom_tcl_body</a>, <a href="#rule_verilog_fpv_sandbox-custom_tcl_header">custom_tcl_header</a>, <a href="#rule_verilog_fpv_sandbox-defines">defines</a>,
                         <a href="#rule_verilog_fpv_sandbox-elab_only">elab_only</a>, <a href="#rule_verilog_fpv_sandbox-elab_opts">elab_opts</a>, <a href="#rule_verilog_fpv_sandbox-gui">gui</a>, <a href="#rule_verilog_fpv_sandbox-opts">opts</a>, <a href="#rule_verilog_fpv_sandbox-params">params</a>, <a href="#rule_verilog_fpv_sandbox-tool">tool</a>, <a href="#rule_verilog_fpv_sandbox-top">top</a>, <a href="#rule_verilog_fpv_sandbox-verilog_runner_tool">verilog_runner_tool</a>)
</pre>

Writes FPV files and run scripts into a tarball for independent execution outside of Bazel.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="rule_verilog_fpv_sandbox-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="rule_verilog_fpv_sandbox-deps"></a>deps |  The Verilog dependencies of the sandbox.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="rule_verilog_fpv_sandbox-analysis_opts"></a>analysis_opts |  custom analysis options   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_fpv_sandbox-custom_tcl_body"></a>custom_tcl_body |  Tcl script file containing custom tool-specific commands to insert in the middle of the generated tcl script after the elaboration step.The tcl body (custom or not) is unconditionally followed by the tcl footer.Do not include Tcl commands that manipulate sources, headers, defines, or parameters, as those will be handled by the rule implementation.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_fpv_sandbox-custom_tcl_header"></a>custom_tcl_header |  Tcl script file containing custom tool-specific commands to insert at the beginning of the generated tcl script.The tcl header (custom or not) is unconditionally followed by analysis and elaborate commands, and then the tcl body.Do not include Tcl commands that manipulate sources, headers, defines, or parameters, as those will be handled by the rule implementation.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_fpv_sandbox-defines"></a>defines |  Preprocessor defines to pass to the Verilog compiler.   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_fpv_sandbox-elab_only"></a>elab_only |  Only run elaboration.   | Boolean | optional |  `False`  |
| <a id="rule_verilog_fpv_sandbox-elab_opts"></a>elab_opts |  custom elab options   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_fpv_sandbox-gui"></a>gui |  Enable GUI.   | Boolean | optional |  `False`  |
| <a id="rule_verilog_fpv_sandbox-opts"></a>opts |  Tool-specific options not covered by other arguments. If provided, then 'tool' must also be set.   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_fpv_sandbox-params"></a>params |  Verilog module parameters to set in the instantiation of the top-level module.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="rule_verilog_fpv_sandbox-tool"></a>tool |  Tool to use. If not provided, default is decided by the Verilog Runner tool implementation with available plugins.   | String | optional |  `""`  |
| <a id="rule_verilog_fpv_sandbox-top"></a>top |  The top-level module; if not provided and there exists one dependency, then defaults to that dep's label name.   | String | optional |  `""`  |
| <a id="rule_verilog_fpv_sandbox-verilog_runner_tool"></a>verilog_runner_tool |  The Verilog Runner tool to use.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `"@bedrock-rtl//python/verilog_runner:verilog_runner.py"`  |


<a id="rule_verilog_fpv_test"></a>

## rule_verilog_fpv_test

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "rule_verilog_fpv_test")

rule_verilog_fpv_test(<a href="#rule_verilog_fpv_test-name">name</a>, <a href="#rule_verilog_fpv_test-deps">deps</a>, <a href="#rule_verilog_fpv_test-analysis_opts">analysis_opts</a>, <a href="#rule_verilog_fpv_test-custom_tcl_body">custom_tcl_body</a>, <a href="#rule_verilog_fpv_test-custom_tcl_header">custom_tcl_header</a>, <a href="#rule_verilog_fpv_test-defines">defines</a>,
                      <a href="#rule_verilog_fpv_test-elab_only">elab_only</a>, <a href="#rule_verilog_fpv_test-elab_opts">elab_opts</a>, <a href="#rule_verilog_fpv_test-gui">gui</a>, <a href="#rule_verilog_fpv_test-opts">opts</a>, <a href="#rule_verilog_fpv_test-params">params</a>, <a href="#rule_verilog_fpv_test-tool">tool</a>, <a href="#rule_verilog_fpv_test-top">top</a>, <a href="#rule_verilog_fpv_test-verilog_runner_tool">verilog_runner_tool</a>)
</pre>

Runs Verilog/SystemVerilog compilation and formal verification in one command. This rule should be used for simple formal unit tests. Needs VERILOG_RUNNER_PLUGIN_PATH environment variable to be set correctly.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="rule_verilog_fpv_test-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="rule_verilog_fpv_test-deps"></a>deps |  The dependencies of the test.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="rule_verilog_fpv_test-analysis_opts"></a>analysis_opts |  custom analysis options   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_fpv_test-custom_tcl_body"></a>custom_tcl_body |  Tcl script file containing custom tool-specific commands to insert in the middle of the generated tcl script after the elaboration step.The tcl body (custom or not) is unconditionally followed by the tcl footer.Do not include Tcl commands that manipulate sources, headers, defines, or parameters, as those will be handled by the rule implementation.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_fpv_test-custom_tcl_header"></a>custom_tcl_header |  Tcl script file containing custom tool-specific commands to insert at the beginning of the generated tcl script.The tcl header (custom or not) is unconditionally followed by analysis and elaborate commands, and then the tcl body.Do not include Tcl commands that manipulate sources, headers, defines, or parameters, as those will be handled by the rule implementation.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_fpv_test-defines"></a>defines |  Preprocessor defines to pass to the Verilog compiler.   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_fpv_test-elab_only"></a>elab_only |  Only run elaboration.   | Boolean | optional |  `False`  |
| <a id="rule_verilog_fpv_test-elab_opts"></a>elab_opts |  custom elab options   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_fpv_test-gui"></a>gui |  Enable GUI.   | Boolean | optional |  `False`  |
| <a id="rule_verilog_fpv_test-opts"></a>opts |  Tool-specific options not covered by other arguments. If provided, then 'tool' must also be set.   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_fpv_test-params"></a>params |  Verilog module parameters to set in the instantiation of the top-level module.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="rule_verilog_fpv_test-tool"></a>tool |  Formal tool to use. If not provided, default is decided by the Verilog Runner tool implementation with available plugins.   | String | optional |  `""`  |
| <a id="rule_verilog_fpv_test-top"></a>top |  The top-level module; if not provided and there exists one dependency, then defaults to that dep's label name.   | String | optional |  `""`  |
| <a id="rule_verilog_fpv_test-verilog_runner_tool"></a>verilog_runner_tool |  The Verilog Runner tool to use.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `"@bedrock-rtl//python/verilog_runner:verilog_runner.py"`  |


<a id="rule_verilog_lint_test"></a>

## rule_verilog_lint_test

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "rule_verilog_lint_test")

rule_verilog_lint_test(<a href="#rule_verilog_lint_test-name">name</a>, <a href="#rule_verilog_lint_test-deps">deps</a>, <a href="#rule_verilog_lint_test-custom_tcl_body">custom_tcl_body</a>, <a href="#rule_verilog_lint_test-custom_tcl_header">custom_tcl_header</a>, <a href="#rule_verilog_lint_test-defines">defines</a>, <a href="#rule_verilog_lint_test-params">params</a>, <a href="#rule_verilog_lint_test-policy">policy</a>,
                       <a href="#rule_verilog_lint_test-tool">tool</a>, <a href="#rule_verilog_lint_test-top">top</a>, <a href="#rule_verilog_lint_test-verilog_runner_tool">verilog_runner_tool</a>)
</pre>

Tests that a Verilog or SystemVerilog design passes a set of static lint checks. Needs VERILOG_RUNNER_PLUGIN_PATH environment variable to be set correctly.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="rule_verilog_lint_test-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="rule_verilog_lint_test-deps"></a>deps |  The dependencies of the test.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="rule_verilog_lint_test-custom_tcl_body"></a>custom_tcl_body |  Tcl script file containing custom tool-specific commands to insert in the middle of the generated tcl script after the elaboration step.The tcl body (custom or not) is unconditionally followed by the tcl footer.Do not include Tcl commands that manipulate sources, headers, defines, or parameters, as those will be handled by the rule implementation.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_lint_test-custom_tcl_header"></a>custom_tcl_header |  Tcl script file containing custom tool-specific commands to insert at the beginning of the generated tcl script.The tcl header (custom or not) is unconditionally followed by analysis and elaborate commands, and then the tcl body.Do not include Tcl commands that manipulate sources, headers, defines, or parameters, as those will be handled by the rule implementation.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_lint_test-defines"></a>defines |  Preprocessor defines to pass to the Verilog compiler.   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_lint_test-params"></a>params |  Verilog module parameters to set in the instantiation of the top-level module.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="rule_verilog_lint_test-policy"></a>policy |  The lint policy file to use. If not provided, then the default tool policy is used (typically provided through an environment variable).   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_lint_test-tool"></a>tool |  Lint tool to use. If not provided, default is decided by the Verilog Runner tool implementation with available plugins.   | String | optional |  `""`  |
| <a id="rule_verilog_lint_test-top"></a>top |  The top-level module; if not provided and there exists one dependency, then defaults to that dep's label name.   | String | optional |  `""`  |
| <a id="rule_verilog_lint_test-verilog_runner_tool"></a>verilog_runner_tool |  The Verilog Runner tool to use.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `"@bedrock-rtl//python/verilog_runner:verilog_runner.py"`  |


<a id="rule_verilog_sim_test"></a>

## rule_verilog_sim_test

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "rule_verilog_sim_test")

rule_verilog_sim_test(<a href="#rule_verilog_sim_test-name">name</a>, <a href="#rule_verilog_sim_test-deps">deps</a>, <a href="#rule_verilog_sim_test-custom_tcl_body">custom_tcl_body</a>, <a href="#rule_verilog_sim_test-custom_tcl_header">custom_tcl_header</a>, <a href="#rule_verilog_sim_test-defines">defines</a>, <a href="#rule_verilog_sim_test-elab_only">elab_only</a>, <a href="#rule_verilog_sim_test-opts">opts</a>,
                      <a href="#rule_verilog_sim_test-params">params</a>, <a href="#rule_verilog_sim_test-seed">seed</a>, <a href="#rule_verilog_sim_test-tool">tool</a>, <a href="#rule_verilog_sim_test-top">top</a>, <a href="#rule_verilog_sim_test-uvm">uvm</a>, <a href="#rule_verilog_sim_test-verilog_runner_tool">verilog_runner_tool</a>, <a href="#rule_verilog_sim_test-waves">waves</a>)
</pre>

Runs Verilog/SystemVerilog compilation and simulation in one command. This rule should be used for simple unit tests that do not require multi-step compilation, elaboration, and simulation. Needs VERILOG_RUNNER_PLUGIN_PATH environment variable to be set correctly.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="rule_verilog_sim_test-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="rule_verilog_sim_test-deps"></a>deps |  The dependencies of the test.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="rule_verilog_sim_test-custom_tcl_body"></a>custom_tcl_body |  Tcl script file containing custom tool-specific commands to insert in the middle of the generated tcl script after the elaboration step.The tcl body (custom or not) is unconditionally followed by the tcl footer.Do not include Tcl commands that manipulate sources, headers, defines, or parameters, as those will be handled by the rule implementation.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_sim_test-custom_tcl_header"></a>custom_tcl_header |  Tcl script file containing custom tool-specific commands to insert at the beginning of the generated tcl script.The tcl header (custom or not) is unconditionally followed by analysis and elaborate commands, and then the tcl body.Do not include Tcl commands that manipulate sources, headers, defines, or parameters, as those will be handled by the rule implementation.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="rule_verilog_sim_test-defines"></a>defines |  Preprocessor defines to pass to the Verilog compiler.   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_sim_test-elab_only"></a>elab_only |  Only run elaboration.   | Boolean | optional |  `False`  |
| <a id="rule_verilog_sim_test-opts"></a>opts |  Tool-specific options not covered by other arguments. If provided, then 'tool' must also be set.   | List of strings | optional |  `[]`  |
| <a id="rule_verilog_sim_test-params"></a>params |  Verilog module parameters to set in the instantiation of the top-level module.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="rule_verilog_sim_test-seed"></a>seed |  Random seed to use in simulation.   | Integer | optional |  `0`  |
| <a id="rule_verilog_sim_test-tool"></a>tool |  Simulator tool to use. If not provided, default is decided by the Verilog Runner tool implementation with available plugins.   | String | optional |  `""`  |
| <a id="rule_verilog_sim_test-top"></a>top |  The top-level module; if not provided and there exists one dependency, then defaults to that dep's label name.   | String | optional |  `""`  |
| <a id="rule_verilog_sim_test-uvm"></a>uvm |  Run UVM test.   | Boolean | optional |  `False`  |
| <a id="rule_verilog_sim_test-verilog_runner_tool"></a>verilog_runner_tool |  The Verilog Runner tool to use.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `"@bedrock-rtl//python/verilog_runner:verilog_runner.py"`  |
| <a id="rule_verilog_sim_test-waves"></a>waves |  Enable waveform dumping.   | Boolean | optional |  `False`  |


<a id="get_transitive"></a>

## get_transitive

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "get_transitive")

get_transitive(<a href="#get_transitive-ctx">ctx</a>, <a href="#get_transitive-srcs_not_hdrs">srcs_not_hdrs</a>)
</pre>

Returns a depset of all Verilog source or header files in the transitive closure of the deps attribute.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="get_transitive-ctx"></a>ctx |  <p align="center"> - </p>   |  none |
| <a id="get_transitive-srcs_not_hdrs"></a>srcs_not_hdrs |  <p align="center"> - </p>   |  none |


<a id="verilog_elab_and_lint_test_suite"></a>

## verilog_elab_and_lint_test_suite

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "verilog_elab_and_lint_test_suite")

verilog_elab_and_lint_test_suite(<a href="#verilog_elab_and_lint_test_suite-name">name</a>, <a href="#verilog_elab_and_lint_test_suite-defines">defines</a>, <a href="#verilog_elab_and_lint_test_suite-params">params</a>, <a href="#verilog_elab_and_lint_test_suite-kwargs">kwargs</a>)
</pre>

Creates a suite of Verilog elaboration and lint tests for each combination of the provided parameters.

The function generates all possible combinations of the provided parameters and creates a verilog_elab_test
and a verilog_lint_test for each combination. The test names are generated by appending "_elab_test" and "_lint_test"
to the base name followed by the parameter key-values.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="verilog_elab_and_lint_test_suite-name"></a>name |  The base name for the test suite.   |  none |
| <a id="verilog_elab_and_lint_test_suite-defines"></a>defines |  A list of defines.   |  `[]` |
| <a id="verilog_elab_and_lint_test_suite-params"></a>params |  A dictionary where keys are parameter names and values are lists of possible values for those parameters.   |  `{}` |
| <a id="verilog_elab_and_lint_test_suite-kwargs"></a>kwargs |  Additional common keyword arguments to be passed to the verilog_elab_test and verilog_lint_test functions.   |  none |


<a id="verilog_elab_test"></a>

## verilog_elab_test

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "verilog_elab_test")

verilog_elab_test(<a href="#verilog_elab_test-tags">tags</a>, <a href="#verilog_elab_test-kwargs">kwargs</a>)
</pre>

Wraps rule_verilog_elab_test with extra tags.

* no-sandbox -- Loosens some Bazel hermeticity features so that undeclared EDA tool test outputs are preserved for debugging.
* resources:verilog_elab_test_tool_licenses:1 -- indicates that the test requires a elaboration tool license.
* elab -- useful for test filtering, e.g., bazel test //... --test_tag_filters=elab

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="verilog_elab_test-tags"></a>tags |  <p align="center"> - </p>   |  `[]` |
| <a id="verilog_elab_test-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a id="verilog_fpv_test"></a>

## verilog_fpv_test

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "verilog_fpv_test")

verilog_fpv_test(<a href="#verilog_fpv_test-tags">tags</a>, <a href="#verilog_fpv_test-kwargs">kwargs</a>)
</pre>

Wraps rule_verilog_fpv_test with extra tags.

* no-sandbox -- Loosens some Bazel hermeticity features so that undeclared EDA tool test outputs are preserved for debugging.
* resources:verilog_fpv_test_tool_licenses:1 -- indicates that the test requires a formal tool license.
* fpv -- useful for test filtering, e.g., bazel test //... --test_tag_filters=fpv

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="verilog_fpv_test-tags"></a>tags |  <p align="center"> - </p>   |  `[]` |
| <a id="verilog_fpv_test-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a id="verilog_fpv_test_suite"></a>

## verilog_fpv_test_suite

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "verilog_fpv_test_suite")

verilog_fpv_test_suite(<a href="#verilog_fpv_test_suite-name">name</a>, <a href="#verilog_fpv_test_suite-defines">defines</a>, <a href="#verilog_fpv_test_suite-params">params</a>, <a href="#verilog_fpv_test_suite-sandbox">sandbox</a>, <a href="#verilog_fpv_test_suite-kwargs">kwargs</a>)
</pre>

Creates a suite of Verilog fpv tests for each combination of the provided parameters.

The function generates all possible combinations of the provided parameters and creates a verilog_fpv_test
for each combination. The test names are generated by appending "_fpv_test"
to the base name followed by the parameter key-values.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="verilog_fpv_test_suite-name"></a>name |  The base name for the test suite.   |  none |
| <a id="verilog_fpv_test_suite-defines"></a>defines |  A list of defines.   |  `[]` |
| <a id="verilog_fpv_test_suite-params"></a>params |  A dictionary where keys are parameter names and values are lists of possible values for those parameters.   |  `{}` |
| <a id="verilog_fpv_test_suite-sandbox"></a>sandbox |  Whether to create a sandbox for the test.   |  `True` |
| <a id="verilog_fpv_test_suite-kwargs"></a>kwargs |  Additional keyword arguments to be passed to the verilog_elab_test and verilog_lint_test functions.   |  none |


<a id="verilog_lint_test"></a>

## verilog_lint_test

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "verilog_lint_test")

verilog_lint_test(<a href="#verilog_lint_test-tags">tags</a>, <a href="#verilog_lint_test-kwargs">kwargs</a>)
</pre>

Wraps rule_verilog_lint_test with extra tags.

* no-sandbox -- Loosens some Bazel hermeticity features so that undeclared EDA tool test outputs are preserved for debugging.
* resources:verilog_lint_test_tool_licenses:1 -- indicates that the test requires a lint tool license.
* lint -- useful for test filtering, e.g., bazel test //... --test_tag_filters=lint

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="verilog_lint_test-tags"></a>tags |  <p align="center"> - </p>   |  `[]` |
| <a id="verilog_lint_test-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a id="verilog_sim_test"></a>

## verilog_sim_test

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "verilog_sim_test")

verilog_sim_test(<a href="#verilog_sim_test-tags">tags</a>, <a href="#verilog_sim_test-kwargs">kwargs</a>)
</pre>

Wraps rule_verilog_sim_test with extra tags.

* no-sandbox -- Loosens some Bazel hermeticity features so that undeclared EDA tool test outputs are preserved for debugging.
* resources:verilog_sim_test_tool_licenses:1 -- indicates that the test requires a simulation tool license.
* sim -- useful for test filtering, e.g., bazel test //... --test_tag_filters=sim

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="verilog_sim_test-tags"></a>tags |  <p align="center"> - </p>   |  `[]` |
| <a id="verilog_sim_test-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a id="verilog_sim_test_suite"></a>

## verilog_sim_test_suite

<pre>
load("@bedrock-rtl//bazel:verilog.bzl", "verilog_sim_test_suite")

verilog_sim_test_suite(<a href="#verilog_sim_test_suite-name">name</a>, <a href="#verilog_sim_test_suite-defines">defines</a>, <a href="#verilog_sim_test_suite-params">params</a>, <a href="#verilog_sim_test_suite-kwargs">kwargs</a>)
</pre>

Creates a suite of Verilog sim tests for each combination of the provided parameters.

The function generates all possible combinations of the provided parameters and creates a verilog_sim_test
for each combination. The test names are generated by appending "_sim_test"
to the base name followed by the parameter key-values.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="verilog_sim_test_suite-name"></a>name |  The base name for the test suite.   |  none |
| <a id="verilog_sim_test_suite-defines"></a>defines |  A list of defines.   |  `[]` |
| <a id="verilog_sim_test_suite-params"></a>params |  A dictionary where keys are parameter names and values are lists of possible values for those parameters.   |  `{}` |
| <a id="verilog_sim_test_suite-kwargs"></a>kwargs |  Additional keyword arguments to be passed to the verilog_elab_test and verilog_lint_test functions.   |  none |


