use Test::Nginx::Socket 'no_plan';

$ENV{TEST_NGINX_RESOLVER} = '8.8.8.8';

our $HttpConfig = qq{
    lua_package_path "/app/?.lua;;";
    error_log  logs/error.log info;

    init_by_lua_block { 
        require "akamai-g2o-nginx-wrapper"
    }
};

run_tests();

__DATA__
=== TEST 1: Get index
--- http_config eval: $::HttpConfig
--- config
    location /index {
        content_by_lua_block {
            ngx.req.read_body()
            local g2o = require "g2o"
            local options = { ["key"] = "s3cr3tk3y", ["token"] = "1" }
            local headers = g2o.g2o_headers("/protected", options)
            ngx.req.set_header("X-Akamai-G2O-Auth-Sign", headers.sign)
            ngx.req.set_header("X-Akamai-G2O-Auth-Data", headers.data)
            local res = ngx.location.capture("/protected")
            if res then
                ngx.status = res.status
                ngx.print(res.body)
            end
        }
    }

    location /protected {
      content_by_lua_block {
        akamai_g2o_validate_nginx(5, "s3cr3tk3y", 30)
      }
    }
--- request
GET /index
--- error_code: 400