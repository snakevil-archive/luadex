require 'class'

--- 演员索引节点组件
-- 此节点目录名称必须为「@」。
-- @module node/actors
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Node.Actors
-- @field path 路径
-- @field uri URI
local actors = class'Node.Actors':extends'Node.Node'

--- 类型
-- @field type
actors.type = 'actors'

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = actors.test'/var/www'
function actors.test( path )
    local parts = {}
    for part in path:gmatch'[^/]+' do
        table.insert(parts, part)
    end
    return '@' == parts[#parts]
end

return actors
