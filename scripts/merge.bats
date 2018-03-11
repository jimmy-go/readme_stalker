#!./vendor/bats/bin/bats

load '../vendor/bats-support/load'
load '../vendor/bats-assert/load'

@test "merge() validate params" {
    run scripts/merge.sh "_files" "_files/trash/index.html"
    assert_success
}

