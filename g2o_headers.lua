local g2o = require "g2o"

local function main()
  local options = { ["key"] = ngx.var.g2o_secret, ["token"] = ngx.var.g2o_nonce }
  local headers = g2o.g2o_headers(ngx.var.uri, options)
  ngx.req.set_header("X-Akamai-G2O-Auth-Sign", headers.sign)
  ngx.req.set_header("X-Akamai-G2O-Auth-Data", headers.data)
end

main()