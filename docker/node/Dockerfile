FROM golang:1.22.2-bookworm as builder
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    nano \
    jq \
    dnsutils \
    wget \
    unzip \
    perl \
    lz4 \
    git \
    iputils-ping \
    && apt-get clean

ARG NODE_TAG
WORKDIR /root
RUN git clone -b $NODE_TAG https://github.com/0glabs/0g-chain.git
WORKDIR 0g-chain
RUN make install

FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y \
    curl \
    nano \
    jq \
    dnsutils \
    wget \
    unzip \
    perl \
    lz4 \
    git \
    iputils-ping \
    iproute2 \
    && apt-get clean

RUN useradd -m zerog
USER zerog
WORKDIR /home/zerog

COPY --from=builder /go/bin/0gchaind /usr/local/bin/0gchaind

ENTRYPOINT ["/usr/local/bin/0gchaind"]
CMD ["--help"]