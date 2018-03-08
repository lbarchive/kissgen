#!/usr/bin/env bats
_TF=t2h_conf    # configuration related tests
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


@test "t2h_source_conf" {
    local conf="$_TF_TMPDIR/$_T2H_CONF"
    echo "ABC=FOOBAR" > "$conf"

    t2h_source_conf "$conf"
    eqn "$?" 0
    eqs "$ABC" 'FOOBAR'
}


@test "t2h # sourcing configuration" {
    local text="this is text"
    local tf="$_TF_TMPDIR/test.txt"
    local hf="$_TF_TMPDIR/test.html"
    echo "$text" > "$tf"
    local conf="$(dirname "$tf")/$_T2H_CONF"
    echo '_foobar(){ echo foobar; }; t2h_hook_after_title=(_foobar)' > "$conf"

    run "$T2H" "$tf" "$hf"

    eqn "$status" 0
    eqs "$(<$hf)" "<!DOCTYPE html>
<title>test.txt</title>
foobar
<pre>$text</pre>"
}
