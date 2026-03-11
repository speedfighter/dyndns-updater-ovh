# ---------- Build Stage ----------
FROM denoland/deno:latest AS builder

WORKDIR /app

COPY src ./src

RUN deno compile \
  --allow-env \
  --allow-net \
  --allow-read \
  --allow-write \
  --output dyndns \
  src/index.ts

# ---------- Runtime Stage ----------
FROM alpine:latest

WORKDIR /app

RUN adduser -D appuser

COPY --from=builder /app/dyndns /app/dyndns

VOLUME /data

USER appuser

HEALTHCHECK --interval=5m --timeout=3s \
  CMD pgrep -f dyndns || exit 1

ENTRYPOINT ["/app/dyndns"]