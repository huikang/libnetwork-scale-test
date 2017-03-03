#! /bin/bash

# The number of dnet containers to be emualted
start=71
end=71

# libnetwork binary location on the host
libnetwork_dir="/go/src/github.com/huikang/libnetwork/"

function inst_id2port() {
    echo $((49000+${1}-1))
}

function check_host() {
    if [ -f "${libnetwork_dir}/bin/dnet" ];
    then
	echo "The dnet binary exists ${libnetwork_dir}"
    else
	echo "Can not find binary exists ${libnetwork_dir}"
	exit 1
    fi
}

check_host

for i in `seq ${start} ${end}`;
do

    port=$(inst_id2port ${i})
    echo dnet-${i}-multi_consul $port
    # if running all dnet in the same host use -p ${port}:2385
    #    otherwise use --network ov-host
    docker run -d --hostname=dnet-${i}-multi-consul --name=dnet-${i}-multi_consul \
	   --privileged -p ${port}:2385 \
	   -v ${libnetwork_dir}:${libnetwork_dir} \
	   -w ${libnetwork_dir} \
	   mrjana/golang \
	   ./bin/dnet -d -D -c ./libnetwork-dnet-consul.toml
    sleep 2
done
