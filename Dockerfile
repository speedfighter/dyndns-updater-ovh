# ---------- Build Stage ----------
FROM denoland/deno:latest AS builder

WORKDIR /app

COPY main.ts deno.json ./

RUN deno task build

# ---------- Runtime Stage ----------
FROM alpine:latest

WORKDIR /app

RUN adduser -D dyndns

COPY --from=builder /app/dyndns ./
RUN chmod +x /app/dyndns

VOLUME /data

USER dyndns

HEALTHCHECK --interval=5m --timeout=3s \
  CMD pgrep -f dyndns || exit 1

ENTRYPOINT ["/app/dyndns"]