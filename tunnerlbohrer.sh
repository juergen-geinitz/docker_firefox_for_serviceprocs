#!/bin/bash -x
#
Xside=""
Lside=""
DESTDRAC=172.16.102.24
HOP1HOST=x11230
HOP2HOST=dope-1.tt3
HOP1USER=juergen1
HOP2USER=root
#
for i in 443 22 23 80 161 3668 5869 5900 5901
do
	j=$i
	if [ $i -eq 80 ]
	then
		j=8080
	fi
	if [ $i -eq 22 ]
	then
		j=2222
	fi
	Lside="${Lside} -L ${j}:${DESTDRAC}:${i}"
done
ssh -t -J ${HOP1USER}@${HOP1HOST} -l $HOP2USER $HOP2HOST $Lside

