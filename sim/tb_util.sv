/*******************************************************************************
* Testbench Utilities
*******************************************************************************/
package tb_util;

//------------------------------------------------------------------------------
// Reporting
//------------------------------------------------------------------------------

localparam STR_PASS  = " [PASS]";
localparam STR_FAIL  = "![FAIL]";
localparam STR_INFO  = " [INFO]";
localparam STR_ERROR = "![ ERR]";
localparam STR_DIV   = " [----]";
localparam STR_NONE  = " [    ]";

function automatic tb_new_section (
    input string section_name
);
    $display("\n%s%s", STR_DIV, section_name);
endfunction

//------------------------------------------------------------------------------
// GTest Macros
//------------------------------------------------------------------------------

task automatic EXPECT_TRUE(
    input integer value,
    input string comment
);

    if(value > 0)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s", STR_FAIL, comment);

endtask

task automatic EXPECT_FALSE(
    input integer value,
    input string comment
);

    if(!(value > 0))
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s", STR_FAIL, comment);

endtask

task automatic EXPECT_EQ(
    input integer actual,
    input integer expected,
    input string comment
);

    if(expected == actual)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, actual);

endtask

task automatic EXPECT_NE(
    input integer actual,
    input integer expected,
    input string comment
);

    if(expected != actual)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, actual);

endtask

task automatic EXPECT_LE(
    input integer value,
    input integer limit,
    input string comment
);

    if(value <= limit)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, value);

endtask

task automatic EXPECT_LT(
    input integer value,
    input integer limit,
    input string comment
);

    if(value < limit)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, value);

endtask

task automatic EXPECT_GE(
    input integer value,
    input integer limit,
    input string comment
);

    if(value >= limit)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, value);

endtask

task automatic EXPECT_GT(
    input integer value,
    input integer limit,
    input string comment
);

    if(value < limit)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, value);

endtask

endpackage
