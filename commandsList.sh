#!/bin/sh
function commandsDemo(){
#一、替换
#1、数组替换
SrcWord=(
'brightness,sleep mode'
)
DestWord=(
'brightness, sleep mode'
)
i=0
while [ $i -lt ${#DestWord[*]} ];
do
for ROAD in `find . -name "values"`
do
find $ROAD -name "*.xml" | xargs sed -i "s/${SrcWord[$i]}/${DestWord[$i]}/g"
done
let i++
done

#2、将每一行的末尾加上TAILTIGER
File=strings.xml;
sed -i 's#$#& TAILTIGER#g' $File;

#3、特殊内容替换
<b>This</b> is what <b>I</b> meant --》This is what I meant
sed -e 's#<[^>]*>##g' /home/mengtao1/Downloads/strings.xml

#二、内容删除
#1、循环删除
for SrcWord in \
	font_sdcard_description_two_cn\
	custom_theme_systemui
do
	find . -name "*.xml" | xargs sed -i '/<string.*name="'$SrcWord'"/d'
	find . -name "*.xml" | xargs sed -i "/<string-array.*name=\"$SrcWord\"/,/<\/string-array>/d"
done

#Replace only once,
#<item> -> <string ...>
find . -name *.xml | xargs sed -i '1,/<item>/{s/<item>/<string name="battery_style_graphical">/}'

#2、只删除文件第2行
sed -i "2d" $FileNAME
#方法三、删除所有不包含frameworks的行
sed -i '/frameworks/!d' $FileNAME

#3、以下命令删除文件中“”之间的多行注释内容并删除空行
#1)首先删除单行注释
sed -i "/<!--.*-->/d" $FILE_Temp
#2)接着删除多行注释
sed -i "/<!--/,/-->/d" $FILE_Temp
#3)删除空行
sed -i "/^$/d" $FILE_Temp

#三、内容输出
#找出所有语言下的特定string ID内容并且输出
for VALUES in \
values
do
	for ROAD in `find . -name "$VALUES"`
	do
	find $ROAD -name "*.xml" | grep -R '="status_bar_settings_notifications"' $ROAD >>/home/mengtao1/Downloads/Strings.xml
	done
done



#五、批量操作命令
#1、批量替换文件(夹)名称
Src=values-es-rUS;Des=values;for x in `find . -name "$Src" `; do echo $x;mv $x $(echo $x | sed -e s/$Src/$Des/g); done
Src=strings.xml;Des=camera_strings.xml;for x in `find . -name "$Src" `; do echo $x;mv $x $(echo $x | sed -e s/$Src/$Des/g); done

Src=strings.xml;Des=album_string.xml;for x in `find . -name "$Src" `; do echo $x;mv $x $(echo $x | sed -e s/$Src/$Des/g); done

#2、批量删除文件(夹)
FILE=mtk_arrays.xml;find ./ -name $FILE | xargs rm -rf
FILE=values-zh-rTW;find ./ -name $FILE | xargs rm -rf

#3、在原处将values中的内容拷贝到同级目录下并命名为values-xx
for road1 in `find . -name "values-es-rUS"`;do cp -rf $road1 $road1/../values;cp -rf $road1 $road1/../values-zh-rCN;done
#4、将sys目录下的对应于overlay中的某国语言拷贝至当前文件夹
roadSwa=/home/mengtao1/localrepo/stella_sofina/sys;
for road1 in `find . -name "res"`;
	do cp -rf $roadSwa/$road1/values-pt-rPT $road1;
done
#5、每一个git点都执行"git reset --hard; git clean -df"操作，省去了删除整个文件夹的烦恼
repo forall -c "git reset --hard; git clean -df"
repo forall -c "git reset --hard; git clean -fdx"
#6、查找针对某一模块的log信息
git log --pretty=oneline ./packages/apps/Settings/res/values-es-rUS/strings.xml


#8、判断文件(目录)是否存在或者具有权限
#!/bin/sh 
myPath="/var/log/httpd/" 
myFile="/var/log/httpd/access.log" 

#这里的-x 参数判断$myPath是否存在并且是否具有可执行权限 
if [ ! -x "$myPath"]; then 
	mkdir "$myPath" 
fi

#其他参数还有-n,-n是判断一个变量是否是否有值 
if [ ! -n "$myVar" ]; then 
	echo "$myVar is empty" 
	exit 0 
fi

#How to use?
rootDir=/e/Bat_shell/Files;
outPutFile=$rootDir/log.txt
localesDir=/e/Bat_shell/Files/locales;
ampm $localesDir $outPutFile;
}

#4.Across line to find the content
function ampm(){
	localesDir=$1;
	outFileName=$2;
	echo "" > $outFileName;
	index=0;
	for filename in `find $localesDir -name "*.txt"`
	do
		for searchContent in\
			"AmPmMarkers{"\
			"AmPmMarkers%variant{"\
			"AmPmMarkersNarrow"{
		do
			num=`grep -c $searchContent $filename`;
			if [ $num -ne 0 ];then 
				let index++;
				if [ $index -eq 1 ];then
					echo $filename >> $outFileName;
				else
					echo "" >> $outFileName;
				fi
				awk "/$searchContent/,/}/" $filename >> $outFileName;
			fi
		done
		index=0;
	done
}

function arrayParameter(){	
	paramArray=$1;
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

function aaptFunction(){
	dir=/d/workspace/AndroidTest
	sdk_dir=/e/Android/android-sdk-M/platforms/android-23/
	# 编译后生成的zip文件
	out_filename=./SourceAapt.zip
	# 解压后的文件夹
	out_zipdir=./SourceAapt
	if [ -d "$out_zipdir" ]; then
		rm -rf "$out_zipdir";
	fi
	# 编译
	aapt p -f -M $dir/AndroidManifest.xml -F $out_filename -S $dir/res -I $sdk_dir/android.jar
	# 解压
	unzip -o $out_filename -d $out_zipdir
	# 删除zip文件
	if [ -f "$out_filename" ]; then
		rm "$out_filename";
	fi	
}

function CreateProject(){
	roadDirName=.;#此目录提供所有待拷贝的模块名称
	roadSrc=/home/mengtao1/localrepo/Affinity;#此目录提供roadDirName中模块名称下的内容， 比如/home/mengtao1/localrepo/K5_2_row
	roadTar=/home/mengtao1/Downloads/Affinity;#拷贝内容最终存放地点，如/home/mengtao1/Downloads/K5_row_en
	if [ -d "$roadTar" ]; then 
	    rm -rf $roadTar;
	fi
	for ROAD in `find $roadDirName -name "values" | sed "s#\/values##g" | sed "s#.*\.\/##"`
	do
		for VALUES in \
			values-pl\
			values-nl-rBE\
			values-da-rDK\
			values-sv-rSE\
			values-nb-rNO\
			values-fi-rFI\
			values-et-rEE\
			values-lv-rLV\
			values-lt-rLT\
			values-de-rDE\
			values-it-rIT\
			values-iw-rIL\
			values-nl\
			values-da\
			values-sv\
			values-nb\
			values-fi\
			values-et\
			values-lv\
			values-lt\
			values-de\
			values-it\
			values-iw
		do
			if [ -d "$roadSrc/$ROAD/$VALUES" ]; then 
				echo "hehe""$roadSrc/$ROAD/$VALUES"
				if [ ! -d "$roadTar/$ROAD" ]; then 
					mkdir -p "$roadTar/$ROAD"
				fi
				cp -rf $roadSrc/$ROAD/$VALUES $roadTar/$ROAD;
			fi
		done
	done
}
#Here comes the operating...
#aaptFunction