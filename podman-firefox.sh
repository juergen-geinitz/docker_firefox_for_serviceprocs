#!/bin/bash
set -x

DOCKER=podman
if [ ! -x /usr/bin/xpra ]
then
	echo "${0}: sorry - need a program named xpra"
	exit 1
fi
if [ ! -x $(which $DOCKER) ]
then
	echo "${0}: sorry - need a program named docker"
	exit 2
fi
rc=$($DOCKER ps >/dev/null 2>&1)
if [ $? -ne 0 ]
then
	echo "${0}: cannot connect to $DOCKER envirnoment"
	exit 3
fi

runner=bladefox
$DOCKER images bladefox|grep -q bladefox
if [ $? -eq 1 ]
then
    runner=bladecenter
    $DOCKER images bladecenter|grep -q bladecenter
    if [ $? -eq 1 ]
    then
	if [ -f Dockerfile -a -f docker-firefox.sh -a -f jre-8u131-linux-i586.tar.gz ]
	then
		$DOCKER build . --tag bladecenter
	else
		echo "${0}: missing files - cannot build container"
		exit 4
	fi
    fi
fi
#declare -a dri_devices
#for d in `find /dev/dri -type c` ; do
#	dri_devices+=(--device "${d}")
#done

docker_address="$(ip address show dev docker0 | grep 'inet ' | awk '{print$2}' | cut -d/ -f1)"

if [ ! -d ${HOME}/tmp ]
then
	mkdir ${HOME}/tmp
fi

$DOCKER run -idt --rm -P \
	--publish 30001:30000 \
	--user "0:0" \
	--volume ${HOME}/tmp:/home/user:rw \
	--volume ${HOME}/tmp:/home/Downloads:rw \
	--env XPRA_EXTRA_ARGS="--tcp-auth= --tcp-encryption=" \
	--env HOME=/home \
	"${dri_devices[@]}" \
	--volume /etc/localtime:/etc/localtimeXX:ro \
	--volume /etc/timezone:/etc/timezoneXX:ro \
	$runner "$@"

SLAVEIP=127.0.0.1
while ! nc -z $SLAVEIP 30001 ; do
	sleep 1
	echo "$0: waiting for a running fox"
done

exec xpra attach tcp:127.0.0.1:30001
