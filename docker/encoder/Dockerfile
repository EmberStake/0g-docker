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

ARG ENCODER_TAG

RUN git clone https://github.com/0glabs/0g-da-encoder.git
WORKDIR 0g-da-encoder
RUN git checkout $ENCODER_TAG
# Download AMT parameters
RUN ./dev_support/download_params.sh

# Build with no Cuda support atm
RUN cargo build --release --features grpc/parallel

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

COPY --from=rust-builder /root/0g-da-encoder/target/release/server /usr/local/bin/zg_encoder
COPY --from=rust-builder --chown=zerog:zerog  /root/0g-da-encoder/params /home/zerog/params
COPY --chown=zerog:zerog configs/encoder/config.toml /config/config.toml
EXPOSE 34000
ENTRYPOINT ["/usr/local/bin/zg_encoder"]
CMD ["--help"]
