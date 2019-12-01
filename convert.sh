#!/bin/bash
#grab a project input and make a starting ruby file from it

input=$1
output=$2

echo -e "#!/usr/bin/ruby\n\n__END__\n" | cat - $1 > $2
