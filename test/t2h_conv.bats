#!/usr/bin/env bats
_TF='t2h_conv'   # tested function
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
    _title='this is title'
    _text='some text'
}


###################
# testing filters #
###################


_foobar()
{
    echo -e 'foobar'
}


_append_foobar()
{
    echo "$(cat) foobar"
}


############
# t2h_conv #
############


@test "$_TF: \n before EOF" {
    local ret="$(echo "$_text" | t2h_conv "$_title")"
    eqs "<!DOCTYPE html>
<title>$_title</title>
<pre>$_text</pre>" "$ret"
}


@test "$_TF: no \n before EOF" {
    local ret="$(echo -n "$_text" | t2h_conv "$_title")"
    eqs "<!DOCTYPE html>
<title>$_title</title>
<pre>$_text</pre>" "$ret"
}


#########
# hooks #
#########


# title hooks
#############


@test "$_TF hooks: title: _foobar" {
    t2h_hook_title=(_foobar)
    local ret="$(echo -n "$_text" | t2h_conv "$_title")"
    eqs "<!DOCTYPE html>
<title>foobar</title>
<pre>$_text</pre>" "$ret"
}


@test "$_TF hooks: title: _append_foobar" {
    t2h_hook_title=(_append_foobar)
    local ret="$(echo -n "$_text" | t2h_conv "$_title")"
    eqs "<!DOCTYPE html>
<title>$_title foobar</title>
<pre>$_text</pre>" "$ret"
}


@test "$_TF hooks: after_title: _foobar" {
    t2h_hook_after_title=(_foobar)
    local ret="$(echo -n "$_text" | t2h_conv "$_title")"
    eqs "<!DOCTYPE html>
<title>$_title</title>
foobar
<pre>$_text</pre>" "$ret"
}


# pre hooks
###########


@test "$_TF hooks: before_pre: _foobar" {
    t2h_hook_before_pre=(_foobar)
    local ret="$(echo -n "$_text" | t2h_conv "$_title")"
    eqs "<!DOCTYPE html>
<title>$_title</title>
foobar
<pre>$_text</pre>" "$ret"
}


@test "$_TF hooks: pre: _append_foobar" {
    t2h_hook_pre=(_append_foobar)
    local ret="$(echo -n "$_text" | t2h_conv "$_title")"
    eqs "<!DOCTYPE html>
<title>$_title</title>
<pre>$_text foobar</pre>" "$ret"
}


@test "$_TF hooks: after_pre: _foobar" {
    t2h_hook_after_pre=(_foobar)
    local ret="$(echo -n "$_text" | t2h_conv "$_title")"
    eqs "<!DOCTYPE html>
<title>$_title</title>
<pre>$_text</pre>
foobar" "$ret"
}
