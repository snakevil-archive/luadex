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
    local name = 'View.' .. node.type:sub(1, 1):upper() .. node.type:sub(2, #node.type)
    return class.load(name):new(node)
end

return factory:new{}
