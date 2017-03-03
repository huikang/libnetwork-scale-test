#! /bin/bash
#set -e

# start sequence of the network name
first=1
last=1
# size of endpoint in each network
size=1

# run command from a sequence of container
dnet_start=1
dnet_end=70
# or from a single container
dnet_name=dnet-1-multi_consul

function attach_sandbox() {
    local start end
    network_name=$1
    start=${dnet_start}
    end=${dnet_end}
    for i in `seq ${start} ${end}`
    do
	time docker exec dnet-${i}-multi_consul ./bin/dnet -H tcp://127.0.0.1:2385 service publish srv_${i}.${network_name}
	echo "created service srv_${i}.${network_name}"
	time docker exec dnet-${i}-multi_consul ./bin/dnet -H tcp://127.0.0.1:2385 container create ${i}_${network_name}
	echo "created sandbox container_${i}_${network_name}"

	time docker exec dnet-${i}-multi_consul ./bin/dnet -H tcp://127.0.0.1:2385 service attach ${i}_${network_name} srv_${i}.${network_name}
	echo "Attach srv_${i}.${network_name} to ${i}_${network_name}"
    done
}

for i in `seq ${first} ${last}`
do
    netname=mh_${i}
    echo "create overlay network ${netname}"
    echo "create overlay network ${netname}" >> output_file
    docker exec ${dnet_name} ./bin/dnet -H tcp://127.0.0.1:2385 network create -d overlay ${netname}
    output=$( { time attach_sandbox ${netname}; } 2>&1 )
    echo "$output" >> output_file
done
