#! /bin/bash
set -e

first=1
last=10
size=100

function create_network() {
    local start end
    start=$1
    end=$2
    for i in `seq ${start} ${end}`
    do
	./bin/dnet -H tcp://127.0.0.1:2385 network create -d overlay multihost_${i}
	echo "created network multihost_${i}"
    done
}

start=$(($size * ($first - 1) + 1))
for i in `seq ${first} ${last}`
do
    end=$(($size * $i))
    echo "$start to $end"
    output=$( {  time create_network $start $end; } 2>&1 )
    echo $output
    echo "$start to $end" >> output_file
    echo "$output" >> output_file
    start=$(($end + 1))
done
