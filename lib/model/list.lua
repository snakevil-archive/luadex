require 'lfs'
require 'class'

--- 影片索引节点组件
-- 包含影片节点的父节点都可视为本类型节点。
-- @module model/list
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.List
-- @field path 路径
-- @field uri URI
local list = class'Model.List':extends'Model.Node'

--- 类型
-- @field type
list.type = 'list'

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = list.test'/var/www'
function list.test( path )
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
                and 'file' == mode(file .. '/mdata.yml')
                then
                return true
            end
            break
        end
    end
    return false
end

return movie
