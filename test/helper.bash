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


T2H="$(readlink -f "$BATS_TEST_DIRNAME/../bin/t2h")"


########
# echo #
########


echo_ml()
{
    echo '====='
    echo "$1"
    echo '====='
}


echo_lines()
{
    echo_ml "${lines[*]}"
}


###########
# asserts #
###########


# test strings $1 == $2
eqs ()
{
    echo "   '$1'"
    echo "!= '$2'"
    [[ "$1" == "$2" ]]
}


# test integers $1 == $2
eqn ()
{
    echo "$1 != $2"
    (($1 == $2))
}


##########
# tmpdir #
##########


# initializes tested function temporary directory, which will be
#
#   $BATS_TMPDIR/$_TF, if $_TF != ''; otherwise
#   $(mktemp --tmpdir=$BATS_TMPDIR --directory)
_init_tf_tmpdir()
{
    if [[ "$_TF" ]]; then
        _TF_TMPDIR="$BATS_TMPDIR/$_TF"
        mkdir -p "$_TF_TMPDIR"
    else
        _TF_TMPDIR="$(mktemp --tmpdir=$BATS_TMPDIR --directory)"
    fi
}


_deinit_tf_tmpdir()
{
    if [[ -d "$_TF_TMPDIR" ]]; then
        rm -rf "$_TF_TMPDIR"
    fi
}
