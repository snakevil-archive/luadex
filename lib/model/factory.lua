require 'lfs'
local class = require 'class'

--- 节点工厂组件
-- @module model/factory
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.Factory
local factory = class'Model.Factory'

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
-- @return Model.Factory
-- @usage factory:pair('/data/video/g/2016/', '/v/g/2016/')
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
    factory._root = '/' .. table.concat(paths, '/', 1, #paths - level) .. '/'
    factory._prefix = '/' .. table.concat(uris, '/', 1, #uris - level) .. '/'
    if '//' == factory._prefix then
        factory._prefix = '/'
    end
    return factory
end

--- 已加载节点表
-- @field _nodes
factory._nodes = {}

--- 可用节点类型
-- @field _types
factory._types = {
    class.load'Model.ActorSet',
    class.load'Model.SeriesSet',
    class.load'Model.Actor',
    class.load'Model.MovieSet',
    class.load'Model.Movie',
    class.load'Model.Series',
    class.load'Model.Node'
}

--- 根据路径生成节点
-- @function parse
-- @param path 路径
-- @return Model.Node
-- @usage local movie = factory:parse'/var/www/g/2016/tom.and.jerry/'
function factory:parse( path )
    if self._nodes[path] then
        return self._nodes[path]
    end
    if '' == self._root then
        error('node factory not paired.')
    end
    if self._root ~= path:sub(1, #self._root) then
        error('out of node factory root.')
    end
    if 'file' == lfs.attributes(path, 'mode') then
        error('file aint node.')
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
-- @return Model.Node
-- @usage local root = factory:root()
function factory:root()
    return self:parse(self._root)
end

--- 获取与路径最相近的演员索引节点
-- @function actorset
-- @param path 路径
-- @return Model.ActorSet
-- @usage local actorset = factory:actorset'/var/www/g/2016/tom.and.jerry/'
function factory:actorset( path )
    local suffix, exists, paths = '', function (path)
        return 'directory' == lfs.attributes(path, 'mode')
    end, {
        self._root .. '@/'
    }
    for part in path:sub(1 + #self._root):gmatch'[^/]+' do
        suffix = suffix .. part .. '/'
        table.insert(paths, 1, self._root .. suffix .. '@/')
    end
    table.remove(paths, 1)
    for _, path in ipairs(paths) do
        if exists(path) then
            return self:parse(path)
        end
    end
end

--- 获取与路径最相近的系列索引节点
-- @function seriesset
-- @param path 路径
-- @return Model.SeriesSet
-- @usage local seriesset = factory:seriesset'/var/www/g/2016/tom.and.jerry/'
function factory:seriesset( path )
    local suffix, exists, paths = '', function (path)
        return 'directory' == lfs.attributes(path, 'mode')
    end, {
        self._root .. '-/'
    }
    for part in path:sub(1 + #self._root):gmatch'[^/]+' do
        suffix = suffix .. part .. '/'
        table.insert(paths, 1, self._root .. suffix .. '-/')
    end
    table.remove(paths, 1)
    for _, path in ipairs(paths) do
        if exists(path) then
            return self:parse(path)
        end
    end
end

return factory:new{}
