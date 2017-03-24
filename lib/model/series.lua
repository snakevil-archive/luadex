require 'class'

--- 系列节点组件
-- 影片索引节点的一种精化节点，应包含以下文件：
-- * mdata.yml - 元信息文件
-- @module model/series
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.Series
-- @field path 路径
-- @field uri URI
local series = class'Model.Series':extends'Model.MovieSet'

--- 类型
-- @field type
series.type = 'series'

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = series.test'/var/www/'
function series.test( path )
    if not series:super().test(path) then
        return false
    end
    local function exists( file )
        return 'file' == lfs.attributes(path .. '/' .. file, 'mode')
    end
    return exists('mdata.yml')
end

return series
