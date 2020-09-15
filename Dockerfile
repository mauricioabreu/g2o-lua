FROM openresty/openresty:alpine-fat

RUN apk add --no-cache openssl-dev

RUN luarocks install busted
RUN luarocks install luaossl
RUN luarocks install base64

WORKDIR /app

COPY . .