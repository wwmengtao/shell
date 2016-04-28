#!/bin/sh
function arrayParameter()
{
    echo "Number of params: $#"
    echo "Params: $@"
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

function arrayParameter2()
{
	index=$1
	array=$2
	echo $index
	echo ${array[*]}
}

function arrayParameter3()
{
	array=$1
	index=$2
	echo ${array[*]}
	echo $index
}

function testArrayParameters2(){
	paramArray=(a b c)
	index="test"
	echo "-----Call function arrayParameter-----"
	arrayParameter $index "${paramArray[@]}" 
	echo "-----Call function arrayParameter2-----"
	arrayParameter2 $index "${paramArray[@]}"
	echo "-----Call function arrayParameter3-----"
	arrayParameter3 "${paramArray[@]}" $index 
}
#testArrayParameters;
testArrayParameters2;
