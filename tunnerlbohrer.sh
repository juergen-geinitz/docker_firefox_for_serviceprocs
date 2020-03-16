#!/bin/bash -x
#
#
#
Xside=""
Lside=""
DESTDRAC=172.16.102.24
HOP1HOST=x11230
HOP2HOST=dope-1.tt3
HOP1USER=juergen1
HOP2USER=root
#
tmp_file=$(tempfile 2>/dev/null) || tmp_file=/tmp/test$$
trap "rm -f $tmp_file ${tmp_file}2" 0 1 2 5 15

#
inputbox() {
	dialog --backtitle "$1" --inputbox "$2" 8 52 "$3" 2>${tmp_file}2
}

#
mainmenu() {
    ready=0
    while [ $ready -ne 1 ]
    do
	dialog \
		--backtitle "Tunneleinstellungen" \
		--cancel-label "Quit" \
		--title " Main" \
		--menu "Auswahlt mir [UP] [DOWN] -- [ENTER]" 17 60 6 \
		quit        "Fertig" \
		controlserver "Controllserver (${HOP1HOST})" \
		controluser "Benutzer auf Controllserver (${HOP1USER})" \
		portserver  "Portserver in Location (${HOP2HOST})" \
		portuser    "Benutzer auf Portserver (${HOP2USER})" \
		serviceproc "ZIEL Serviceprozessor (${DESTDRAC})" \
		2>${tmp_file}
	if [ $? != 0 ]
	then
		exit 1
	fi
	case $(cat ${tmp_file}) in
		controlserver) inputbox "controlserver" "Eingabe controlserver" ${HOP1HOST}
			HOP1HOST=$(cat ${tmp_file}2)
			;;
		controluser) inputbox "username auf cotrolserver" "username:" ${HOP1USER}
			HOP1USER=$(cat ${tmp_file}2)
			;;
		portserver) inputbox "Server in der Location" "Eingabe hostname or ip" ${HOP2HOST}
			HOP2HOST=$(cat ${tmp_file}2)
			;;
		portuser) inputbox "Username auf portserver" "Eingabe user" $HOP2USER
			HOP2USER=$(cat ${tmp_file}2)
			;;
		serviceproc) inputbox "Serviceprozessort bzw. System under test" "hostname oder IP" $DESTDRAC
			DESTDRAC=$(cat ${tmp_file}2)
			;;
		quit) ready=1 ;;
		*) echo "unknown $(cat ${tmp_file})"
			;;
	esac
    done
}

infobox() {
	dialog --msgbox \
"           You may now use
    http://localhost/ , https://localhost/
            or 
    ssh localhost -p 2222
             to connect to $DESTDRAC
All tunnels will shutdown by the end of this shell" 10 72
}
#
mainmenu
#
for i in 443 22 23 80 161 3668 5869 5900 5901
do
	j=$i
	if [ $i -eq 22 ]
	then
		j=2222
	fi
	Lside="${Lside} -L ${j}:${DESTDRAC}:${i}"
done
infobox
ssh -t -J ${HOP1USER}@${HOP1HOST} -l $HOP2USER $HOP2HOST $Lside

