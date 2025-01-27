# Specify the exact version of the previous image (e.g., if building v5, this should point to v4).
# This serves as the trusted base image for the current build.
ARG TRUSTED_PREVIOUS_IMAGE

#build v0.5.0
FROM golang:1.23-bookworm as upgrade-v0-5-0
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    git \
    && apt-get clean
WORKDIR /root
# Make binaries
# in this version, the binary released as v0.5.0 is actually v0.5.0.1 and commit hash is ac043ff438140fea68650c373bf19e1aea26e2f5
# as there is not a assosiated tag or brnach for this version, we have to mannually checkout into that commit
RUN git clone -b dev https://github.com/0glabs/0g-chain.git
WORKDIR 0g-chain
RUN git checkout ac043ff438140fea68650c373bf19e1aea26e2f5
RUN make build-release LINK_STATICALLY=true

FROM ${TRUSTED_PREVIOUS_IMAGE} AS runtime
COPY --chown=zerog:zerog --from=upgrade-v0-5-0 /root/0g-chain/out/linux/0gchaind $DAEMON_HOME/cosmovisor/upgrades/v0.5.0/bin/
