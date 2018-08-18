#!/bin/bash
set -eux
set -o pipefail

ExecComamnd=$(basename $(pwd))
TESTDIR=test-${ExecComamnd}-$$

mkdir -p $TESTDIR
go build
cp ./${ExecComamnd} $TESTDIR
cd $TESTDIR

:
: prepare git
:
git init
git config --local user.email "git-fixup@example.com"
git config --local user.name "git fixup"
git commit --allow-empty -m "Initial commit"

:
: prepare test
:
max=10
for ((i=0; i <= $max; i++)); do
    touch file-${i}
    git add file-${i}
    git commit -m "Add file-${i}"
done

:
: test
:
NUM=5
EXPECTED_ADDED_FILE_NUM=$(( $NUM + 1 ))

git log --oneline
./${ExecComamnd} -n $NUM -f
git log --oneline
ADDED_FILE_NUM=`git diff HEAD^..HEAD --name-only | wc -l | tr -d ' '`

if [ "$ADDED_FILE_NUM" == "$EXPECTED_ADDED_FILE_NUM" ]; then
  echo "*** test passed ***"
  exit 0
else
  echo "*** test failed ***"
  exit 1
fi
