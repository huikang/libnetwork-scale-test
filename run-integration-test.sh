#! /bin/bash
set -o xtrace

ansible-playbook -i inventory/libnetwork-hosts test.yml --syntax-check
ansible-playbook -i inventory/libnetwork-hosts test.yml -e action=check
ansible-playbook -i inventory/libnetwork-hosts test.yml -e action=deploy

docker images
docker ps

docker exec dnet-1 bash -c "./bin/dnet network create -d overlay multihost"

docker exec dnet-1 bash -c "./bin/dnet network ls"
docker exec dnet-2 bash -c "./bin/dnet network ls"

docker exec dnet-1 bash -c "./bin/dnet container create container_0"
docker exec dnet-2 bash -c "./bin/dnet container create container_1"

docker exec dnet-1 bash -c "./bin/dnet service publish srv_0.multihost"
docker exec dnet-2 bash -c "./bin/dnet service publish srv_1.multihost"

docker exec dnet-1 bash -c "./bin/dnet service attach container_0 srv_0.multihost"
docker exec dnet-2 bash -c "./bin/dnet service attach container_1 srv_1.multihost"

docker exec dnet-1 bash -c "./bin/dnet service ls"

sandboxID=` docker exec dnet-1 bash -c "./bin/dnet service ls" | grep container_0 | grep srv_0 | awk '{ print $5 }' `
echo $sandboxID

docker exec dnet-1 bash -c "mkdir -p /var/run/netns"
docker exec dnet-1 bash -c "touch /var/run/netns/c && mount -o bind /var/run/docker/netns/$sandboxID /var/run/netns/c"
docker exec dnet-1 bash -c "ip netns exec c ip a"

docker exec dnet-1 bash -c "ip netns exec c ping -c 2 10.0.0.3"
if [ $? -ne 0 ]
then
	echo "fail to ping"
	exit 1
fi

docker exec dnet-1 bash -c "ip netns exec c ping -c 2 10.0.3.3"
if [ $? -eq 0 ]
then
	echo "shoudl fail"
	exit 1
fi

ansible-playbook -i inventory/libnetwork-hosts test.yml -e action=clean

sleep 1
docker ps
