require 'class'

--- 节点工厂组件
-- @module node/factory
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Node.Factory
local factory = class'Node.Factory'

--- 根目录路径
-- @field _root
factory._root = ''

--- URI 前缀
-- @field _prefix
factory._prefix = ''

--- 配对路径和 URI
-- 用于寻找根节点路径和 URI，及后代节点的 URI 计算。
-- @function pair
-- @param path 已知路径
-- @param uri 相应 URI
-- @return Node.Factory
-- @usage factory:pair('/data/video/g/2016', '/v/g/2016')
function factory:pair( path, uri )
    local paths, uris, level = {}, {}, 0
    for part in path:gmatch'[^/]+' do
        table.insert(paths, part)
    end
    for part in uri:gmatch'[^/]+' do
        table.insert(uris, part)
    end
    while paths[#paths - level] == uris[#uris - level] do
        level = 1 + level
    end
    factory._root = '/' .. table.concat(paths, '/', 1, #paths - level)
    factory._prefix = '/' .. table.concat(uris, '/', 1, #uris - level)
    return factory
end

--- 已加载节点表
-- @field _nodes
factory._nodes = {}

--- 可用节点类型
-- @field _types
factory._types = {
    class.load'Node.Actors',
    class.load'Node.Series',
    class.load'Node.Movie',
    class.load'Node.Node'
}

--- 根据路径生成节点
-- @function parse
-- @param path 路径
-- @return Node.Node
-- @usage local movie = factory:parse'/var/www/g/2016/tom.and.jerry'
function factory:parse( path )
    if self._nodes[path] then
        return self._nodes[path]
    end
    if '' == self._root then
        error('node factory not paired.')
    end
    if self._root ~= path and self._root .. '/' ~= path:sub(1, 1 + #self._root) then
        error('out of node factory root.')
    end
    for _, node in pairs(self._types) do
        if node.test(path) then
            self._nodes[path] = node:new(path, self._prefix .. path:sub(1 + #self._root))
            return self._nodes[path]
        end
    end
end

--- 获取根节点
-- @function root
-- @return Node.Node
-- @usage local root = factory:root()
function factory:root()
    return self:parse(self._root)
end

return factory:new{}
