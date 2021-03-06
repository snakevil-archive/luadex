require 'lfs'
local class = require 'class'

--- 基础节点组件
-- 如无法匹配任意其它类型节点的特征时，作为退路机制进行处理。
-- @module model/node
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.Node
local node = class'Model.Node'

--- 类型
-- @field type
node.type = 'node'

--- 路径
-- @field path
node.path = ''

--- URI
-- @field uri
node.uri = ''

--- 名称
-- @field name
node.name = ''

--- 获取元信息表
-- @function metadata
-- @return table
-- @usage local metadata = node:metadata()
function node:metadata()
    if not self._meta then
        self._meta = {}
        local path = self.path .. '/metag.yml'
        if 'file' == lfs.attributes(path, 'mode') then
            local file = io.open(path)
            self._meta = require'lyaml'.load(file:read'*a')
            file:close()
        end
    end
    return self._meta
end

--- 重载生成类实例方法
-- @function new
-- @param path 路径
-- @param uri URI
-- @return Model.Node
-- @usage local node = node:new('/var/www/', '/')
function node:new( path, uri )
    local instance = node:super().new(self, {
        path = path,
        uri = uri
    })
    for part in uri:gmatch'[^/]+' do
        instance.name = part
    end
    for k, v in pairs(instance:metadata()) do
        if not rawget(instance, k) and 'function' ~= type(instance[k]) then
            instance[k] = v
        end
    end
    return instance
end

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = node.test'/var/www/'
function node.test( path )
    return true
end

--- 获取父节点
-- @function parent
-- @return Model.Node
-- @usage local parent = node:parent()
function node:parent()
    local paths = {}
    for part in self.path:gmatch'[^/]+' do
        table.insert(paths, part)
    end
    local factory = class.load'Model.Factory'
    local succeed, parent = pcall(factory.parse, factory, '/' .. table.concat(paths, '/', 1, #paths - 1) .. '/')
    if succeed then
        return parent
    end
end

--- 获取根节点
-- @function root
-- @return Model.Node
-- @usage local root = node:root()
function node:root()
    return class.load'Model.Factory':root()
end

-- 获取子节点表
-- @function children
-- @return table
-- @usage local children = node:children()
function node:children()
    if not self._children then
        self._children = {}
        self._files = {}
        local factory = class.load'Model.Factory'
        for file in lfs.dir(self.path) do
            repeat
                if '.' == file or '..' == file then
                    break
                end
                local path = self.path .. file
                local mode = lfs.attributes(path, 'mode')
                if 'file' == mode then
                    table.insert(self._files, file)
                elseif 'directory' == mode then
                    table.insert(self._children, factory:parse(path .. '/'))
                end
                break
            until true
        end
    end
    return self._children
end

-- 获取文件表
-- @function files
-- @return table
-- @usage local files = node:files()
function node:files()
    if not self._files then
        self:children()
    end
    return self._files
end

--- 获取演员索引节点
-- @function actorset
-- @return Model.Node
-- @usage local actors = node:actorset()
function node:actorset()
    if not self._actors then
        self._actors = class.load'Model.Factory':actorset(self.path) or ''
    end
    if '' ~= self._actors then
        return self._actors
    end
end

--- 获取系列索引节点
-- @function seriesset
-- @return Model.Node
-- @usage local actors = node:seriesset()
function node:seriesset()
    if not self._series then
        self._series = class.load'Model.Factory':seriesset(self.path) or ''
    end
    if '' ~= self._series then
        return self._series
    end
end

return node
