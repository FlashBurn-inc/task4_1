#!/usr/bin/env bash

	#font
	n=$(tput sgr0);
	bold=$(tput bold);

	#Hardware
	cpu=$(cat /proc/cpuinfo | grep "model name" | awk -F: 'FNR==1{print $2}');
	ram=$(free -h | awk 'FNR == 2{print $2}');
	#motherboard
	board=$(dmidecode -s baseboard-product-name);
	#serial number
	sn=$(dmidecode -s system-serial-number);
	#System
	os=$(lsb_release -a 2>/dev/null | grep Description | awk -F: '{print $2}');
	kernelv=$(uname -r);
	#install date
	installo=$(installd=$(LANG=en_US ls -lct /etc | tail -1 | awk '{print $8}')
			if [[ "$installd" == *:* ]];
			then echo "$(LANG=en_US ls -lct /etc | tail -1 | awk '{print $6,$7}') $(LANG=en_US date | awk '{print$6}')";
			else echo "$(LANG=en_US ls -lct /etc | tail -1 | awk '{print $6,$7,$8}')";
			fi);
	hostname=$(hostname -f);
	#uptime
	uptime=$(uptime -p | sed 's/up //g');

	proc=$(ps -e h | wc -l);
	actu=$(w -h | wc -l);
	#Output
path=$(echo $0 | sed -r 's/task4_1.sh//g')
        if [[ $path != /* && $path != .* ]];
        then
                way=$(echo "$PWD/$path")
        elif [[ $path == .* ]]
        then
                z=$(echo "$path" | sed 's/.\///')
                way=$(echo "$PWD/$z")
        else
                way=${path:-"$PWD"/}
        fi

exec 1>"$way"task4_1.out
echo  ${n}"--- Hardware ---";
echo  ${bold}"CPU:"${n} $(echo $cpu);
echo  ${bold}"RAM:"${n} $(echo $ram);
echo  ${bold}"Motherboard:"${n} $(echo ${board:-Unknown});
echo  ${bold}"System Serial Number:"${n} $(echo ${sn:-Unknown});
echo  ${n}"--- System ---";
echo  ${bold}"OS Distribution:"${n} $(echo $os);
echo  ${bold}"Kernel version:"${n} $(echo $kernelv);
echo  ${bold}"Installation date:"${n} $(echo $installo);
echo  ${bold}"Hostname:"${n} $(echo ${hostname:-$(hostname -s)});
echo  ${bold}"Uptime:"${n} $(echo $uptime);
echo  ${bold}"Processes running:"${n} $(echo $proc);
echo  ${bold}"User logged in:"${n} $(echo $actu);
echo  ${n}"--- Network ---";
        #int ip
	intc=$(ip -br addr | awk '{print $1}' | wc -l);
        for ((i = 1; i <= intc; i++))
        do
		int=$(ip -br addr | awk 'FNR=='$i'{print $1}');
		c=3
		unset ipa
		ip=$(ip -br addr |awk 'FNR=='$i'{print $'$c'}')
                	if [[ ${#ip} != 0 && $ip != *:* ]];
			then
				while [[ ${#ip} != 0 && $ip != *:* ]]
				do
				ipa="$ipa $ip,"
				c=$(($c+1))
				ip=$(ip -br addr | awk 'FNR=='$i'{print$'$c'}')
				done
				echo ${bold}"$int:"${n} $(echo "$ipa" | sed -r 's/,$//g')
			else
			echo ${bold}"$int:"${n} $(echo "-")
			fi
	done
