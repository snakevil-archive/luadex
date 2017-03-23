if not ngx.var.luadex then
    ngx.say'$luadex should be set.'
    ngx.exit(ngx.ERROR)
end

package.path = nginx.var.luadex .. '/lib/?.lua;' .. package.path

ngx.say(require'dispatch'(ngx.var.request_filename, ngx.var.request_uri))
