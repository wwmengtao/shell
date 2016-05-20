#!/bin/sh
function arrayParameter()
{	paramArray=$1;
	echo "arraySize:${#paramArray[*]}"
    echo "Number of params: $#"
    echo "Params: $@"
    while [ $# -gt 0 ]
    do
        echo $1
        shift
    done
}

#if you use the array parameter both same in function testArrayParameter and arrayParameter, you will get the real arraysize
#如果调用arrayParameter使用的数组参数名称和arrayParameter中paramArray=$1的参数名称相同，那么得到真实的数组大小，否则只能$#$@判断
function testArrayParameter(){
	array=(a b c)
	echo "-----Call function with \${array[@]}-----"
	arrayParameter ${array[@]}
	echo "-----Call function with \${array[*]}-----"
	arrayParameter ${array[*]}
	echo "-----Call function with \"\$array\"-----"
	arrayParameter $array	
	#
	paramArray=(a "cc  dd" "ee   ff   gg")
	echo "-----Call function with \"\${paramArray[@]}\"-----"
	arrayParameter "${paramArray[@]}"
	echo "-----Call function with \"\${paramArray[*]}\"-----"
	arrayParameter "${paramArray[*]}"
	echo "-----Call function with \"\$paramArray\"-----"
	arrayParameter $paramArray	
}

#Following comes the operation......
#testArrayParameter;

dir=/d/workspace/AndroidTest
sdk_dir=/e/Android/android-sdk-M/platforms/android-23/
# 编译后生成的zip文件
out_filename=./SourceAapt.zip
# 解压后的文件夹
out_zipdir=./SourceAapt

# 编译
aapt p -f -M $dir/AndroidManifest.xml -F $out_filename -S $dir/res -I $sdk_dir/android.jar

# 解压
#unzip -o $out_filename -d $out_zipdir# 删除zip文件
#rm $out_filename