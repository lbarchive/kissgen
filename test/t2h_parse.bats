#!/usr/bin/env bats
_TF='t2h_parse'     # tested function
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
    source "$T2H"
}


#############
# arguments #
#############


@test "$_TF text html  # default settings" {
    eval "$BATS_TEST_DESCRIPTION"
    eqs "$T2H_TEXT_FILE" 'text'
    eqs "$T2H_HTML_FILE" 'html'
}


@test "$_TF text  # missing html" {
    run $BATS_TEST_DESCRIPTION
    eqn "$status" 1
    echo_lines
    [[ "${lines[*]}" == Usage* ]]
}


@test "$_TF  # missing text and html" {
    run $BATS_TEST_DESCRIPTION
    echo_lines
    [[ "${lines[*]}" == Usage* ]]
}


###########
# options #
###########


@test "$_TF -c /path/to/foobar.sh text html" {
    eval "$BATS_TEST_DESCRIPTION"
    eqs "$T2H_OPT_CONF" "/path/to/foobar.sh" 
}
