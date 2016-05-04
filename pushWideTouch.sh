#!/bin/sh
notExce(){
dirName=(
	P1_M_ROW/vendor/lenovo/PRCUI/Apps/LenovoSettings
)
branchName=(
	#row_V3.1.0
	p1_M_row
)
}

function copyAndPush(){
#
rootDir=$1;
dirName=$2;
branchName=$3;
pushInfo=$4;
#
index=0;
while [ $index -lt ${#dirName[*]} ]; 
do
	cd $rootDir/${dirName[$index]};
	git reset --hard;repo sync -c .;
	for road1 in `find . -name $AppName | sed "s#WideTouch\.apk##g"`;
	do 
		cp -f $srcFile2 $road1;
	done		
	git commit -asm $pushInfo;
	git push VIBEUI HEAD:refs/for/${branchName[$index]};
	echo $rootDir/${dirName[$index]};
	let index++;
done	
}
#Here comes the operating...
AppName=WideTouch.apk;
srcFile1=/home/mengtao1/Downloads/WideTouch*.apk
srcFile2=/home/mengtao1/Downloads/$AppName
if [ ! -f "$srcFile2" ]; then 
	mv $srcFile1 $srcFile2;
fi

if [ -f "$srcFile2" ]; then 
	rootDir=/home/mengtao1/localrepo;
	dirName=(
		K5_M_row/vendor/lenovo/PRCUI/Apps/LenovoSettings
		P1_M_ROW/vendor/lenovo/PRCUI/Apps/LenovoSettings
		P1_M_ROW/vendor/lenovo/PRCUI/Apps/LenovoSettings
		Sisley2_M_row/device/lenovo/VIBEUI/Apps/LenovoSettings
		X3_M_ROW/LINUX/android/vendor/lenovo/PRCUI/Apps/LenovoSettings
		Zoom_M_row/vendor/lenovo/PRCUI/Apps/LenovoSettings
		K52_M_row/vendor/lenovo/PRCUI/Apps/LenovoSettings
	)
	branchName=(
		row_V3.5
		row_V3.1.0
		p1_M_row
		m_row
		qcom8992_M_row
		zoom_row_M
		mt6755_M_row
	)
	dirName=(
		K52_M_row/vendor/lenovo/PRCUI/Apps/LenovoSettings
	)
	branchName=(
		mt6755_M_row
	)
	pushInfo="[K52a48_M][KFIVIIROWM-117][mengtao1]:Notification center has stopped when tap flashlight in wide touch.";
	copyAndPush $rootDir $dirName $branchName $pushInfo;
fi




