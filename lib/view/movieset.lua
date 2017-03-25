local class = require 'class'

--- 影片索引页面组件
-- @module view/movieset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type View.MovieSet
local page = class'View.MovieSet':extends'View.Node'

--- 扩展页面样式表链接
-- @function css
-- @param cosmo
-- @return string
-- @usage local html = page:css(cosmo)
function page:css(cosmo)
  return [=[
<style>
.jumbotron.end { margin-bottom: 0 }
.col\-lg\-4 { margin-bottom: 15px }
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
-- @param cosmo
-- @return string
-- @usage local html = page:js(cosmo)
function page:js(cosmo)
  return [=[
<script src="//cdn.bootcss.com/masonry/4.1.1/masonry.pkgd.min.js"></script>
]=]
end

--- 生成正文部分 HTML
-- @function body
-- @param cosmo
-- @return string
-- @usage local html = page:body(cosmo)
function page:body( cosmo )
    return cosmo.f[=[
$if{ $movies }[[
  <div class="row" data-masonry='{"itemSelector":".col-lg-4"}'>
    $movies[[
      <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
        <a class="thumbnail" href="$uri" style="background-image:url($uri./cover.jpg)">
          <img src="$uri./cover.jpg">
        </a>
      </div>
    ]]
  </div>
]]
]=]{
    ['if'] = cosmo.cif,
    movies = function ()
        for _, node in ipairs(self.node:children()) do
            cosmo.yield(node)
        end
    end
}
end

return page
