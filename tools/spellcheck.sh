#!/bin/bash

for i in $(git diff-tree --no-commit-id --name-only -r HEAD | grep .tex);
do
  echo "-- Checking file $i --"
  tmp=$(cat $i | aspell --lang=en -t -a --add-extra-dicts="`pwd`/tools/dictionary.en.pws" | grep -v "*" | grep -v "@" | sed '/^\s*$/d')
  echo "-- !!List of errors detected for $i!! --"
  echo "$tmp"
  echo "-- !!End of list for $i!! --"
  res=$res$tmp
done

if [ "$res" != "" ]
then
  exit 1
else
  exit 0
fi
