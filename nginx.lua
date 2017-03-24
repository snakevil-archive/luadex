if not ngx.var.luadex then
    ngx.status = ngx.HTTP_SERVICE_UNAVAILABLE
    ngx.say'$luadex not set.'
    ngx.exit(ngx.OK)
end

local incpath = ngx.var.luadex .. '/lib/?.lua;'
if package.path:sub(1, #incpath) ~= incpath then
    package.path = incpath .. package.path
end

local succeed, html = pcall(require'dispatch', ngx.var.request_filename, ngx.var.request_uri)
if not succeed then
    ngx.status = ngx.HTTP_SERVICE_UNAVAILABLE
    ngx.log(ngx.ERR, html)
    ngx.exit(ngx.OK)
end
ngx.say(html)
