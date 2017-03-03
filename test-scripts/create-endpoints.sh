#! /bin/bash
set -e

# start sequence of the network name
first=6
last=10
# size of endpoint in each network
size=100

function create_endpoint() {
    local start end
    network_name=$1
    start=1
    for i in `seq ${start} ${size}`
    do
	./bin/dnet -H tcp://127.0.0.1:2385 service publish srv_${i}.${network_name}
	echo "created service srv_${i}.${network_name}"
    done
}

for i in `seq ${first} ${last}`
do
    echo "create overlay network multihost_${i}"
    ./bin/dnet -H tcp://127.0.0.1:2385 network create -d overlay multihost_${i}
    output=$( {  time create_endpoint multihost_${i}; } 2>&1 )

    echo $output
    echo "$output" >> output_file
done
