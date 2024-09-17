#!/bin/bash

#This script is created for server health checkup


#Define thresholds
CPU_THRESHOLD=80
DISK_THRESHOLD=80
EMAIL="singhvikas180196@gmail.com"
HOSTNAME=$(hostname)

#Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
cpu_usage=${cpu_usage%.*}
#echo "$cpu_usage"



#Get mem usage
mem_usage=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')
#echo "$mem_usage"


#Get Disk usgae
disk_usage=$(df -h / | grep '/'| awk '{print $5}' | sed 's/%//g')
#echo "$disk_usage"

#Get network stats
network_stats=$(netstat -ant | grep ESTABLISHED | wc -l )


#Generate report
report="
Server Health Report for $HOSTNAME

+++++++++++++++++++++++++++++++++++++++++++++++

CPU Usage: $cpu_usage%
Memory Usage: $mem_usage%
Disk Usage: $disk_usage%
Active Network Connection: $network_stats

++++++++++++++++++++++++++++++++++++++++++++++"

echo "$report"


#Send alert if CPU or Disk usage exceed threshold
if [ "$cpu_usage" -gt "$CPU_THRESHOLD" ]; then
	echo "ALERT: CPU Usage is above threshold ($cpu_usage%)"  | mail -s "CPU alert for $HOSTNAME" "$EMAIL"
fi

if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
	echo "ALERT: Disk usage is above threshold ($disk_usage%)" | mail -s "Disk alert for $HOSTNAME" "$EMAIL"
fi

