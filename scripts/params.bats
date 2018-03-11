#!./vendor/bats/bin/bats

load '../vendor/bats-support/load'
load '../vendor/bats-assert/load'

@test "params: user, branch, token" {
    run scripts/params.sh "a" "b" "c"
    assert_success
}

@test "params: user, branch, token" {
    run scripts/params.sh
    assert_failure
}

