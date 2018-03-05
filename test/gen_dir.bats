#!/usr/bin/env bats
_TF=gen_dir     # test gen_dir function
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


@test "$_TF  # missing both text and html arguments" {
    run $BATS_TEST_DESCRIPTION

    eqn "$status" 1
}


@test "$_TF text.dir  # missing html argument" {
    run $BATS_TEST_DESCRIPTION

    eqn "$status" 1
}


# path
######


@test "$_TF text.dir html.dir  # text.dir does not exist" {
    local td="$_TF_TMPDIR/text.dir"
    local hd="$_TF_TMPDIR/html.dir"

    run "$GEN" "$td" "$hd"

    eqn "$status" 1
    echo_lines
    [[ "${lines[0]}" == *'does not exist'* ]]
}


# test various path arugments
# $1: cd into $_TF_TMPDIR, if == 1
# BATS_TEST_DESCRIPTION[1]: text.dir
# BATS_TEST_DESCRIPTION[2]: html.dir
_path_test()
{
    if (($1)); then
        cd "$_TF_TMPDIR"
    fi
    local A=(${BATS_TEST_DESCRIPTION//\/TMPDIR/$_TF_TMPDIR})
    local td="${A[1]}"
    local hd="${A[2]}"
    mkdir -p "$td"

    run "$GEN" "$td" "$hd"
    echo_lines
    eqn "$status" 0

    local text='foobar'
    echo "$text" > "$td/test.txt"

    run "$GEN" "$td" "$hd"
    echo_lines
    eqn "$status" 0
    grep "$text" "$hd/test.html"
}


@test "$_TF text.dir html.dir" {
    _path_test 1
}


@test "$_TF /TMPDIR/foo/bar/text.dir /TMPDIR/html.dir" {
    _path_test 0
}


@test "$_TF /TMPDIR/text.dir /TMPDIR/foo/bar/html.dir" {
    _path_test 0
}


@test "$_TF /TMPDIR/foo/bar/text.dir /TMPDIR/foo/bar/html.dir" {
    _path_test 0
}


@test "$_TF /TMPDIR/foo/bar/text.dir /TMPDIR/foobar/html.dir" {
    _path_test 0
}


@test "$_TF a/b/c html.dir" {
    _path_test 1
}


@test "$_TF text.dir html.dir  # text.dir/a/b/c/test.txt" {
    _path_test 1
}
