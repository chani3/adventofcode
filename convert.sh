#!/bin/bash
#grab a project input and make a starting ruby file from it

day=$1
input=input/$day.txt
output=$day.rb
mydir=$(dirname "$0")

#echo "stuff: $me $mydir/template.rb $input  $output"
cat $mydir/template.rb $input > $output
chmod +x $output
git add $output

