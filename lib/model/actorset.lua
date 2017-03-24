local class = require 'class'

--- 演员索引节点组件
-- 此节点目录名称必须为「@」。
-- @module model/actorset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.ActorSet
-- @field path 路径
-- @field uri URI
local actors = class'Model.ActorSet':extends'Model.Node'

--- 类型
-- @field type
actors.type = 'actorset'

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = actors.test'/var/www/'
function actors.test( path )
    local parts = {}
    for part in path:gmatch'[^/]+' do
        table.insert(parts, part)
    end
    return '@' == parts[#parts]
end

return actors
