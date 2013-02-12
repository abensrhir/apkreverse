#!/bin/bash
# declare STRING variable
CURRENT_DIR="`dirname $0`"
NETWORK_IP="`/sbin/ifconfig|grep inet|head -1|sed 's/\:/ /'|awk '{print $3}'`"
LIB_FOLDER="./lib/"
APK_TO_REVERSE=$1

##############################################
PRIVOXY_CHECK_BIN="`which privoxy`"
PRIVOXY_CMD="/etc/init.d/privoxy start"
PRIVOXY_LOGFILE="/var/log/privoxy/logfile"
##############################################
APKTOOL_BIN="./lib/apktool/apktool"
DEX2JAR_BIN="./lib/dex2jar/dex2jar.sh"
JD_GUI="./lib/jdgui/jd-gui"
###############################################
#echo "Trying to reverse $APK_TO_REVERSE ..."
#
function ChmodLib
{
	`find $LIB_FOLDER -type f -exec chmod 755 {} \;`
}
function Welcome 
{
	echo -ne """

 _______  _____  _     _  ______ _______ _    _ _______  ______ _______ _______
 |_____| |_____] |____/  |_____/ |______  \  /  |______ |_____/ |______ |______
 |     | |       |    \_ |    \_ |______   \/   |______ |    \_ ______| |______
                                                                               
------------------------------------------------------
Android Reverse Engineering Boilerplate v 0.1
Written by : Anass Bensrhir
License : GPL v 3.0
Credit : Apktool : 
		 dex2jar :
		 jdgui   :
Usage : 
	"""
}

function Openjar 
{
	jarfile=$1
	if [ -f $jarfile -a -r $jarfile ]
		then
		echo "running $jarfile with JD-gui."
		JD-GUI $jarfile
	elif [ ! -e $apkfile ]
		then
		echo "there is no $jarfile jar file "
	else
		echo "FATAL ERROR !"
	fi
}

function Unpackapk 
{
	apkfile=$1
	apkdir=${apkfile%.*}"/"
	if [ -f $apkfile -a -r $apkfile ]
		then
		echo "Unpacking $apkfile ..."
		`$APKTOOL_BIN "decode" $apkfile $apkdir`
	elif [ ! -e $apkfile ]
		then
		echo "there is no $apkfile file"
	else
		echo "FATAL ERROR !"
	fi
}

function Decompileapk
{
	apkfile=$1
	dex2jarfile=$apkfile".dex2jar.jar"
	if [ -f $apkfile -a -r $apkfile ]
		then
		echo "Decompiling $apkfile ..."
		"`$DEX2JAR_BIN $apkfile`"
	elif [ ! -e $apkfile ]
		then
		echo "there is no $apkfile file"
		exit
	else
		echo "FATAL ERROR !"
		exit
	fi
	Openjar $dex2jarfile
}

function RunPrivoxy
{
	if [ -z "$PRIVOXY_CHECK_BIN" ]
		then
		echo "Privoxy isnt installed - exit"
		exit
	else
		`$PRIVOXY_CMD`
		echo "running Privoxy with default configuration"
	fi

	echo "Privoxy is running on $NETWORK_IP:8118 , logile : $PRIVOXY_LOGFILE"
	echo "please add this proxy to your android network settings to let privoxy sniff network traffic"
}

function main
{
	Welcome
}
