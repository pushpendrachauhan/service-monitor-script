#!/bin/bash
export PATH=$PATH:/sbin
APP_DIR=
body=""
tag="safe"
hostIp=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

filename=<Path to RUNNING_PID>
pline="play"
isRead="false"
filelines=`cat $filename`
for line in $filelines ;
do
	if (($line > 0 ));then
		isRead="true"
		echo $line 
		echo "play is running"
		if ps -p $line > /dev/null
		then
   			echo " play is running"
   			# Do something knowing the pid exists, i.e. the process with $PID is running

           		timestampContainer="$pline.txt"
          		ts=`cat $timestampContainer`
          		if (($ts > 0 ));then
				mailBody="$pline service started again !!"
				echo -e $mailBody | mail -s "$hostIp Service report " "Yourmail@gmail.com" 
                		cat /dev/null > $timestampContainer
				echo 0 >> $timestampContainer
  	    		else
				echo "$pline service running, everything is fine"
           		fi
		else 
			echo "play is not running"
			tag="unsafe"
			body+="\n play is not running!"
	   		timestamp=$(date +%s)
           		timestampContainer="$pline.txt"
           		cat /dev/null > $timestampContainer
	   		echo $timestamp >> $timestampContainer
		fi
	else
		isRead="true"
		tag="unsafe"
		
		echo  "play is not runing"
		body+="\n play is not running!"
		timestamp=$(date +%s)
           	timestampContainer="$pline.txt"
           	cat /dev/null > $timestampContainer
	   	echo $timestamp >> $timestampContainer
	fi
done
if [ "$isRead" == "false" ];then
   tag="unsafe"
   body+="\n play is not running!"
fi

if [ "$tag" == "unsafe" ];then
    echo -e $body | mail -s "$hostIp Service report "  "Yourmail@gmail.com" 
fi

echo $body
