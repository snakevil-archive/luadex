local class = require 'class'

--- 演员索引节点页面组件
-- @module view/actorset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type View.ActorSet
local page = class'View.ActorSet':extends'View.Node'

--- 扩展页面样式表链接
-- @function css
-- @return string
-- @usage local html = page:css()
function page:css()
  return [=[
<style>
.col\-lg\-4 { margin-bottom: 15px }
</style>
]=]
end

--- 扩展页面脚本链接
-- @function js
-- @return string
-- @usage local html = page:js()
function page:js()
  return [=[
<script src="//cdn.bootcss.com/masonry/4.1.1/masonry.pkgd.min.js"></script>
]=]
end

--- 生成正文部分 HTML
-- @function body
-- @return string
-- @usage local html = page:body()
function page:body()
    return self.c.f[=[
$if{ $has_actors }[[
  <div class="row" data-masonry='{"itemSelector":".col-lg-4"}'>
    $actors[[
      <div class="col-xs-6 col-sm-4 col-md-3 col-lg-2">
        <a class="thumbnail" href="$uri">
          <img src="$uri./portrait.jpg">
          <div class="caption">
            <h2 class="h4">$name</h2>
          </div>
        </a>
      </div>
    ]]
  </div>
]]
]=]{
    ['if'] = self.c.cif,
    has_actors = 0 < #self.node:children(),
    actors = function ()
        local actors = {}
        for _, node in ipairs(self.node:children()) do
            local name = node.name
            if node.aliases then
                name = node.aliases[1]
            end
            if not actors[name] then
                actors[name] = true
                self.c.yield(node)
            end
        end
    end
}
end

return page
