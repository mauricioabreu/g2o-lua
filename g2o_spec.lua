local g2o = require "g2o"

describe("g2o signature headers", function()
  it("checks if signed data is correct", function()
    local options = {["key"] = "1234", ["token"] = "1234"}
    local headers = g2o.g2o_headers("/foo/bar", options)
    assert.is_not_nil(headers.sign)
    assert.is_not_nil(headers.data)
  end)
end)