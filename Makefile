# BigFred OS — top-level build entrypoints

.PHONY: image image-using-docker docker-image

DOCKER_IMAGE ?= bigfred-hub-os-build
DOCKER_DIR   := $(abspath docker)
# Match host ownership of os/output/ (override: make image-using-docker DOCKER_UID=$(id -u))
DOCKER_UID   ?= 1000
DOCKER_GID   ?= 1000

image:
	$(MAKE) -C os image

docker-image:
	docker build -t $(DOCKER_IMAGE) -f $(DOCKER_DIR)/Dockerfile $(DOCKER_DIR)

image-using-docker: docker-image
	docker run --rm \
		-u $(DOCKER_UID):$(DOCKER_GID) \
		-v "$(CURDIR):/work" \
		-w /work \
		-e HOME=/work \
		-e MAKEFLAGS="-j$$(nproc 2>/dev/null || echo 4)" \
		$(DOCKER_IMAGE) \
		make image
