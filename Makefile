build:
	docker build --tag lua-g2o .

run:
	docker run --rm -p 80:80 \
		-v $(shell pwd)/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf lua-g2o

test:
	docker run --rm -p 80:80 \
		-v $(shell pwd)/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf lua-g2o prove t/request.t