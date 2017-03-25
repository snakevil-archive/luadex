require 'lfs'
local class = require 'class'

--- 基础节点页面组件
-- @module view/node
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type View.Node
local page = class'View.Node'

--- Cosmo 引擎
-- @field c
page.c = require 'cosmo'

--- 对应节点
-- @field node
page.node = nil

--- 重载生成类实例方法
-- @function new
-- @param node 节点
-- @return View.Node
-- @usage local page = view:new(node)
function page:new( node )
    return page:super().new(self, {
        node = node
    })
end

--- 重载转化为字符串
-- @function __tostring
-- @return string
-- @usage local html = tostring(page)
function page:__tostring()
    return self.c.f[=[
<!doctype html>
<html class="no-js" lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>$node|name - Luadex</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="//cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
  $css
</head>
<body>
  <div class="jumbotron">
    <div class="container">
      <ol class="breadcrumb">
        $hierachy[[
          <li><a href="$uri">$name</a></li>
        ]]
      </ol>
      $header
    </div>
  </div>
  <div class="container">
    $body
  </div>
  <div class="jumbotron" style="margin-bottom:0">
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-8 col-sm-offset-4">
          <address>
            <a href="https://github.com/snakevil/luadex" target="_blank">Luadex</a>
            <span>, A piece of expirement work of&nbsp;</span>
            <a href="https://twitter.com/snakevil" target="_blank">@Snakevil</a>
          </address>
          <address>
            <span>Based on&nbsp;</span>
            <a href="https://github.com/openresty/lua-nginx-module/" target="_blank">ngx_lua</a>
            <span>,&nbsp;</span>
            <a href="http://keplerproject.github.io/luafilesystem/" target="_blank">LuaFileSystem</a>
            <span>,&nbsp;</span>
            <a href="https://github.com/gvvaughan/lyaml" target="_blank">LYAML</a>
            <span>&nbsp;and&nbsp;<span>
            <a href="http://cosmo.luaforge.net" target="_blank">Cosmo</a>
            <br>
            <span>Rendered with&nbsp;<span>
            <a href="http://getbootstrap.com" target="_blank">Bootstrap</a>
            <span>,&nbsp;</span>
            <a href="http://jquery.com" target="_blank">jQuery</a>
            <span>,&nbsp;</span>
            <a href="http://videojs.com" target="_blank">Video.js</a>
            <span>,&nbsp;</span>
            <a href="http://masonry.desandro.com" target="_blank">Masonry</a>
            <span>&nbsp;and&nbsp;<span>
            <a href="http://fancyapps.com/fancybox/3/" target="_blank">fancyBox</a>
          </address>
          <address>
            <span>Thanks to&nbsp;</span>
            <a href="http://www.bootcdn.cn" target="_blank">BootCDN</a>
            <span>&nbsp;for their free service :-)</span>
          </address>
        </div>
      </div>
    </div>
  </div>
  <script src="//cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
  <script src="//cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  $js
</body>
</html>
]=]{
    css = self:css(),
    js = self:js(),
    node = self.node,
    hierachy = (function ()
        local parent, uri, uri2, hierachy = self.node:parent(), '', '', {
            {
                uri = '/',
                name = 'Home'
            }
        }
        while parent do
            uri = parent.uri
            if '/' ~= uri then
                table.insert(hierachy, parent)
            end
            parent = parent:parent()
        end
        local uri2 = '/'
        for part in uri:gmatch'[^/]+' do
            uri2 = uri2 .. part .. '/'
            if uri2 ~= uri then
                table.insert(hierachy, {
                    uri = uri2,
                    name = part
                })
            end
        end
        table.sort(hierachy, function (one, another)
            return #one.uri < #another.uri
        end)
        return hierachy
    end)(),
    header = self:header(),
    body = self:body()
}:gsub('>%s+', '>'):gsub('%s+<', '<')
end

--- 扩展页面样式表链接
-- @function css
-- @return string
-- @usage local html = page:css()
function page:css()
  return ''
end

--- 扩展页面脚本链接
-- @function js
-- @return string
-- @usage local html = page:js()
function page:js()
  return ''
end

--- 生成页头部分 HTML
-- @function header
-- @return string
-- @usage local html = page:header()
function page:header()
    return '<h1>' .. self.node.name .. '</h1>'
end

--- 生成正文部分 HTML
-- @function body
-- @return string
-- @usage local html = page:body()
function page:body()
    return self.c.f[=[
<div class="panel panel-info">
  <div class="panel-body">
    <div class="table-responsive">
      <table class="table table-hover">
        <tbody>
          $folders[[
            <tr>
              <td>
                <a href="$uri">$name</a>
              </td>
              <td class="text-muted">/</td>
            </tr>
          ]]
        </tbody>
        <tbody>
          $files[[
            <tr>
              <td>
                <a href="$prefix$name">$name</a>
              </td>
              <td>$size</td>
            </tr>
          ]]
        </tbody>
      </table>
    </div>
  </div>
</div>
]=]{
    prefix = self.node.uri,
    folders = self.node:children(),
    files = function ()
        for _, name in ipairs(self.node:files()) do
            local unit, size = '', lfs.attributes(self.node.path .. name, 'size')
            if 99 < size then
                size = size / 1024
                unit = 'KB'
            end
            if 99 < size then
                size = size / 1024
                unit = 'MB'
            end
            if 99 < size then
                size = size / 1024
                unit = 'GB'
            end
            size = math.ceil(100 * size) / 100
            self.c.yield{
                name = name,
                size = size .. unit
            }
        end
    end
}
end

return page
