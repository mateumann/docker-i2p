GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))

DOCKER_IMAGE ?= mateumann/i2p
DOCKER_TAG = latest

# Build Docker image
build: docker_build output

# Build and push Docker image
release: docker_build docker_push output

default: docker_build_squash output

docker_build_squash:
	DOCKER_BUILDKIT=1 \
	docker build \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VCS_REF=$(GIT_COMMIT) \
		--squash \
		-t $(DOCKER_IMAGE):$(GIT_COMMIT) .
	docker tag $(DOCKER_IMAGE):$(GIT_COMMIT) $(DOCKER_IMAGE):$(DOCKER_TAG)

docker_build:
	DOCKER_BUILDKIT=1 \
	docker build \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VCS_REF=$(GIT_COMMIT) \
		-t $(DOCKER_IMAGE):$(GIT_COMMIT) .
	docker tag $(DOCKER_IMAGE):$(GIT_COMMIT) $(DOCKER_IMAGE):$(DOCKER_TAG)

docker_push:
	docker tag $(DOCKER_IMAGE):$(GIT_COMMIT) $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)

