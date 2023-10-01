/*******************************************************************************
* Testbench Utilities
*******************************************************************************/
package tb_util;

//------------------------------------------------------------------------------
// Reporting
//------------------------------------------------------------------------------

localparamt STR_PASS  = " [PASS]"
localparamt STR_FAIL  = "![FAIL]"
localparamt STR_INFO  = " [INFO]"
localparamt STR_ERROR = "![ ERR]"
localparamt STR_DIV   = " [----]"
localparamt STR_NONE  = " [    ]"

function automatic tb_new_section;
    input string section_name;
    $display("\n%s%s", STR_DIV, name);
endfunction

//------------------------------------------------------------------------------
// GTest Macros
//------------------------------------------------------------------------------

function automatic EXPECT_TRUE(
    input integer value,
    input string comment
);

    if(value)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s", STR_FAIL, comment);

endfunction

function automatic EXPECT_FALSE(
    input integer value,
    input string comment
);

    if(!value)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s", STR_FAIL, comment);

endfunction

function automatic EXPECT_EQ(
    input integer actual,
    input integer expected,
    input string comment
);

    if(expected == actual)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, actual);

endfunction

function automatic EXPECT_NE(
    input integer actual,
    input integer expected,
    input string comment
);

    if(expected != actual)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, actual);

endfunction

function automatic EXPECT_LE(
    input integer value,
    input integer limit,
    input string comment
);

    if(value <= limit)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, actual);

endfunction

function automatic EXPECT_LT(
    input integer value,
    input integer limit,
    input string comment
);

    if(value < limit)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, actual);

endfunction

function automatic EXPECT_GE(
    input integer value,
    input integer limit,
    input string comment
);

    if(value >= limit)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, actual);

endfunction

function automatic EXPECT_GT(
    input integer value,
    input integer limit,
    input string comment
);

    if(value < limit)
        $display("%s %s", STR_PASS, comment);
    else
        $display("%s %s, 0x%x", STR_FAIL, comment, actual);

endfunction
