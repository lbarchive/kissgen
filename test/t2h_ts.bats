#!/usr/bin/env bats
_TF='t2h_ts'  # test timestamp related functions
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
    _init_tf_tmpdir
}


teardown()
{
    _deinit_tf_tmpdir
}


@test "t2h_get_ts and t2h_set_ts" {
    local testfile="$_TF_TMPDIR"/ts-test
    touch "$testfile"

    local ts="$(t2h_get_ts "$testfile")"
    local curts="$(date + %s)"

    # should be same as current system time, or at least within 1 second of
    # margin
    echo "ts    = $ts"
    echo "curts = $curts"
    ((curts - ts <= 1))

    local newts="$((ts - 13))"
    t2h_set_ts "$newts" "$testfile"
    ts="$(t2h_get_ts "$testfile")"
    eqn "$ts" "$newts"
}
