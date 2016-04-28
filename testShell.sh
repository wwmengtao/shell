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

function testArrayParameters(){
	paramArray=(a 
	#"bb" 
	"cc  dd" "ee   ff   gg")
	echo "-----Call function with \"\${paramArray[@]}\"-----"
	arrayParameter "${paramArray[@]}"
	echo "-----Call function with \"\${paramArray[*]}\"-----"
	arrayParameter "${paramArray[*]}"
	echo "-----Call function with \${paramArray[@]}-----"
	arrayParameter ${paramArray[@]}
	echo "-----Call function with \${paramArrya[*]}-----"
	arrayParameter ${paramArray[*]}
}


function testArrayParameters2(){
	paramArray=(a b c)
	index="test"
	arrayParameter $index "${paramArray[@]}" 
}
#testArrayParameters;
testArrayParameters2;
