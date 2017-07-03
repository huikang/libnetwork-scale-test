FROM golang:1.8.3

RUN apt-get update && apt-get -y install iptables

RUN go get github.com/docker/libnetwork
WORKDIR /go/src/github.com/docker/libnetwork

RUN git checkout ${LIBNETWORK_VERSION}
RUN  make build-local \
     && cp ./bin/dnet /usr/local/bin/

EXPOSE 2385

# Define default command.
CMD ["/usr/local/bin/dnet", "-d", "-D"]
