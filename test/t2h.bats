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


@test "$T2H  # missing both text and html arguments" {
    run $BATS_TEST_DESCRIPTION

    eqn "$status" 1
}


@test "$T2H test.txt  # missing html argument" {
    run $BATS_TEST_DESCRIPTION

    eqn "$status" 1
}


@test "$_TF test.txt test.html" {
    local text="foobar"
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/test.html"
    echo "$text" > "$tf"

    run "$T2H" "$tf" "$hf"

    eqn "$status" 0
    echo_ml "$(<"$hf")"
    grep "$text" "$hf"
}


@test "$_TF test.html  # text does not exist" {
    local text="foobar"
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/test.html"

    run "$T2H" "$tf" "$hf"

    eqn "$status" 1
    echo_lines
    [[ "${lines[0]}" == "$tf is not readable!" ]]
}


@test "$_TF test.txt html.dir/test.html  # html.dir yet to create" {
    local text="foobar"
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/html.dir/test.html"
    echo "$text" > "$tf"

    run "$T2H" "$tf" "$hf"
    eqn "$status" 0
    echo_lines
    [[ "${lines[0]}" == *mkdir* ]]
    grep "$text" "$hf"
}


# standard input/output
#######################


@test "$_TF <stdin> test.html" {
    local text="foobar"
    local hf="$_TF_TMPDIR/test.html"

    run "$T2H" - "$hf" <<<"$text"

    eqn "$status" 0
    echo_ml "$(<"$hf")"
    grep "$text" "$hf"
}


@test "$_TF test.txt <stdout>" {
    local text="foobar"
    local tf="$_TF_TMPDIR/test.txt"
    echo "$text" > "$tf"

    run "$T2H" "$tf" - <<<"$text"

    eqn "$status" 0
    echo_lines
    [[ "${lines[*]}" == *"$text"* ]]
}


@test "$_TF <stdin> <stdout>" {
    local text="foobar"

    run "$T2H" - - <<<"$text"

    eqn "$status" 0
    echo_lines
    [[ "${lines[*]}" == *"$text"* ]]
}


##############
# timestamps #
##############


@test "$_TF: timestamp" {
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/test.html"

    touch "$tf"

    run "$T2H" "$tf" "$hf"

    eqn "$status" 0
    eqs "${lines[*]}" ''

    run "$T2H" "$tf" "$hf"

    eqn "$status" 0
    echo_lines
    [[ "${lines[*]}" == *SKIP* ]]

    local tst="$(stat -c %Y "$tf")"
    local tsh="$(stat -c %Y "$hf")"
    eqn "$tst" "$tsh"
}


@test "$_TF: same timestamp" {
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/test.html"

    touch -d 0 "$tf" "$hf"

    run "$T2H" "$tf" "$hf"

    eqn "$status" 0
    [[ "${lines[*]}" == *SKIP* ]]

    local tst="$(stat -c %Y "$tf")"
    local tsh="$(stat -c %Y "$hf")"
    eqn "$tst" "$tsh"
}


@test "$_TF: different timestamp" {
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/test.html"

    touch -d 0 "$tf"
    touch -d 7 "$hf"

    run "$T2H" "$tf" "$hf"

    eqn "$status" 0
    eqs "${lines[*]}" ''

    local tst="$(stat -c %Y "$tf")"
    local tsh="$(stat -c %Y "$hf")"
    eqn "$tst" "$tsh"
}


##############
# T2H_NOCOPY #
##############


@test "$_TF test.txt output/test.html  # copy text" {
    local text="foobar"
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/output/test.html"
    echo "$text" > "$tf"

    run "$T2H" "$tf" "$hf"

    eqn "$status" 0
    diff "$tf" "${hf%.html}.txt"
}


@test "$_TF - output/test.html  # copy text / stdin" {
    local text="foobar"
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/output/test.html"
    echo "$text" > "$tf"

    run "$T2H" "$tf" "$hf"

    eqn "$status" 0
    diff <(echo "$text") "${hf%.html}.txt"
}


@test "$_TF -C test.txt output/test.html  # no copy" {
    local text="foobar"
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/output/test.html"
    echo "$text" > "$tf"

    run "$T2H" -C "$tf" "$hf"

    eqn "$status" 0
    [[ ! -f "${hf%.html}.txt" ]]
}
