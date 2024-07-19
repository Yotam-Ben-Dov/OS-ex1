#!/bin/bash
#Yotam Ben Dov 316387950
# main function def
gccfind()
{
    cd "$1"
    rm -f *.out 
    find . -maxdepth 1 -type f -name "*.c" |
    while IFS= read file
    do
        if grep -q -i $2 $file
        then
            gcc -w -o "${file%.c}.out" "${file}"
        fi
    done
    if [[ $3 == "-r" ]]
    then
        for dir in ./*
        do
            dir=${dir%*/}
            if [[ -d "$dir" ]]
            then
                $($0 "./${dir##*/}" $2 "-r")
            fi
        done
    fi
}

if (( $# < 2 ))
then
	echo "Not enough parameters"
else
	gccfind $1 $2 $3
fi
