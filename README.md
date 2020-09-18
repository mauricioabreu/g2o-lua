# g2o

## Usage

```
http {
    set $g2o_secret 's3cr3tk3y';
    set $g2o_nonce '1';
    set $g2o_origin 'myorigin.com';

    location / {
        access_by_lua_file /app/g2o_headers.lua;
        proxy_pass https://$g2o_origin;
    }
}
```