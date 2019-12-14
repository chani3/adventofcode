#!/bin/bash
#grab a project input and make a starting ruby file from it

day=$1
input=input/$day.txt
output=$day.rb

echo -e "#!/usr/bin/ruby\n\np DATA.readlines[0]\n\n__END__" | cat - $input > $output
chmod +x $output
git add $output

