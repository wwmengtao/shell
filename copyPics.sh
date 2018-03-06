#!/bin/sh

srcPicsPath="/e/workspace/ASProjects/AndroidTest_AS/testmodule/src/main/res";
SUFFIX=".png"


for picName in \
	ic_key
do
	for path in `fi2nd $srcPicsPath -name "$picName$SUFFIX"`
	do
		echo $path
	done
done