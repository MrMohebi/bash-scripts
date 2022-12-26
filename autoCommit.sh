#!/bin/bash

RandCommitNum=$(( RANDOM % 15 ))

gitCommit(){
  git config user.name 'github-actions[bot]'
  git config user.email 'MMMohebi@outlook.com'
  git add .
  git commit --allow-empty -m ":robot: commit automatically"
}

for _ in $RandCommitNum ; do
    gitCommit
done

git push

echo "committed $RandCommitNum commit "