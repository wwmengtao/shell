#!/bin/sh
function commandsDemo(){
#һ���滻
#1�������滻
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

#2����ÿһ�е�ĩβ����TAILTIGER
File=strings.xml;
sed -i 's#$#& TAILTIGER#g' $File;

#3�����������滻
<b>This</b> is what <b>I</b> meant --��This is what I meant
sed -e 's#<[^>]*>##g' /home/mengtao1/Downloads/strings.xml

#��������ɾ��
#1��ѭ��ɾ��
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

#2��ֻɾ���ļ���2��
sed -i "2d" $FileNAME
#��������ɾ�����в�����frameworks����
sed -i '/frameworks/!d' $FileNAME

#3����������ɾ���ļ��С���֮��Ķ���ע�����ݲ�ɾ������
#1)����ɾ������ע��
sed -i "/<!--.*-->/d" $FILE_Temp
#2)����ɾ������ע��
sed -i "/<!--/,/-->/d" $FILE_Temp
#3)ɾ������
sed -i "/^$/d" $FILE_Temp

#�����������
#�ҳ����������µ��ض�string ID���ݲ������
for VALUES in \
values
do
	for ROAD in `find . -name "$VALUES"`
	do
	find $ROAD -name "*.xml" | grep -R '="status_bar_settings_notifications"' $ROAD >>/home/mengtao1/Downloads/Strings.xml
	done
done



#�塢������������
#1�������滻�ļ�(��)����
Src=values-es-rUS;Des=values;for x in `find . -name "$Src" `; do echo $x;mv $x $(echo $x | sed -e s/$Src/$Des/g); done
Src=strings.xml;Des=camera_strings.xml;for x in `find . -name "$Src" `; do echo $x;mv $x $(echo $x | sed -e s/$Src/$Des/g); done

Src=strings.xml;Des=album_string.xml;for x in `find . -name "$Src" `; do echo $x;mv $x $(echo $x | sed -e s/$Src/$Des/g); done

#2������ɾ���ļ�(��)
FILE=mtk_arrays.xml;find ./ -name $FILE | xargs rm -rf
FILE=values-zh-rTW;find ./ -name $FILE | xargs rm -rf

#3����ԭ����values�е����ݿ�����ͬ��Ŀ¼�²�����Ϊvalues-xx
for road1 in `find . -name "values-es-rUS"`;do cp -rf $road1 $road1/../values;cp -rf $road1 $road1/../values-zh-rCN;done
#4����sysĿ¼�µĶ�Ӧ��overlay�е�ĳ�����Կ�������ǰ�ļ���
roadSwa=/home/mengtao1/localrepo/stella_sofina/sys;
for road1 in `find . -name "res"`;
	do cp -rf $roadSwa/$road1/values-pt-rPT $road1;
done
#5��ÿһ��git�㶼ִ��"git reset --hard; git clean -df"������ʡȥ��ɾ�������ļ��еķ���
repo forall -c "git reset --hard; git clean -df"
repo forall -c "git reset --hard; git clean -fdx"
#6���������ĳһģ���log��Ϣ
git log --pretty=oneline ./packages/apps/Settings/res/values-es-rUS/strings.xml


#8���ж��ļ�(Ŀ¼)�Ƿ���ڻ��߾���Ȩ��
#!/bin/sh 
myPath="/var/log/httpd/" 
myFile="/var/log/httpd/access.log" 

#�����-x �����ж�$myPath�Ƿ���ڲ����Ƿ���п�ִ��Ȩ�� 
if [ ! -x "$myPath"]; then 
	mkdir "$myPath" 
fi

#������������-n,-n���ж�һ�������Ƿ��Ƿ���ֵ 
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
#�������arrayParameterʹ�õ�����������ƺ�arrayParameter��paramArray=$1�Ĳ���������ͬ����ô�õ���ʵ�������С������ֻ��$#$@�ж�
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
	# ��������ɵ�zip�ļ�
	out_filename=./SourceAapt.zip
	# ��ѹ����ļ���
	out_zipdir=./SourceAapt
	if [ -d "$out_zipdir" ]; then
		rm -rf "$out_zipdir";
	fi
	# ����
	aapt p -f -M $dir/AndroidManifest.xml -F $out_filename -S $dir/res -I $sdk_dir/android.jar
	# ��ѹ
	unzip -o $out_filename -d $out_zipdir
	# ɾ��zip�ļ�
	if [ -f "$out_filename" ]; then
		rm "$out_filename";
	fi	
}

function CreateProject(){
	roadDirName=.;#��Ŀ¼�ṩ���д�������ģ������
	roadSrc=/home/mengtao1/localrepo/Affinity;#��Ŀ¼�ṩroadDirName��ģ�������µ����ݣ� ����/home/mengtao1/localrepo/K5_2_row
	roadTar=/home/mengtao1/Downloads/Affinity;#�����������մ�ŵص㣬��/home/mengtao1/Downloads/K5_row_en
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