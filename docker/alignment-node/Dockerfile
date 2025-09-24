FROM golang:1.24.3-bookworm as genesis-builder
ARG ALIGNMENT_NODE_TAG
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
RUN wget -O alignment-node.tar.gz https://github.com/0gfoundation/alignment-node-release/releases/download/$ALIGNMENT_NODE_TAG/alignment-node.tar.gz \
     && tar -xzvf alignment-node.tar.gz -C /root

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

# Set node env variables
ENV NODE_HOME=/home/zerog/node_home
RUN mkdir -p $NODE_HOME


COPY --chown=zerog:zerog --chmod=+x --from=genesis-builder /root/alignment-node/0g-alignment-node /usr/local/bin/
COPY --chown=zerog:zerog configs/alignment-node/config.toml /home/zerog/config.toml

ENTRYPOINT ["/usr/local/bin/0g-alignment-node"]
CMD ["--help"]
EXPOSE 34567