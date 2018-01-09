#/bin/bash

#this script is run when the container is started
#optionally adds $CONTAINERKEY to shiny server url by modifying shiny-server.conf
#
#example:
#http://<IP>:<PORT>
#->
#http://<IP>:<PORT>/<CONTAINERKEY>
#
#to use this add the "-e" parameter when starting a container:
#docker run ... -e CONTAINERKEY=${container_key} ...
#example:
#docker run --name='sav1' -d -p 50000:3838 -v '/mnt/agnerds/docker/projects/sav1':'/srv/shiny-server/data' -e CONTAINERKEY=sav1 loosolab/wilson:1.2"
#-> http://<IP>:50000/sav1

conf="/etc/shiny-server/shiny-server.conf"

#create backup of original shiny-server.conf
if [[ ! -f "${conf}.old" ]]; then
	cp ${conf} ${conf}.old
fi

#add parameter(s) at top of .conf
param="preserve_logs true;"
sed -i "1i $param" ${conf}

param="sanitize_errors off;"
sed -i "1i $param" ${conf}

#if environment variable given -> add key to url
if [[ ! -z "$CONTAINERKEY" ]]; then
	CONTAINERKEY=$(echo -e $CONTAINERKEY | sed 's/\//\\\//g')			#to escape "/"
	cat ${conf} | sed "s/location \//location \/$CONTAINERKEY/g" >${conf}.1
	mv ${conf}.1 ${conf}
fi

#start shiny server
shiny-server >/var/log/shiny-server.log
