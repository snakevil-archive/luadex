local class = require 'class'

--- 派发
-- @module dispatch
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @function dispatch
-- @param path 路径
-- @param uri URI
-- @usage dispatch('/var/www', '/')
return function ( path, uri )
    uri = uri:gsub('%%(%x%x)', function (hex)
        return string.char(tonumber(hex, 16))
    end)
    local node = class.load'Model.Factory':pair(path, uri):parse(path)
    local page = class.load'View.Factory':parse(node)
    return tostring(page)
end
