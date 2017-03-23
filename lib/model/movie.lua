require 'lfs'
require 'class'

--- 影片节点组件
-- 此节点应包含以下文件：
-- * cover.jpg - 封皮图片
-- * movie.mp4 - 影片视频
-- * mdata.yml - 元信息文件
-- @module model/movie
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.Movie
-- @field path 路径
-- @field uri URI
local movie = class'Model.Movie':extends'Model.Node'

--- 类型
-- @field type
movie.type = 'movie'

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = movie.test'/var/www'
function movie.test( path )
    local exists = lfs.attributes
    return exists(path .. '/cover.jpg', 'mode')
        and exists(path .. '/movie.mp4', 'mode')
        and exists(path .. '/mdata.yml', 'mode')
end

return movie