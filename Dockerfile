FROM openresty/openresty:alpine-fat

RUN apk add --no-cache openssl-dev perl-test-nginx perl-utils

RUN PERL_MM_USE_DEFAULT=1 cpan install Test::Nginx

RUN luarocks install busted
RUN luarocks install luaossl
RUN luarocks install base64

WORKDIR /app

COPY . .