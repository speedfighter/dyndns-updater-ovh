# ---------- Build Stage ----------
FROM --platform=$BUILDPLATFORM denoland/deno:latest AS builder

WORKDIR /app

COPY main.ts deno.json ./

RUN deno task build

# ---------- Runtime Stage ----------
FROM debian:stable-slim AS runtime
ARG TARGETARCH

WORKDIR /app

# Install only required packages and clean up in one layer
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN useradd -r -u 1000 -g root dyndns

COPY --from=builder /app/dyndns_${TARGETARCH} ./dyndns
RUN chmod +x /app/dyndns

VOLUME /data

USER dyndns

HEALTHCHECK --interval=5m --timeout=3s \
  CMD pgrep -f dyndns || exit 1

ENTRYPOINT ["/app/dyndns"]