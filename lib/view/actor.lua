local class = require 'class'

--- 演员节点页面组件
-- @module view/actor
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type View.Actor
local page = class'View.Actor':extends'View.MovieSet'

--- 扩展页面样式表链接
-- @function css
-- @param cosmo
-- @return string
-- @usage local html = page:css(cosmo)
function page:css(cosmo)
  return [=[
<style>
.jumbotron.end { margin-bottom: 0 }
.media-object { max-width: 128px }
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

--- 生成页头部分 HTML
-- @function header
-- @param cosmo
-- @return string
-- @usage local html = page:header(cosmo)
function page:header( cosmo )
    local name = self.node.name
    if self.node.aliases then
        name = self.node.aliases[1]
    end
    return cosmo.f[=[
<div class="row">
  <div class="col-xs-12 col-md-6 col-md-offset-3">
    <div class="media">
      <div class="media-left">
        <img class="media-object img-rounded" src="$node|uri./portrait.jpg">
      </div>
      <div class="media-body">
        <h1 class="media-heading">$name</h1>
        <p>$node|romaji</p>
      </div>
    </div>
  </div>
</div>
]=]{
    name = name,
    node = self.node
}
end

--- 生成正文部分 HTML
-- @function body
-- @param cosmo
-- @return string
-- @usage local html = page:body(cosmo)
function page:body( cosmo )
    return cosmo.f[=[
<div class="panel panel-warning">
  <div class="panel-heading">&nbsp;</div>
  <div class="panel-body">
    <dl class="dl-horizontal">
      $if{ $node|aliases }[[
        <dt>Aliases</dt>
        <dd>
          <ul class="list-unstyled">
            $node|aliases[[
              <li>$it</li>
            ]]
          </ul>
        </dd>
      ]]
      $if{ $node|size }[[
        <dt>Size</dt>
        <dd>
          <ul class="list-unstyled">
            <li>
              <strong>Bust&nbsp;</strong>
              <span>$node|size|B cm</span>
            </li>
            <li>
              <strong>Waist&nbsp;</strong>
              <span>$node|size|W cm</span>
            </li>
            </li>
              <strong>Hip&nbsp;</strong>
              <span>$node|size|H cm</span>
            </li>
          </ul>
        </dd>
        <dt>Tall</dt>
        <dd>$node|size|T cm</dd>
      ]]
      $metag[[
        <dt>$field</dt>
        <dd>$value</dd>
      ]]
      $if{ $node|links }[[
        <dt>References</dt>
        <dd>
          <ul class="list-unstyled">
            $links[[
              <li>
                <a href="$url" target="_blank">$title</a>
              </li>
            ]]
          </ul>
        </dd>
      ]]
    </dl>
  </div>
</div>
$list
]=]{
    node = self.node,
    ['if'] = cosmo.cif,
    metag = function ()
        for k, v in pairs(self.node:metadata()) do
            if 'romaji' ~= k and 'aliases' ~= k and 'size' ~= k and 'links' ~= k then
                cosmo.yield{
                    field = k:sub(1, 1):upper() .. k:sub(2):lower(),
                    value = v
                }
            end
        end
    end,
    links = function ()
        for k, v in pairs(self.node.links) do
            cosmo.yield{
                url = v,
                title = k
            }
        end
    end,
    list = page:super().body(self, cosmo)
}
end

return page
