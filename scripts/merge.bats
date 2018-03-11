#!./vendor/bats/bin/bats

load '../vendor/bats-support/load'
load '../vendor/bats-assert/load'

@test "merge() validate params" {
    DIR=$PWD/_files
    OUT_DIR=$DIR/trash
    mkdir -p $OUT_DIR
    run scripts/merge.sh $DIR $OUT_DIR/index.html
    assert_success
}

