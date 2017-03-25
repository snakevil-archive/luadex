require 'lfs'
local class = require 'class'

--- 影片节点组件
-- 此节点应包含以下文件：
-- * cover.jpg - 封皮图片
-- * movie.mp4 - 影片视频
-- * metag.yml - 元信息文件
-- @module model/movie
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Model.Movie
-- @field path 路径
-- @field uri URI
local movie = class'Model.Movie':extends'Model.Node'

--- 类型
-- @field type
movie.type = 'movie'

--- 视频信息
-- @field info
movie.info = {}

--- 重载生成类实例方法
-- @function new
-- @param path 路径
-- @param uri URI
-- @return Model.Node
-- @usage local movie = movie:new('/var/www/', '/')
function movie:new( path, uri )
    local instance = movie:super().new(self, path, uri)
    instance.name = instance.title
    if instance.summary then
        instance.summary = instance.summary:gsub('%s+', '')
    end
    local info, kind = io.popen('mediainfo "' .. path .. 'movie.mp4"'), nil
    for line in info:lines() do
        local pos1, pos2 = line:find(' : ', 1, true)
        if pos1 then
            instance.info[kind][line:sub(1, pos1):gsub('[^%w]+', '_'):gsub('_+$', ''):lower()] = line:sub(1 + pos2)
        elseif '' ~= line then
            kind = line:lower()
            instance.info[kind] = {}
        end
    end
    info:close()
    return instance
end

--- 检查路径是否符合节点特征
-- @function test
-- @param path 路径
-- @return boolean
-- @usage local matched = movie.test'/var/www/'
function movie.test( path )
    local function exists( file )
        return 'file' == lfs.attributes(path .. file, 'mode')
    end
    return exists('cover.jpg') and exists('movie.mp4') and exists('metag.yml')
end

-- 重载获取子节点表
-- @function children
-- @return table
-- @usage local children = movie:children()
function movie:children()
    if not self._children then
        movie:super().children(self)
        local files = self._files
        self._files = {}
        for _, file in ipairs(files) do
            if 'snap-' == file:sub(1, 5) and '.jpg' == file:sub(-4) then
                table.insert(self._files, file)
            end
        end
        table.sort(self._files)
    end
    return self._children
end

return movie
