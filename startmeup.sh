#!/bin/bash -x
#
if [ "x$1" = "xexecutor" ]
then
	export LD_PRELOAD=""
	xterm&xterm&xterm&
	exec /bin/bash -li
	echo "HOW DID YOU GET HERE?"
fi
cp /etc/resolvA.conf /etc/resolv.conf
LD_PRELOAD=""
export LD_PRELOAD
for certDB in $(find /home -name cert8.db -print)
do
	certdir=$(dirname $certDB)
	certutil -A -n "DENIC - Denic e.G." -t "c,c,c"  -i /root_CA.pem -d $certdir
	certutil -A -n "Infrastructure Services - Denic e.G." -t "CT,C,C"  -i /infs_CA.pem -d $certdir
done
xpra start \
	--exit-with-children \
	--start-new-commands=yes \
	--daemon=no \
	--start-child="xterm -e /startmeup.sh executor" \
	--bind-tcp=0.0.0.0:30000 \
	--pulseaudio=no \
	--clipboard=yes \
	--opengl=no \
	--dpi=96  \
	--input-method=xim
#	--input-method=keep
#	--input-method=IBus
#	--input-method=SCIM
#	--input-method=uim 
#xpra start \
#	--exit-with-children \
#	--start-new-commands=yes \
#	--daemon=no \
#	--start-child="firefox file:///index.html" \
#	--bind-tcp=0.0.0.0:30000 \
#	--pulseaudio=yes \
#	--clipboard=yes \
#	--opengl=no \
#	--dpi=100  \
#	--input-method=uim 
#for certDB in $(find /home -name cert8.db -print)
#do
#	certdir=$(dirname $certDB)
#	certutil -A -n "DENIC - Denic e.G." -t "c,c,c"  -i /root_CA.pem -d $certdir
#	certutil -A -n "Infrastructure Services - Denic e.G." -t "CT,C,C"  -i /infs_CA.pem -d $certdir
#done
#bash -l
