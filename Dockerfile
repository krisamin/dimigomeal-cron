FROM rust:1.77-bullseye AS builder
WORKDIR /usr/src/dimigomeal-cron

COPY . .
RUN cargo build --release

FROM debian:bullseye

COPY --from=builder /usr/src/dimigomeal-cron/target/release/dimigomeal-cron /usr/local/bin/dimigomeal-cron

RUN apt-get update && apt-get install -y cron
COPY cron /etc/cron.d/cron
RUN crontab /etc/cron.d/cron

CMD ["cron", "-f"]