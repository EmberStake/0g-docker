FROM rust:1.79.0-bookworm AS rust-builder
WORKDIR /root
# The version should be matching the version set above
RUN rustup toolchain install nightly-2024-02-04-x86_64-unknown-linux-gnu
RUN rustup component add --toolchain nightly-2024-02-04-x86_64-unknown-linux-gnu rustfmt
RUN rustup target add x86_64-unknown-linux-gnu

RUN apt-get update && apt-get install -y \
    build-essential \
    clang-tools-14 \
    git \
    libssl-dev \
    pkg-config \
    protobuf-compiler \
    libudev-dev \
    && apt-get clean

ARG DA_NODE_TAG

RUN git clone https://github.com/0glabs/0g-da-node.git
WORKDIR 0g-da-node
RUN git checkout $DA_NODE_TAG
# Download AMT parameters
RUN ./dev_support/download_params.sh

# Build
RUN cargo build --release

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

COPY --from=rust-builder --chown=zerog:zerog  /root/0g-da-node/params /home/zerog/params
COPY --from=rust-builder /root/0g-da-node/target/release/server /usr/local/bin/zgda_node
COPY --from=rust-builder /root/0g-da-node/target/release/key-gen /usr/local/bin/key-gen
COPY --chown=zerog:zerog configs/da-node/config.toml configs/config.toml
COPY --chown=zerog:zerog docker/da-node/entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

EXPOSE 34000
ENTRYPOINT ["/opt/entrypoint.sh"]

