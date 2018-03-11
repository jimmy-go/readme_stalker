#!./vendor/bats/bin/bats

load '../vendor/bats-support/load'
load '../vendor/bats-assert/load'

@test "merge() validate params" {
    DIR=$PWD/_files
    run scripts/merge.sh $DIR $DIR/trash/index.html
    assert_success
}

