local class = require 'class'

--- 演员节点组件
-- 影片索引节点的一种精化节点，应包含以下文件：
-- * portrait.jpg - 头像
-- * metag.yml - 元信息文件
-- @module model/actor
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.Actor
-- @field path 路径
-- @field uri URI
local actor = class'Model.Actor':extends'Model.MovieSet'

--- 类型
-- @field type
actor.type = 'actor'

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = actor.test'/var/www/'
function actor.test( path )
    if not actor:super().test(path) then
        return false
    end
    local function exists( file )
        return 'file' == lfs.attributes(path .. '/' .. file, 'mode')
    end
    return exists('portrait.jpg') and exists('metag.yml')
end

return actor
