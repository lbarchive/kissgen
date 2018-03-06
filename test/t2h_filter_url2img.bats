#!/usr/bin/env bats
_TF='t2h_filter_url2img'    # tested function
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


_test_img()
{
    local line="${BATS_TEST_DESCRIPTION#*: }"
    local src="$line"
    local img="<img src=\"$src\">"

    run "$_TF" <<< "$line"
    eqn "$status" 0
    eqs "${lines[*]}" "$img"

    run "$_TF" <<< "  $line"
    eqn "$status" 0
    eqs "${lines[*]}" "  $img"
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


##########
# images #
##########


@test "$_TF: file:///tmp/foobar.png" {
    _test_img
}


@test "$_TF: ftp://example.com/foobar.gif" {
    _test_img
}


@test "$_TF: http://example.com/foobar.gif" {
    _test_img
}


@test "$_TF: https://example.com/foobar.gif" {
    _test_img
}


@test "$_TF: https://example.com/foobar.jpeg" {
    _test_img
}


@test "$_TF: https://example.com/foobar.jpg" {
    _test_img
}


@test "$_TF: https://example.com/foobar.png" {
    _test_img
}


@test "$_TF: ./foobar.png" {
    _test_img
}


@test "$_TF: ../foobar.png" {
    _test_img
}


@test "$_TF: /foo/bar.png" {
    _test_img
}


@test "$_TF: //foo/bar.png" {
    _test_img
}


##############
# not images #
##############


@test "$_TF: http://example.com" {
    _test_same
}


@test "$_TF: http://example.com/something.txt" {
    _test_same
}
