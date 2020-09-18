use Test::Nginx::Socket 'no_plan';
env_to_nginx("G2O_SECRET", "G2O_NONCE");

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
=== TEST 1: Get index with correct key/nonce
--- http_config eval: $::HttpConfig
--- config
    location /index {
        content_by_lua_block {
            ngx.req.read_body()
            local g2o = require "g2o"
            local options = { ["key"] = os.getenv("G2O_SECRET"), ["token"] = os.getenv("G2O_NONCE") }
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
        akamai_g2o_validate_nginx(5, os.getenv("G2O_SECRET"), 30)
        ngx.say("OK")
      }
    }
--- request
GET /index
--- response_body
OK

=== TEST 2: Get index with wrong key/nonce
--- http_config eval: $::HttpConfig
--- config
    location /index {
        content_by_lua_block {
            ngx.req.read_body()
            local g2o = require "g2o"
            local options = { ["key"] = "wrongkey", ["token"] = "1" }
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
        akamai_g2o_validate_nginx(5, os.getenv("G2O_SECRET"), 30)
        ngx.say("NOT OK")
      }
    }
--- request
GET /index
--- error_code: 400
--- no_error_log
[error]