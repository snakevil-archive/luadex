require 'class'

--- 页面工厂组件
-- @module view/factory
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type View.Factory
local factory = class'View.Factory'

--- 根据节点生成视图
-- @function parse
-- @param Model.Node 节点
-- @return View.Node
-- @usage local page = factory:parse(movie)
function factory:parse( node )
    if not node.type then
        error('invalid node')
    end
    return class.load(node.__class:gsub('^Model%.', 'View.')):new(node)
end

return factory:new{}
