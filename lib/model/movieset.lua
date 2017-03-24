require 'lfs'
require 'class'

--- 影片索引节点组件
-- 包含影片节点的父节点都可视为本类型节点。
-- @module model/movieset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.MovieSet
-- @field path 路径
-- @field uri URI
local movies = class'Model.MovieSet':extends'Model.Node'

--- 类型
-- @field type
movies.type = 'movieset'

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = movies.test'/var/www/'
function movies.test( path )
    local function mode( file )
        return lfs.attributes(path .. '/' .. file, 'mode')
    end
    for file in lfs.dir(path) do
        while true do
            if '.' == file or '..' == file or 'directory' ~= mode(file) then
                break
            end
            if 'file' == mode(file .. '/cover.jpg')
                and 'file' == mode(file .. '/movie.mp4')
                and 'file' == mode(file .. '/metag.yml')
                then
                return true
            end
            break
        end
    end
    return false
end

return movies
