#!/bin/bash
set -x

runner=bladefox
docker images bladefox|grep -q bladefox
if [ $? -eq 1 ]
then
    runner=bladecenter
    docker images bladecenter|grep -q bladecenter
    if [ $? -eq 1 ]
    then
	if [ -f Dockerfile -a -f docker-firefox.sh -a -f jre-8u131-linux-i586.tar.gz ]
	then
		docker build . --tag bladecenter
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

docker run --detach -it \
	--publish 30000:14500 \
	--user "0:0" \
	--volume ${HOME}/tmp:/home/user:rw \
	--volume ${HOME}/tmp:/home/Downloads:rw \
	--env XPRA_EXTRA_ARGS="--tcp-auth= --tcp-encryption=" \
	--env HOME=/home \
	"${dri_devices[@]}" \
	--volume /etc/localtime:/etc/localtimeXX:ro \
	--volume /etc/timezone:/etc/timezoneXX:ro \
	$runner "$@"

while ! nc -z 172.30.200.2 30000 ; do
	sleep 1
	echo "$0: waiting for a running fox"
done

exec xpra attach tcp:172.30.200.2:30000
