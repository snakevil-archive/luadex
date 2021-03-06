local class = require 'class'

--- 影片索引页面组件
-- @module view/movieset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type View.MovieSet
local page = class'View.MovieSet':extends'View.Node'

--- 扩展页面样式表链接
-- @function css
-- @return string
-- @usage local html = page:css()
function page:css()
  return [=[
<style>
.thumbnail {
  background-position: right;
  background-size: auto 100%;
}
.thumbnail img {
  visibility: hidden;
  margin-top: 80%;
}
</style>
]=]
end

--- 扩展页面脚本链接
-- @function js
-- @return string
-- @usage local html = page:js()
function page:js()
  return page:super():masonry()
end

--- 生成正文部分 HTML
-- @function body
-- @return string
-- @usage local html = page:body()
function page:body()
    return self.c.f[=[
$if{ $has_movies }[[
  <div class="row masonry">
    $movies[[
      <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3 item">
        <a class="thumbnail" href="$uri" style="background-image:url($uri./cover.jpg)">
          <img src="$uri./cover.jpg">
        </a>
      </div>
    ]]
  </div>
]]
]=]{
    ['if'] = self.c.cif,
    has_movies = 0 < #self.node:children(),
    movies = function ()
        for _, node in ipairs(self.node:children()) do
            self.c.yield(node)
        end
    end
}
end

return page
