#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "params: user, branch, token" {
    run scripts/params.sh "a" "b" "c"
    assert_success
}

@test "params: user, branch, token" {
    run scripts/params.sh
    assert_failure
}

