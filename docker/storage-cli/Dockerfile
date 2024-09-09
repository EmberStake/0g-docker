FROM golang:1.22.2-bookworm as builder
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    unzip \
    git \
    && apt-get clean

ARG STORAGE_CLI_TAG
WORKDIR /root
RUN git clone https://github.com/0glabs/0g-storage-client.git
WORKDIR 0g-storage-client
RUN git checkout $STORAGE_CLI_TAG
RUN go build

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
    && apt-get clean

RUN useradd -m zerog
USER zerog
WORKDIR /home/zerog

COPY --from=builder /root/0g-storage-client/0g-storage-client /usr/local/bin/0g-storage-client

EXPOSE 51001
ENTRYPOINT ["/usr/local/bin/0g-storage-client"]
CMD ["--help"]
