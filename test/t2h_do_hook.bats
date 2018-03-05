#!/usr/bin/env bats
_TF='t2h_do_hook'   # tested function
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


###################
# testing filters #
###################


_inc()
{
    echo $(($(cat) + 1))
}


_dbl()
{
    echo $(($(cat) * 2))
}


###############
# t2h_do_hook #
###############


@test "$_TF: hook does not exist" {
    run $_TF foobar <<< '123'
    eqn "$status" 0
    eqs "${lines[0]}" 123
}


@test "$_TF: 1 filter" {
    t2h_hook_inc=(_inc)

    run $_TF inc <<< '0'
    eqn "$status" 0
    eqs "${lines[0]}" 1

    run $_TF inc <<< '1'
    eqn "$status" 0
    eqs "${lines[0]}" 2
}


@test "$_TF: 2 filter" {
    t2h_hook_inc_dbl=(_inc _dbl)

    run $_TF inc_dbl <<< '0'
    eqn "$status" 0
    eqs "${lines[0]}" 2

    run $_TF inc_dbl <<< '1'
    eqn "$status" 0
    eqs "${lines[0]}" 4
}


@test "$_TF: filter order" {
    t2h_hook_dbl_inc=(_dbl _inc)

    run $_TF dbl_inc <<< '0'
    eqn "$status" 0
    eqs "${lines[0]}" 1

    run $_TF dbl_inc <<< '1'
    eqn "$status" 0
    eqs "${lines[0]}" 3
}
