#!/bin/bash

success=0
failed=0

for k in ok lexikalis-hibas szintaktikus-hibas szemantikus-hibas
do
    for i in `ls $k`
    do
        echo ">run $k/$i"
        ../abap "$k/$i" > /dev/null
        if [ $? = 0 ];
        then
            let success+=1
        else
            let failed+=1
        fi
    done
done

echo "ok: $success/6, error: $failed/25"