# Specify the exact version of the previous image (e.g., if building v5, this should point to v4).
# This serves as the trusted base image for the current build.
ARG TRUSTED_PREVIOUS_IMAGE
FROM golang:1.23-bookworm as upgrade
ARG NODE_TAG
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    git \
    && apt-get clean
WORKDIR /root
# Make binaries
RUN git clone -b $NODE_TAG https://github.com/0glabs/0g-chain.git
WORKDIR 0g-chain
RUN make build-release LINK_STATICALLY=true

FROM ${TRUSTED_PREVIOUS_IMAGE} AS runtime
ARG NODE_TAG
COPY --chown=zerog:zerog --from=upgrade /root/0g-chain/out/linux/0gchaind $DAEMON_HOME/cosmovisor/upgrades/$NODE_TAG/bin/
