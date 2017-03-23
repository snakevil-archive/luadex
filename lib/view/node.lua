require 'class'

--- 基础节点页面组件
-- @module view/node
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type View.Node
local page = class'View.Node'

--- 对应节点
-- @field Model.Node
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
    return self.node.path
end

return page
