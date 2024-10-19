FROM golang:1.23-bookworm as genesis-builder
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    git \
    && apt-get clean

WORKDIR /root

# Install Cosmovisor
RUN go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.6.0
# Make Genesis binaries
RUN git clone -b v0.2.5 https://github.com/0glabs/0g-chain.git
WORKDIR 0g-chain
RUN make install

#build v0.3.0 binary
FROM golang:1.23-bookworm as upgrade-v0-3-0
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    git \
    && apt-get clean
WORKDIR /root
# Make binaries
RUN git clone -b v0.3.0 https://github.com/0glabs/0g-chain.git
WORKDIR 0g-chain
RUN make build-release LINK_STATICALLY=true

#build v0.3.1.alpha.1 binary
FROM golang:1.23-bookworm as upgrade-v0-3-1-alpha-1
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    git \
    && apt-get clean
WORKDIR /root
# Make binaries
RUN git clone -b v0.3.1.alpha.1 https://github.com/0glabs/0g-chain.git
WORKDIR 0g-chain
RUN make build-release LINK_STATICALLY=true

#build v0.4.0
FROM golang:1.23-bookworm as upgrade-v0-4-0
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    git \
    && apt-get clean
WORKDIR /root
# Make binaries
RUN git clone -b v0.4.0 https://github.com/0glabs/0g-chain.git
WORKDIR 0g-chain
RUN make build-release LINK_STATICALLY=true

FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y \
    curl \
    nano \
    jq \
    dnsutils \
    wget \
    unzip \
    lz4 \
    git \
    iputils-ping \
    iproute2 \
    && apt-get clean

# Create user zerog
RUN useradd -m zerog
USER zerog
WORKDIR /home/zerog

# Set Cosmovisor env variables
ENV DAEMON_NAME=0gchaind
ENV DAEMON_HOME=/home/zerog/.0gchain
ENV DAEMON_ALLOW_DOWNLOAD_BINARIES=true
ENV DAEMON_RESTART_AFTER_UPGRADE=true
ENV UNSAFE_SKIP_BACKUP=true

RUN mkdir -p $DAEMON_HOME/cosmovisor/genesis/bin
RUN ln -s $DAEMON_HOME/cosmovisor/genesis $DAEMON_HOME/cosmovisor/current

ENV PATH=$PATH:$DAEMON_HOME/cosmovisor/current/bin

COPY --chown=zerog:zerog --from=genesis-builder /go/bin/cosmovisor /usr/local/bin/
COPY --chown=zerog:zerog --from=genesis-builder /go/bin/0gchaind $DAEMON_HOME/cosmovisor/genesis/bin/
COPY --chown=zerog:zerog --from=upgrade-v0-3-0 /root/0g-chain/out/linux/0gchaind $DAEMON_HOME/cosmovisor/upgrades/v0.3.0/bin/
COPY --chown=zerog:zerog --from=upgrade-v0-3-1-alpha-1 /root/0g-chain/out/linux/0gchaind $DAEMON_HOME/cosmovisor/upgrades/v0.3.1/bin/
COPY --chown=zerog:zerog --from=upgrade-v0-4-0 /root/0g-chain/out/linux/0gchaind $DAEMON_HOME/cosmovisor/upgrades/v0.4.0/bin/

# workaround to https://github.com/cosmos/cosmos-sdk/issues/20947
RUN mkdir -p $DAEMON_HOME/data $DAEMON_HOME/config $DAEMON_HOME/keyring-test

ENTRYPOINT ["/usr/local/bin/cosmovisor"]
CMD ["--help"]