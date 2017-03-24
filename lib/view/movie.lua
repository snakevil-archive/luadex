require 'class'

--- 影片节点页面组件
-- @module view/movie
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type View.Movie
local page = class'View.Movie':extends'View.Node'

--- 扩展页面样式表链接
-- @function css
-- @param cosmo
-- @return string
-- @usage local html = page:css(cosmo)
function page:css(cosmo)
  return [=[
<link href="//cdn.bootcss.com/video.js/5.19.0/video-js.min.css" rel="stylesheet">
<style class="vjs-styles-defaults">
.video\-js { margin: 0 auto }
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
<script src="//cdn.bootcss.com/video.js/5.19.0/video.min.js"></script>
]=]
end

--- 生成页头部分 HTML
-- @function header
-- @param cosmo
-- @return string
-- @usage local html = page:header(cosmo)
function page:header( cosmo )
    local info = self.node.info
    return cosmo.f[=[
<div class="row">
  <div class="col-xs-12 col-md-8 col-md-offset-2">
    <video class="video-js" controls preload="auto" poster="cover.jpg" width="$width" height="$height" data-setup='{"aspectRatio": "$ratio"}'>
      <source src="movie.mp4">
    </video>
    <h2>
      $title
      $if{ $height > 719 }[[
        <span class="label label-primary">HD</span>
      ]][[
        <span class="label label-default">SD</span>
      ]]
    </h2>
  </div>
</div>
]=]{
    width = info.video.width:gsub(' p.+$', ''),
    height = 0 + info.video.height:gsub(' p.+$', ''),
    ratio = info.video.display_aspect_ratio,
    ['if'] = cosmo.cif,
    title = self.node.name
}
end

--- 生成正文部分 HTML
-- @function body
-- @param cosmo
-- @return string
-- @usage local html = page:body(cosmo)
function page:body( cosmo )
    return cosmo.f[=[
<div class="panel panel-info">
  $if{ $node|actress }[[
    <div class="panel-heading">
      <ul class="list-inline">
        $node|actress[[
          <li>
            $if{ $actorset }[[
              <a href="$actorset|uri$it/">$it</a>
            ]][[
              $it
            ]]
          </li>
        ]]
      </ul>
    </div>
  ]]
  <div class="panel-body">
    <dl class="dl-horizontal">
      $if{ $node|id }[[
        <dt>ID</dt>
        <dd>$node|id</dd>
      ]]
      <dt>Year</dt>
      <dd>$node|date</dd>
      $if{ $node|series }[[
        <dt>Series</dt>
        <dd>
          $if{ $seriesset }[[
            <a href="$seriesset|uri$node|series/">$node|series</a>
          ]][[
            $node|series
          ]]
        </dd>
      ]]
      <dt>Summary</dt>
      <dd>$node|summary</dd>
    </dl>
  </div>
  <div class="panel-footer text-right">
    $node|info|video|display_aspect_ratio $node|info|general|overall_bit_rate
    $node|info|video|format+$node|info|audio|format
  </div>
</div>
]=]{
    ['if'] = cosmo.cif,
    node = self.node,
    actorset = self.node:actorset(),
    seriesset = self.node:seriesset()
}
end

return page
