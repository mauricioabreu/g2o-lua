build:
	docker build --tag lua-g2o .

run:
	docker run --rm -e G2O_SECRET -e G2O_NONCE -e G2O_ORIGIN -p 80:80 \
		-v $(shell pwd)/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf lua-g2o

test:
	docker run --rm -e G2O_SECRET="s3cr3tk3y" -e G2O_NONCE="1" -e G2O_ORIGIN="http://127.0.0.1:81" -p 80:80 \
		-v $(shell pwd)/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf lua-g2o prove t/request.t