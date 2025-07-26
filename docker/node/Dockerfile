FROM golang:1.24.3-bookworm as genesis-builder
ARG NODE_TAG
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    wget \
    git \
    unzip \
    && apt-get clean

WORKDIR /root

# Install Cosmovisor
RUN go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.6.0
# Make Genesis binaries
RUN wget -O galileo.tar.gz https://github.com/0glabs/0gchain-NG/releases/download/$NODE_TAG/galileo-$NODE_TAG.tar.gz \
     && tar -xzvf galileo.tar.gz -C /root \
     && mv /root/galileo-$NODE_TAG /root/galileo

FROM debian:trixie-slim AS runtime
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
COPY --chown=zerog:zerog --chmod=+x --from=genesis-builder /root/galileo/bin/0gchaind $DAEMON_HOME/cosmovisor/genesis/bin/

# workaround to https://github.com/cosmos/cosmos-sdk/issues/20947
RUN mkdir -p $DAEMON_HOME/data $DAEMON_HOME/config $DAEMON_HOME/keyring-test
COPY --from=genesis-builder --chown=zerog:zerog /root/galileo/0g-home/0gchaind-home/config/* $DAEMON_HOME/config/
COPY --from=genesis-builder --chown=zerog:zerog /root/galileo/kzg-trusted-setup.json $DAEMON_HOME/config/
COPY --from=genesis-builder --chown=zerog:zerog /root/galileo/jwt-secret.hex $DAEMON_HOME/config/

#COPY --chown=zerog:zerog galileo/0g-home/0gchaind-home/data/priv_validator_state.json $DAEMON_HOME/.0gchain/data/

ENTRYPOINT ["/usr/local/bin/cosmovisor"]
CMD ["--help"]