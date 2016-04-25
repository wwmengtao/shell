#!/bin/sh
function cmdAndGitbash(){
#cmd commands
adb pull /data/data/com.android.providers.settings/databases/settings.db
adb push /d/Software/Temp/PowerManager.apk /system/priv-app/PowerManager
ren D:\Software\Temp\PowerSettingActivity_signed.apk PowerManager.apk
adb push D:\Software\Temp\PowerManager.apk /system/priv-app/PowerManager
adb logcat -c;
adb logcat > D:\WorkMaterial\localrepo\LenovoPower\log.txt

#git-bash commands
mv /d/Software/Temp/PowerSettingActivity_signed.apk /d/Software/Temp/PowerManager.apk
adb pull //data/data/com.android.providers.settings/databases/settings.db
adb push /d/Software/Temp/PowerManager.apk //system/priv-app/PowerManager
adb logcat -c;adb logcat > $outPutFile

adb shell dumpsys notification > D:\WorkMaterial\localrepo\LenovoPower\log.txt
adb shell dumpsys > $outPutFile
adb shell dumpsys activity activities > $outPutFile
}

declare -i index_reboot=0
declare -i index_remount=0
function adbPush()
{

filename=$1
suffix=$2
mountPath=$3
APKDelete=$4
if [ -f $filename*.$suffix ]; then 

	let index_remount++
	if [ $index_remount = 1 ]; then 
		adb remount
		echo "remount..."
	fi
	index_reboot=1
	case "$suffix" in
	apk)
		mv $filename*.$suffix $filename.$suffix
		if [ "$filename" = "framework-res" ]; then 
			adb push $filename.$suffix $mountPath
		else 
			adb push $filename.$suffix $mountPath/$filename
		fi 
		;;
	jar)
		adb push $filename.$suffix $mountPath
		;;
	esac
	strPar="n";
	strContains "$APKDelete" "$strPar";
	deleteFile=$?;
	if [ $deleteFile -eq 0 ]; then 
		rm $filename.$suffix
	fi
fi

}
function confirmDirExist(){
dirname=$1;
if [ -d "$dirname" ]; then 
	rm -rf "$dirname"
fi
mkdir -p "$dirname" 
}

function strContains(){
	strA=$1;
	strB=$2;
	result=$(echo $strA | grep "${strB}")
	if [ "$result" != "" ]
	then
	    return 1
	else
	    return 0
	fi
}

function adbDeviceExists(){
	while (true)
	do
		desDevices="List of devices attached";
		len_desDevices=$(echo `expr length "$desDevices"`);
		adbDevices=$(echo `adb devices`);
		len_adbDevices=$(echo `expr length "$adbDevices"`);

		if [ $len_desDevices -ne $len_adbDevices ]; then
			break 1;
		fi
	done
}

function demo(){
	./shell s r n;r:reboot the device;n:delete the file installed to device
}
#Here comes the operating...
adbDeviceExists;#firstly, judge if the adb devices exists
rootDir=/e/Bat_shell/Files;
outPutFile=$rootDir/log.txt
echo "Parameter1:$1"
#Uppercase to Lowercase
LOWERCASE=$(echo $1 | tr '[A-Z]' '[a-z]')
DeviceReboot=$(echo $2 | tr '[A-Z]' '[a-z]')
APKDelete=$(echo $3 | tr '[A-Z]' '[a-z]')
case $LOWERCASE in
p)
filename=PowerManager;
mv Power*.apk $filename.apk
adbPush $filename "apk" "//system/priv-app"
;;
s)
for filename in \
	SettingsProvider\
	Settings\
	VpnDialogs\
	LenovoSettings\
	LenovoSecurity\
	NotificationCenterPlus\
	NotificationCenter\
	Android_battery\
	AndroidProcessService\
	AndroidPreference\
	AndroidStorage\
	AndroidTest2\
	AndroidTest\
	WideTouch\
	AndroidCustomedControler

do	
	adbPush $filename "apk" "//system/priv-app" $APKDelete
done
;;
f)
for filename in \
	framework\
	ext\
	services\
	lenovocomponents
do
	adbPush $filename "jar"	"//system/framework"
done

for filename in \
	lenovo-res\
	framework-res
do
	adbPush $filename "apk"	"//system/framework"
done
;;
r)
	adb kill-server
	adb start-server
;;
l)
	adb logcat -c
	echo Tip:Logcat is runing......
	if [ "$2" = "mtk" ]
	then
		dirname=$rootDir/DeviceInfo/mtklog;
		confirmDirExist $dirname;
		adb pull //sdcard/mtklog/mobilelog $dirname;
	fi
	if [ "$2" = "" ]
	then
		adb logcat > $outPutFile
	else
		adb logcat |grep $2
	fi
	#adb logcat -v time -s WindowManager > $outPutFile
;;
gp)
	adb shell getprop > $outPutFile
;;
dpa)
adb shell dumpsys activity top > $outPutFile
;;
dpi)
adb shell dumpsys input > $outPutFile
;;
dpn)
adb shell dumpsys notification > $outPutFile
;;
dpw)
adb shell dumpsys window > $outPutFile
;;
df)
adb shell df > $outPutFile
;;
dbl)
adb pull //data/data/com.android.providers.settings/databases/settings.db;
;;
dbm)
userid=$2;
dirname=$rootDir/DeviceInfo/Users/$userid;
confirmDirExist $dirname;
adb pull //data/system/users/$userid/settings_global.xml $dirname;
adb pull //data/system/users/$userid/settings_secure.xml $dirname;
adb pull //data/system/users/$userid/settings_system.xml $dirname;
adb pull //data/system/users/$userid/restricted-packages.xml $dirname;
adb pull //data/system/users/$userid/package-restrictions.xml $dirname;
adb pull //data/system/users/$userid/registered_services $dirname;
adb pull //data/system/users/$userid/runtime-permissions.xml $dirname;
adb pull //data/system/users/$userid/appwidgets.xml $dirname;
#adb pull //data/data/com.android.providers.settings/databases/settings.db-backup;
#adb pull //data/data/com.android.providers.settings/databases/settings.db-journal;
;;
dbi)
dirname=$rootDir/DeviceInfo/InputInfo;
confirmDirExist $dirname;
adb pull //data/system/input-manager-state.xml $dirname;
;;
dbps)
dirname=$rootDir/DeviceInfo/AndroidProcessService;
confirmDirExist $dirname;
adb pull //data/system/mServiceProcessesByName.xml $dirname;
adb pull //data/system/mServiceProcessesByPid.xml $dirname;
adb pull //data/system/mRunningProcesses.xml $dirname;
adb pull //data/system/mInterestingProcesses.xml $dirname;
adb pull //data/system/mMergedItems.xml $dirname;
;;
ops)
dirname=$rootDir/DeviceInfo/AppOps;
confirmDirExist $dirname;
adb pull //data/system/appops.xml $dirname;
adb pull //system/etc/appops_policy.xml $dirname;
;;
pml)
adb shell pm list packages -f > $outPutFile
;;
ps)
if [ "$2" = "" ]
then 
adb shell ps
else
adb shell ps | grep $2;
fi
;;
sp)
dirname=$rootDir/DeviceInfo/SharedPreferences;
confirmDirExist $dirname;
adb pull //data/data/com.lenovo.widetouch/shared_prefs $dirname;
;;
esac
#Following judge if reboot the device
strAll=$DeviceReboot;
strPar="r";
strContains "$strAll" "$strPar";
reboot=$?;#if strAll contains strPar,reboot the device
#echo $reboot
if [ $index_reboot = 1 -a "$reboot" -eq 1 ]; then 
	adb reboot
	echo "rebooting..."
fi



