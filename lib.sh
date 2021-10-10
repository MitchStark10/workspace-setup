#!/bin/bash
j() {
    echo "variable: " $1
    for (( i=1; i <= $1; i++))
    do
        cd ..
        echo "cd ../"
    done
}

search() {
    grep -r "$1" .
}

remove_commit() {
   git reset --soft HEAD^;
   git reset HEAD .
}
