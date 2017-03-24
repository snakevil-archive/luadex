local class = require 'class'

--- 系列索引节点组件
-- 此节点目录名称必须为「=」。
-- @module model/seriesset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.SeriesSet
-- @field path 路径
-- @field uri URI
local seriess = class'Model.SeriesSet':extends'Model.Node'

--- 类型
-- @field type
seriess.type = 'series.set'

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = seriess.test'/var/www/'
function seriess.test( path )
    local parts = {}
    for part in path:gmatch'[^/]+' do
        table.insert(parts, part)
    end
    return '=' == parts[#parts]
end

return seriess
