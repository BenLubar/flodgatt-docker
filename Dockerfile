FROM alpine:3.11 AS build

RUN apk add --no-cache \
        cargo \
        openssl-dev

ENV FLODGATT_VERSION "0.3.5"
ENV FLODGATT_HASH "bfb47464494df2b517fa4873334ac5ef44615a7dc4df1020a3256b75f99a31f6"

RUN wget -O flodgatt.tar.gz "https://github.com/tootsuite/flodgatt/archive/$FLODGATT_VERSION.tar.gz" \
 && echo "$FLODGATT_HASH  flodgatt.tar.gz" | sha256sum -c \
 && tar xzf flodgatt.tar.gz \
 && cd "flodgatt-$FLODGATT_VERSION" \
 && cargo build --release \
 && mkdir -p /usr/local/bin \
 && cp target/release/flodgatt /usr/local/bin/flodgatt

FROM alpine:3.11

RUN apk add --no-cache libgcc

ENV SERVER_ADDR 0.0.0.0:4000
EXPOSE 4000

COPY --from=build /usr/local/bin/flodgatt /usr/local/bin/flodgatt

CMD ["flodgatt"]
