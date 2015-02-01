#!/bin/bash
export PATH=$PATH:/sbin
filename='service.txt'
filelines=`cat $filename`
APP_DIR=
body=""
tag="safe"
hostIp=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
for line in $filelines ;
do
       if ps ax | grep -v grep | grep $line > /dev/null
       then
           echo "$line service running, everything is fine"
           timestampContainer="$line.txt"
           ts=`cat $timestampContainer`
           if (($ts > 0 ));then
		mailBody="$line service started again !!"
		echo -e $mailBody | mail -s "$hostIp Service report " "yourmail@gmail.com" 
                cat /dev/null > $timestampContainer
		echo 0 >> $timestampContainer
           else
		echo "$line service running, everything is fine"
           fi
       else
           echo "$line is not running"
	   tag="unsafe"
	   body+="\n$line is not running!"
	   timestamp=$(date +%s)
           timestampContainer="$line.txt"
           cat /dev/null > $timestampContainer
	   echo $timestamp >> $timestampContainer
    	   #echo "$SERVICE is not running!" | mail -s "$SERVICE down" root
fi

done

if [ "$tag" == "unsafe" ];then
    echo -e $body | mail -s "$hostIp Service report "  "yourmail@gmail.com" 
fi

echo $body
