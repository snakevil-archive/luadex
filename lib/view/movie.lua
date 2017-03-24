local class = require 'class'

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
<link href="//cdn.bootcss.com/fancybox/3.0.47/jquery.fancybox.min.css" rel="stylesheet">
<style class="vjs-styles-defaults">
.jumbotron.end { margin-bottom: 0 }
.video\-js { margin: 0 auto }
.col\-lg\-3 { margin-bottom: 15px }
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
<script src="//cdn.bootcss.com/masonry/4.1.1/masonry.pkgd.min.js"></script>
<script src="//cdn.bootcss.com/fancybox/3.0.47/jquery.fancybox.min.js"></script>
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
    width = info.video.width:gsub(' p.+$', ''):gsub('%s+', ''),
    height = 0 + info.video.height:gsub(' p.+$', ''):gsub('%s+', ''),
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
  $if{ $node|actors }[[
    <div class="panel-heading">
      <ul class="list-inline">
        $node|actors[[
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
      $metag[[
        <dt>$tag</dt>
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
  <div class="panel-footer text-right">
    $node|info|video|display_aspect_ratio $bitrate
    $node|info|video|format+$node|info|audio|format
  </div>
</div>
$if{ $snaps }[[
  <div class="row" data-masonry='{"itemSelector":".col-lg-3"}'>
    $snaps[[
      <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
        <a href="$node|uri$it" data-fancybox="snaps">
          <img class="img-responsive img-thumbnail" src="$node|uri$it">
        </a>
      </div>
    ]]
  </div>
]]
]=]{
    ['if'] = cosmo.cif,
    node = self.node,
    actorset = self.node:actorset(),
    seriesset = self.node:seriesset(),
    metag = function ()
        for k, v in pairs(self.node:metadata()) do
            if 'title' ~= k and 'series' ~= k and 'actors' ~= k and 'links' ~= k then
                cosmo.yield{
                    tag = k:sub(1, 1):upper() .. k:sub(2):lower(),
                    value = v
                }
            end
        end
    end,
    links = function ()
        for k, v in pairs(self.node.links) do
            cosmo.yield{
                title = k,
                url = v
            }
        end
    end,
    snaps = (function ()
        local snaps = {}
        for _, file in ipairs(self.node:files()) do
            if 'snap-' == file:sub(1, 5) and '.jpg' == file:sub(-4) then
                table.insert(snaps, file)
            end
        end
        table.sort(snaps)
        return snaps
    end)(),
    bitrate = self.node.info.general.overall_bit_rate:gsub('%s+', '')
}
end

return page
