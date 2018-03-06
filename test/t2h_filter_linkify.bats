#!/usr/bin/env bats
_TF='t2h_filter_linkify'    # tested function
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


###########
# helpers #
###########


_test_link()
{
    local line="${BATS_TEST_DESCRIPTION#*: }"
    local id="${line%%] *}]"
    local href="${line#*] }"
    local a="<a href=\"$href\">$href</a>"

    run "$_TF" <<< "$line"
    eqn "$status" 0
    eqs "${lines[*]}" "$id $a"

    run "$_TF" <<< "  $line"
    eqn "$status" 0
    eqs "${lines[*]}" "  $id $a"
}


_test_same()
{
    local line="${BATS_TEST_DESCRIPTION#*: }"

    run "$_TF" <<< "$line"
    eqn "$status" 0
    eqs "${lines[*]}" "$line"

    run "$_TF" <<< "  $line"
    eqn "$status" 0
    eqs "${lines[*]}" "  $line"
}


#############
# linkified #
#############


@test "$_TF: [*] file:///foo/bar.html" {
    _test_link
}


@test "$_TF: [X] ftps://example.com" {
    _test_link
}


@test "$_TF: [0] http://example.com" {
    _test_link
}


@test "$_TF: [0] https://example.com" {
    _test_link
}


@test "$_TF: [M] mailto:john.doe@example.com" {
    _test_link
}


@test "$_TF: [*] ." {
    _test_link
}


@test "$_TF: [*] ./foo/bar.html" {
    _test_link
}


@test "$_TF: [*] .." {
    _test_link
}


@test "$_TF: [*] ../foo/bar.html" {
    _test_link
}


@test "$_TF: [*] /foo/bar.html" {
    _test_link
}


@test "$_TF: [*] //example.com/foo/bar.html" {
    _test_link
}


#############
# not links #
#############


@test "$_TF: http://example.com" {
    _test_same
}


@test "$_TF: [1]: http://example.com" {
    _test_same
}


@test "$_TF: [abc] http://example.com" {
    _test_same
}


@test "$_TF: [1] blah://example.com" {
    _test_same
}
