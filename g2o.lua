local hmac = require "openssl.hmac"
local b64 = require "base64"

local _M = {
  _VERSION = '0.1'
}

local function data(token)
  math.randomseed(os.time())
  return "5, 127.0.0.1, 127.0.0.1, " .. os.time(os.date("!*t")) .. ", " .. math.floor(math.random() * 10000000) .. ", " .. token
end

local function sign(path, data, key)
  local hasher = hmac.new(key, "sha256")
  hasher:update(data)
  hasher:update(path)
  return b64.encode(hasher:final())
end

function _M.g2o_headers(path, options)
  local data_value = data(options.token)
  local sign_value = sign(path, data_value, options.key)
  return {["sign"] = sign_value, ["data"] = data_value}
end

return _M