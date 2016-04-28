#!/bin/sh
function arrayParameter()
{
    echo "Number of params: $#"
    echo "Params: $@"
    echo $#
    while [ $# -gt 0 ]
    do
        echo $1
        shift
    done
}

paramArray=(a "bb" "cc  dd" "ee   ff   gg")
echo "-----Call function with \"\${paramArray[@]}\"-----"
demo1 "${paramArray[@]}"
echo "-----Call function with \"\${paramArray[*]}\"-----"
demo1 "${paramArray[*]}"
echo "-----Call function with \${paramArray[@]}-----"
demo1 ${paramArray[@]}
echo "-----Call function with \${paramArrya[*]}-----"
demo1 ${paramArray[*]}