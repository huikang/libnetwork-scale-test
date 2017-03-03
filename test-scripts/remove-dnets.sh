#! /bin/bash

start=1
end=100

function inst_id2port() {
    echo $((41000+${1}-1))
}

for i in `seq ${start} ${end}`;
do

    docker rm -f dnet-${i}-multi_consul
done
