require 'class'

--- 派发
-- @module dispatch
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @function dispatch
-- @param path 路径
-- @param uri URI
-- @usage dispatch('/var/www', '/')
return function ( path, uri )
    local node = class.load'Model.Factory':pair(path, uri):parse(path)
    local page = class.load'View.Factory':parse(node)
    print(page)
end
