#!/bin/sh
function cmdAndGitbash(){
#cmdָ��
adb pull /data/data/com.android.providers.settings/databases/settings.db
adb push /d/Software/Temp/PowerManager.apk /system/priv-app/PowerManager
ren D:\Software\Temp\PowerSettingActivity_signed.apk PowerManager.apk
adb push D:\Software\Temp\PowerManager.apk /system/priv-app/PowerManager
adb logcat -c;
adb logcat > D:\WorkMaterial\localrepo\LenovoPower\log.txt

#git-bashָ��
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

	rm $filename.$suffix
fi

}
#Here comes the operating...
outPutFile=/e/Bat_shell/Files/log.txt
echo "Parameter:$1"
#Uppercase to Lowercase
LOWERCASE=$(echo $1 | tr '[A-Z]' '[a-z]')
DeviceReboot=$(echo $2 | tr '[A-Z]' '[a-z]')
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
	LenovoSettings\
	NotificationCenterPlus\
	NotificationCenter\
	Android_battery\
	AndroidProcess\
	AndroidPreference\
	WideTouch\
	AndroidCustomedControler
do	
	adbPush $filename "apk" "//system/priv-app"
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
df)
adb shell df > $outPutFile
;;
dbl)
#adb pull //data/system/users/10/settings.db;
adb pull //data/data/com.android.providers.settings/databases/settings.db;
;;
dbm)
adb pull //data/system/users/0/settings_global.xml;
adb pull //data/system/users/0/settings_secure.xml;
adb pull //data/system/users/0/settings_system.xml;
adb pull //data/system/users/10/settings_system.xml;
#adb pull //data/data/com.android.providers.settings/databases/settings.db-backup;
#adb pull //data/data/com.android.providers.settings/databases/settings.db-journal;
;;
dbi)
adb pull //data/system/input-manager-state.xml;
;;
dbid)
adb remount;
adb shell;
rm data/system/input-manager-state.xml;
;;
dbip)
adb pull //data/system/mServiceProcessesByName.xml;
adb pull //data/system/mServiceProcessesByPid.xml;
adb pull //data/system/mRunningProcesses.xml;
adb pull //data/system/mInterestingProcesses.xml;
adb pull //data/system/mMergedItems.xml;
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

esac
#���������һ����װ�ļ���װ���ֻ��У���ô�����ֻ�
strAll=$DeviceReboot;
strPar="r";
reboot=$(echo "$strAll"| grep "$strPar");#�����ָ��ֻҪ����strPar�е����ݼ���ΪҪ������
#echo $reboot

if [ $index_reboot = 1 -a "$reboot" != "" ]; then 
	adb reboot
	echo "rebooting..."
fi

