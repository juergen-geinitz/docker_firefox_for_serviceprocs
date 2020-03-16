#!/bin/sh

tmp_file=$(tempfile 2>/dev/null) || tmp_file=/tmp/test$$
trap "rm -f $tmp_file" 0 1 2 5 15

setjavato () {
	case $1 in
	0)
		L=/usr/java/jre/lib/i386/libnpjp2.so
		;;
	6)
		L=/usr/java/jdk1.6.0_45/jre/lib/i386/
		;;
	7)
		L=/usr/java/jdk1.7.0_80/jre/lib/i386/
		;;
	8)
		L=/usr/java/jre1.8.0_131/lib/i386/
		;;
	esac
	/bin/rm /usr/lib/mozilla/plugins/libnpjp2.so
	ln -s ${L}/libnpjp2.so /usr/lib/mozilla/plugins
}
#
dialog --menu "Firefox java version plugin selector" \
	15 72 \
	5 \
	"0" "default jre(for DRAC8)" \
	"6" "java version 6" \
	"7" "java version 7 (for DRAC7)" \
	"8" "java version 8" \
	2> $tmp_file
case $? in
	0)
		setjavato $(cat $tmp_file)
		;;
	1)	echo "cancelled"
		;;
	255)
		echo "ESC pressed"
		;;
	*)
		echo "error"
		;;
esac

echo "starting firefox"
firefox 
