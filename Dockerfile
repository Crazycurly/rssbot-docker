FROM ekidd/rust-musl-builder:nightly-2021-12-23 AS builder
COPY . .
RUN sudo chown -R rust:rust /home/rust
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --release
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder \
    /home/rust/src/target/x86_64-unknown-linux-musl/release/rssbot \
    /usr/local/bin/
WORKDIR /rustrssbot
ENV TELEGRAM_BOT_TOKEN=""
ENV MAX_FEED_SIZE=2097152
ENV MAX_INTERVAL=43200
ENV MIN_INTERVAL=300
ENTRYPOINT /usr/local/bin/rssbot $TELEGRAM_BOT_TOKEN --max-feed-size $MAX_FEED_SIZE --max-interval $MAX_INTERVAL --min-interval $MIN_INTERVAL