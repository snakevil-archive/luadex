local class = require 'class'

--- 影片节点页面组件
-- @module view/movie
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type View.Movie
local page = class'View.Movie':extends'View.Node'

--- 扩展页面样式表链接
-- @function css
-- @return string
-- @usage local html = page:css()
function page:css()
  return [=[
<link href="//cdn.bootcss.com/video.js/5.19.0/video-js.min.css" rel="stylesheet">
<link href="//cdn.bootcss.com/fancybox/3.0.47/jquery.fancybox.min.css" rel="stylesheet">
]=]
end

--- 扩展页面脚本链接
-- @function js
-- @return string
-- @usage local html = page:js()
function page:js()
  return [=[
<script src="//cdn.bootcss.com/video.js/5.19.0/video.min.js"></script>
<script src="//cdn.bootcss.com/fancybox/3.0.47/jquery.fancybox.min.js"></script>
]=] .. page:super():masonry()
end

--- 生成页头部分 HTML
-- @function header
-- @return string
-- @usage local html = page:header()
function page:header()
    local info, context = self.node.info, {
        width = 720,
        height = 404,
        ratio = '16:9',
        ['if'] = self.c.cif,
        title = self.node.name
    }
    if 0 < #info then
        context.width = info.video.width:gsub(' p.+$', ''):gsub('%s+', '')
        context.height = 0 + info.video.height:gsub(' p.+$', ''):gsub('%s+', '')
        context.ratio = info.video.display_aspect_ratio
    end
    return self.c.f[=[
<div class="row">
  <div class="col-xs-12 col-md-8 col-md-offset-2">
    <video class="video-js" controls preload="auto" poster="cover.jpg" width="$width" height="$height" data-setup='{"aspectRatio": "$ratio"}' style="margin:0 auto">
      <source src="movie.mp4">
    </video>
    <h2>
      $title
      $if{ $height > 719 }[[
        <span class="label label-success">HD</span>
      ]][[
        <span class="label label-warning">SD</span>
      ]]
    </h2>
  </div>
</div>
]=](context)
end

--- 生成正文部分 HTML
-- @function body
-- @return string
-- @usage local html = page:body()
function page:body()
    local context = {
        ['if'] = self.c.cif,
        node = self.node,
        actorset = self.node:actorset(),
        seriesset = self.node:seriesset(),
        metag = function ()
            for k, v in pairs(self.node:metadata()) do
                if 'title' ~= k and 'series' ~= k and 'actors' ~= k and 'links' ~= k then
                    self.c.yield{
                        tag = k:sub(1, 1):upper() .. k:sub(2):lower(),
                        value = v:gsub('%s+', '')
                    }
                end
            end
        end,
        links = function ()
            for k, v in pairs(self.node.links) do
                self.c.yield{
                    title = k,
                    url = v
                }
            end
        end,
        has_snaps = 0 < #self.node:files(),
        snaps = function ()
            for _, file in ipairs(self.node:files()) do
                self.c.yield(file)
            end
        end,
        ratio = '16:9',
        bitrate = '',
        vformat = 'AVC',
        aformat = 'AAC'
    }
    if 0 < #self.node.info then
        context.ratio = self.node.info.video.display_aspect_ratio
        context.bitrate = self.node.info.general.overall_bit_rate:gsub('%s+', '')
        context.vformat = self.node.info.video.format
        context.aformat = self.node.info.audio.format
    end
    return self.c.f[=[
<div class="panel panel-warning">
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
  <div class="panel-footer text-right text-danger">
    $ratio $bitrate
    $vformat+$aformat
  </div>
</div>
$if{ $has_snaps }[[
  <div class="row masonry">
    $snaps[[
      <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3 item">
        <a href="$node|uri$it" data-fancybox="snaps">
          <img class="img-responsive img-thumbnail" src="$node|uri$it">
        </a>
      </div>
    ]]
  </div>
]]
]=](context)
end

return page
