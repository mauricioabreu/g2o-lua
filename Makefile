up-server:
	docker run --rm -p 80:80 \
		-v $(shell pwd)/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf lua-g2o