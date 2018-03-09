#!/usr/bin/env bats
_TF=t2h     # test t2h script
# Copyright (c) 2018 Yu-Jie Lin
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


load helper


setup()
{
    _init_tf_tmpdir
}


teardown()
{
    _deinit_tf_tmpdir
}


#############
# arguments #
#############


@test "$_TF  # missing both text and html arguments" {
    run $BATS_TEST_DESCRIPTION

    eqn "$status" 1
}


@test "$_TF test.txt  # missing html argument" {
    run $BATS_TEST_DESCRIPTION

    eqn "$status" 1
}


@test "$_TF test.txt test.html" {
    local text="foobar"
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/test.html"
    echo "$text" > "$tf"

    run t2h "$tf" "$hf"

    eqn "$status" 0
    echo_ml "$(<"$hf")"
    grep "$text" "$hf"
}


# standard input/output
#######################


@test "$_TF <stdin> test.html" {
    local text="foobar"
    local hf="$_TF_TMPDIR/test.html"

    run t2h - "$hf" <<<"$text"

    eqn "$status" 0
    echo_ml "$(<"$hf")"
    grep "$text" "$hf"
}


@test "$_TF test.txt <stdout>" {
    local text="foobar"
    local tf="$_TF_TMPDIR/test.txt"
    echo "$text" > "$tf"

    run t2h "$tf" - <<<"$text"

    eqn "$status" 0
    echo_lines
    [[ "${lines[*]}" == *"$text"* ]]
}


@test "$_TF <stdin> <stdout>" {
    local text="foobar"

    run t2h - - <<<"$text"

    eqn "$status" 0
    echo_lines
    [[ "${lines[*]}" == *"$text"* ]]
}
