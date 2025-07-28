FROM golang:1.22.2-bookworm AS builder
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    unzip \
    git \
    && apt-get clean

ARG DA_CLIENT_TAG
WORKDIR /root
RUN git clone https://github.com/0glabs/0g-da-client.git
WORKDIR 0g-da-client
RUN git checkout $DA_CLIENT_TAG
RUN make build

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
    inotify-tools \
    procps \
    iputils-ping \
    && apt-get clean

RUN useradd -m zerog
USER zerog
WORKDIR /home/zerog

COPY --from=builder /root/0g-da-client/disperser/bin/combined /usr/local/bin/zgda_client

EXPOSE 51001
ENTRYPOINT ["/usr/local/bin/zgda_client"]
CMD ["--help"]
