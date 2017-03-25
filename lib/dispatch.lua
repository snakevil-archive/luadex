local class = require 'class'

--- 派发
-- @module dispatch
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @function dispatch
-- @param path 路径
-- @param uri URI
-- @param lap 程序启动时间
-- @usage dispatch('/var/www', '/')
return function ( path, uri, lap )
    uri = uri:gsub('%%(%x%x)', function (hex)
        return string.char(tonumber(hex, 16))
    end)
    if '/' ~= path:sub(-1) then
        path = path .. '/'
    end
    if '/' ~= uri:sub(-1) then
        uri = uri .. '/'
    end
    local node = class.load'Model.Factory':pair(path, uri):parse(path)
    local page = tostring(class.load'View.Factory':parse(node))
    local pos1, pos2 = page:find('%PROFILER%', 1, true)
    if not pos1 then
        return page
    end
    return page:sub(1, pos1 - 1)
        .. math.ceil(1000 * (os.clock() - lap or 0))
        .. 'ms costed' .. page:sub(1 + pos2)
end
