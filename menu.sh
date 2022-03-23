#!/bin/bash
option1() {
echo '+-+-+-+-+-+-+-+-+-+-+-+-+'
DWN=0
echo "Enter Valid Class C IP Address"
read IP
if [[ $IP =~ ^(19[2-9]|2[0-1][0-9]|22[0-3])(\.([0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$ ]]
then echo "IP Is A Valid Class C IP Address...Commencing Scan"
ping -q -c 1 $IP > IPSHEET
PL=$(awk '/received/ {print $4}' IPSHEET)
if [ "$PL" = "$DWN" ]
then echo "$IP is down"
else echo "$IP is up"
fi
else echo "That IP Was Not A Valid Class C IP....Try Harder"
exit
fi
echo '+-+-+-+-+-+-+-+-+-+-+-+-+'
main
}
option2() {
echo '+-+-+-+-+-+-+-+-+-+-+-+-+'
IPlist=$(sudo arp-scan -l | sed '1,2d' | sed '$d' | sed '$d' | sed '$d' | awk '{print$1}' > /home/kali/Desktop/ARPing.txt)
date

echo "Scanning IPs"
cat /home/kali/Desktop/ARPing.txt | while read output
do
    ping -c 1 "$output" > /dev/null
    if [ $? -eq 0 ]; then
    echo "node $output is up"
    else
    echo "node $output is down"
    fi
done
echo '+-+-+-+-+-+-+-+-+-+-+-+-+'
main
}
option3() {
echo '+-+-+-+-+-+-+-+-+-+-+-+-+'
main(){
echo "input first octet" 
read f
echo "input second octet"
read g
echo "input third octet"
read h
if [ $f -le 225 ]
then echo "."
else echo "octet 1 bad" && 
main
fi
if [ $f -ge 192 ]
then echo ".."
else echo "octet 1 bad" && 
main
fi 
if [ $g -le 255 ]
then echo "..."
else echo "octet 2 bad" && 
main
fi
if [ $g -ge 0 ]
then echo "...."
else echo "octet 2 bad" && 
main
fi 
if [ $h -le 255 ]
then echo "....."
else echo "octet 3 bad" && 
main
fi
if [ $h -ge 0 ]
then echo "......"
else echo "octet 3 bad" && 
main
fi 
for i in {1..254} do;
{
(ping -c 3 -l 3 -W 0.2 $f.$g.$h.$i) &>/dev/null && echo "$f.$g.$h.$i is up"
}
}
main
exit
echo '+-+-+-+-+-+-+-+-+-+-+-+-+'
main
}
Quit() {
echo '+-+-+-+-+-+-+-+-+-+-+-+-+'
echo "User request exit"
echo '+-+-+-+-+-+-+-+-+-+-+-+-+'
exit
}

main() {
echo '====================================='
	echo "1) Check for a computer using a valid IPv4 address"
	echo "2) Use arp to ping hosts"
	echo "3) Scan /24 Range for Class C Network"
	echo "4) Quit"
echo '====================================='
	read -r -n 1 -s -p "choose: " choice
	case $choice in
	1)
		clear
		option1
;;
	2)
		clear
		option2
;; 
	3)
		clear
		option3
;;
	4)
		clear
		Quit
;;

	*)
		echo "invalid option $REPLY"
		clear 
		main
;;
	esac
}

main
exit
