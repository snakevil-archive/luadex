if not ngx.var.luadex then
    ngx.status = ngx.HTTP_SERVICE_UNAVAILABLE
    ngx.say'$luadex not set.'
    ngx.exit(ngx.OK)
end

package.path = ngx.var.luadex .. '/lib/?.lua;' .. package.path

ngx.say(require'dispatch'(ngx.var.request_filename, ngx.var.request_uri))
