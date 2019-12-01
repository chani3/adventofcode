#!/bin/bash
#grab a project input and make a starting ruby file from it

input=$1
output=$2

echo -e "#!/usr/bin/ruby\n\np DATA.readlines[0]\n\n__END__" | cat - $1 > $2
chmod +x $2
git add $2

