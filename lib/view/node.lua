require 'class'

--- 基础节点页面组件
-- @module view/node
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type View.Node
local page = class'View.Node'

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
    local cosmo = require'cosmo'
    return cosmo.f[=[
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
  <script src="//cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
  <script src="//cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  $js
</body>
</html>
]=]{
    css = self:css(cosmo),
    js = self:js(cosmo),
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
    header = self:header(cosmo),
    body = self:body(cosmo)
}:gsub('>%s+', '>'):gsub('%s+<', '<')
end

--- 扩展页面样式表链接
-- @function css
-- @param cosmo
-- @return string
-- @usage local html = page:css(cosmo)
function page:css(cosmo)
  return ''
end

--- 扩展页面脚本链接
-- @function js
-- @param cosmo
-- @return string
-- @usage local html = page:js(cosmo)
function page:js(cosmo)
  return ''
end

--- 生成页头部分 HTML
-- @function header
-- @param cosmo
-- @return string
-- @usage local html = page:header(cosmo)
function page:header( cosmo )
    return '<h1>' .. self.node.name .. '</h1>'
end

--- 生成正文部分 HTML
-- @function body
-- @param cosmo
-- @return string
-- @usage local html = page:body(cosmo)
function page:body( cosmo )
    return cosmo.f[=[
<div class="table-responsive">
  <table class="table table-hover">
    <tbody>
      $folders[[
      <tr>
        <td>
          <a href="$uri">$name</a>/
        </td>
      </tr>
      ]]
    </tbody>
    <tbody>
      $files[[
      <tr>
        <td>
            <a href="$prefix$it">$it</a>
        </td>
      </tr>
      ]]
    </tbody>
  </table>
</div>
]=]{
    prefix = self.node.uri,
    folders = self.node:children(),
    files = self.node:files()
}
end

return page
