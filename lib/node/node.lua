require 'lfs'
require 'class'

--- 抽象节点组件
-- @module node/node
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Node.Node
local node = class'Node.Node'

--- 路径
-- @field path
node.path = ''

--- URI
-- @field uri
node.uri = ''

--- 类型
-- @field type
node.type = 'unknown'

--- 获取元信息表
-- @function meta
-- @return table
-- @usage local meta = node:meta()
function node:meta()
    if not self._meta then
        self._meta = {}
        local path = self.path .. '/meta.json'
        if 'file' == lfs.attributes(path, 'mode') then
            local file = io.open(path)
            self._meta = require'cjson'.decode(file:read'*a')
            file:close()
        end
    end
    return self._meta
end

--- 重载生成类实例方法
-- @function new
-- @param path 路径
-- @param uri URI
-- @return Node.Node
-- @usage local node = node:new'/var/www'
function node:new( path, uri )
    local instance = node:super().new(self, {
        path = path,
        uri = uri
    })
    for k, v in pairs(instance:meta()) do
        if not rawget(instance, k) then
            instance[k] = v
        end
    end
    return instance
end

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = node.test'/var/www'
function node.test( path )
    return true
end

--- 获取父节点
-- @function parent
-- @return Node.Node
-- @usage local parent = node:parent()
function node:parent()
    local paths = {}
    for part in self.path:gmatch'[^/]+' do
        table.insert(paths, part)
    end
    return class.load'Node.Factory':parse('/' .. table.concat(paths, '/', 1, #paths - 1))
end

--- 获取根节点
-- @function root
-- @return Node.Node
-- @usage local root = node:root()
function node:root()
    return class.load'Node.Factory':root()
end

-- 获取子节点表
-- @function children
-- @return table
-- @usage local children = node:children()
function node:children()
    if not self._children then
        self._children = {}
        self._files = {}
        local factory = class.load'Node.Factory'
        for file in lfs.dir(self.path) do
            repeat
                if '.' == file or '..' == file then
                    break
                end
                local path = self.path .. '/' .. file
                local mode = lfs.attributes(path, 'mode')
                if 'file' == mode then
                    self._files[file] = file
                elseif 'directory' == mode then
                    self._children[file] = factory:parse(path)
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

return node