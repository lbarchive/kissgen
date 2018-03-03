#!/usr/bin/env bats
_TF='t2h_html_encode'   # tested function
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


@test "$_TF: &" {
    run "$_TF" <<< "&"

    eqn "$status" 0
    eqs "${lines[0]}" '&amp;'
}


@test "$_TF: &amp;" {
    run "$_TF" <<< "&amp;"

    eqn "$status" 0
    eqs "${lines[0]}" '&amp;amp;'
}


@test "$_TF: <" {
    run "$_TF" <<< "<"

    eqn "$status" 0
    eqs "${lines[0]}" '&lt;'
}


@test "$_TF: >" {
    run "$_TF" <<< ">"

    eqn "$status" 0
    eqs "${lines[0]}" '&gt;'
}


@test "$_TF: <a>" {
    run "$_TF" <<< "<a>"

    eqn "$status" 0
    eqs "${lines[0]}" '&lt;a&gt;'
}


@test "$_TF: \"" {
    run "$_TF" <<< "\""

    eqn "$status" 0
    eqs "${lines[0]}" '&quot;'
}
