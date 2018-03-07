#!/usr/bin/env bats
_TF='gen_parse'     # tested function
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
    source "$GEN"
    _init_tf_tmpdir
}


teardown()
{
    _deinit_tf_tmpdir
}


#############
# arguments #
#############


@test "$_TF text.dir html.dir  # default settings" {
    eval "$BATS_TEST_DESCRIPTION"
    eqs "$GEN_TEXT_DIR" 'text.dir'
    eqs "$GEN_HTML_DIR" 'html.dir'
    eqs "${GEN_T2H_CMD[*]}" 't2h'
}


@test "$_TF text.dir  # missing html.dir" {
    eval "run $BATS_TEST_DESCRIPTION"
    eqn "$status" 1
    echo_lines
    [[ "${lines[*]}" == Usage* ]]
}


@test "$_TF  # missing text.dir and html.dir" {
    eval "run $BATS_TEST_DESCRIPTION"
    eqn "$status" 1
    echo_lines
    [[ "${lines[*]}" == Usage* ]]
}


#################
# configuration #
#################


@test "$_TF -t /BASE/non-existing.sh text.dir html.dir" {
    local t2hsh="$_TF_TMPDIR/non-existing.sh"
    eval "${BATS_TEST_DESCRIPTION/\/BASE/$_TF_TMPDIR}"

    eqs "$GEN_TEXT_DIR" 'text.dir'
    eqs "$GEN_HTML_DIR" 'html.dir'
    eqs "$GEN_T2H_CONF" "$t2hsh"
    eqs "${GEN_T2H_CMD[*]}" 't2h'
}


@test "$_TF -t /BASE/existing.sh text.dir html.dir" {
    local t2hsh="$_TF_TMPDIR/existing.sh"
    touch "$t2hsh"

    eval "${BATS_TEST_DESCRIPTION/\/BASE/$_TF_TMPDIR}"
    eqs "$GEN_TEXT_DIR" 'text.dir'
    eqs "$GEN_HTML_DIR" 'html.dir'
    eqs "$GEN_T2H_CONF" "$t2hsh"
    eqs "${GEN_T2H_CMD[*]}" "t2h -c $t2hsh"
}
