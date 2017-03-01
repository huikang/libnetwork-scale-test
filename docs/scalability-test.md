Scalability Test for Libnetwork
===================

![](/docs/architecture.png?raw=true)

To prepare the hosts (either physical or virtual machine), a docker swarm cluster is formed as shown in the figure.

 1. Two physical machines (`h1` and `h2`) run docker engine in the swarm mode.
 2. An overlay network named `ov-host` is created for the two docker swarm nodes.

Run the following command on `h1`:

     docker network create --driver overlay --attachable --subnet 11.0.8.0/24 ov-host


On these two hosts, we can emulate a much *larger* network control plane by creating many libnetwork agents in containers.

 1. A consul KV store is created. As many as libnetwork agents are created as `dnet` containers on the two hosts.
 2. The dnet containers form a control plane by registering themselves to the consul KV store.
 3. An overlay network named `ov-emu` is created for the emulated control plane.
 4. In each emulated libnetwork agent (i.e., `dnet-`), we can create network ns and attach to `ov-emu`.


First, we need to start a consul container:

```shell
 docker run -d  \
        --name=pr_consul \
        -h consul \
        --network ov-host \
        progrium/consul \
        -server -bootstrap
 ```

 Create 3 libnetwork agent containers:

 ```shell
 docker run -d --hostname=dnet-1-multi-consul --name=dnet-1-multi_consul \
      --privileged --network ov-host \
      -v /go/src/github.com/huikang/libnetwork/:/go/src/github.com/huikang/libnetwork \
      -w /go/src/github.com/huikang/libnetwork \
      mrjana/golang \
      ./bin/dnet -d -D -c ./libnetwork-dnet-consul.toml

 docker run -d --hostname=dnet-2-multi-consul --name=dnet-2-multi_consul \
      --privileged --network ov-host \
      -v /go/src/github.com/huikang/libnetwork/:/go/src/github.com/huikang/libnetwork \
      -w /go/src/github.com/huikang/libnetwork \
      mrjana/golang \
      ./bin/dnet -d -D -c ./libnetwork-dnet-consul.toml

 docker run -d --hostname=dnet-3-multi-consul --name=dnet-3-multi_consul \
      --privileged --network ov-host \
      -v /go/src/github.com/huikang/libnetwork/:/go/src/github.com/huikang/libnetwork \
      -w /go/src/github.com/huikang/libnetwork \
      mrjana/golang \
      ./bin/dnet -d -D -c ./libnetwork-dnet-consul.toml
 ```

To test the control plane, create an overlay network and attach containers to the network.

 ```shell
 docker exec -it dnet-3-multi_consul bash

 ./bin/dnet -H tcp://127.0.0.1:2385 network create -d overlay multihost

 ./bin/dnet -H tcp://127.0.0.1:2385 container create container_2
 ./bin/dnet -H tcp://127.0.0.1:2385 service publish srv_2.multihost
 ./bin/dnet -H tcp://127.0.0.1:2385 service attach container_2 srv_2.multihost
 ```
