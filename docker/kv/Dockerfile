FROM rust:1.88.0-trixie AS rust-builder

WORKDIR /root
# The version should be matching the version set above
RUN rustup toolchain install 1.88.0 --profile minimal

RUN apt-get update && apt-get install -y \
    build-essential \
    clang-tools-17 \
    git \
    libssl-dev \
    pkg-config \
    protobuf-compiler \
    libudev-dev \
    && apt-get clean

ARG KV_NODE_TAG

RUN git clone -b $KV_NODE_TAG https://github.com/0glabs/0g-storage-kv.git
WORKDIR 0g-storage-kv
RUN git submodule update --init
RUN cargo build --release

FROM debian:trixie-slim AS runtime
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
    inotify-tools \
    procps \
    supervisor \
    iputils-ping \
    && apt-get clean

RUN useradd -m zerog
USER zerog
WORKDIR /home/zerog

COPY --from=rust-builder /root/0g-storage-kv/target/release/zgs_kv /usr/local/bin/zgs_kv
COPY --chown=zerog:zerog docker/kv/entrypoint.sh /opt/entrypoint.sh
COPY --chown=zerog:zerog configs/kv/config.toml /config/config.toml
COPY --chown=zerog:zerog configs/log_watcher.sh /usr/local/bin/log_watcher.sh
COPY --chown=zerog:zerog configs/log_cleaner.sh /usr/local/bin/log_cleaner.sh
RUN chmod +x /usr/local/bin/log_cleaner.sh /usr/local/bin/log_watcher.sh /opt/entrypoint.sh

RUN mkdir -p db log network && touch log/empty.log

ENTRYPOINT ["/opt/entrypoint.sh"]
