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

# Set GETH env variables
ENV GETH_HOME=/home/zerog/geth_home
RUN mkdir -p $GETH_HOME


COPY --chown=zerog:zerog --chmod=+x --from=genesis-builder /root/galileo/bin/geth /usr/local/bin/

COPY --from=genesis-builder --chown=zerog:zerog /root/galileo/jwt-secret.hex /home/zerog/
COPY --from=genesis-builder --chown=zerog:zerog /root/galileo/genesis.json /home/zerog/
COPY --from=genesis-builder --chown=zerog:zerog /root/galileo/geth-config.toml /home/zerog/


ENTRYPOINT ["/usr/local/bin/geth"]
CMD ["--help"]
EXPOSE 8545