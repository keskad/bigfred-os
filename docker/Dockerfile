# Reproducible Buildroot host environment (Ubuntu 24.04 ≈ GitHub Actions runner).
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

COPY install-buildroot-deps.sh /usr/local/bin/install-buildroot-deps.sh
RUN chmod +x /usr/local/bin/install-buildroot-deps.sh \
	&& /usr/local/bin/install-buildroot-deps.sh \
	&& apt-get install -y --no-install-recommends golang-go \
	&& rm -rf /var/lib/apt/lists/* \
	&& groupadd -g 1000 builder \
	&& useradd -u 1000 -g 1000 -d /work -M -s /bin/bash builder \
	&& mkdir -p /work \
	&& chown builder:builder /work

WORKDIR /work
USER builder
