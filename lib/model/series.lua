require 'class'

--- 系列索引节点组件
-- 此节点目录名称必须为「=」。
-- @module model/series
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.Series
-- @field path 路径
-- @field uri URI
local series = class'Model.Series':extends'Model.Node'

--- 类型
-- @field type
series.type = 'series'

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = series.test'/var/www'
function series.test( path )
    local parts = {}
    for part in path:gmatch'[^/]+' do
        table.insert(parts, part)
    end
    return '=' == parts[#parts]
end

return series
