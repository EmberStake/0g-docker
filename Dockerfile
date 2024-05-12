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
WORKDIR /root
RUN git clone -b v0.1.0 https://github.com/0glabs/0g-chain.git
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
    && apt-get clean

COPY --from=builder /go/bin/0gchaind /usr/local/bin/0gchaind

ENTRYPOINT ["/usr/local/bin/0gchaind"]
CMD ["--help"]