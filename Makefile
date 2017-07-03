.PHONY: all
build_image=dnet-image
dnet_container=dnet

all: images

images: dnet-img
	@echo "+ $@"

dnet-img:
	@echo "+ $@"
	docker build  -t ${build_image} -f Dockerfile .

dnet-run:
	@echo "+ $@"
	docker run -d --hostname=dnet --name=${dnet_container} \
		--privileged -p 41000:2385 -e _OVERLAY_HOST_MODE \
		${build_image}

push-img:
	@echo "+ $@"
	docker tag ${build_image} huikang/${build_image}
	docker push huikang/${build_image}

clean:
	@echo "+ $@"
	docker rm -f ${dnet_container}
