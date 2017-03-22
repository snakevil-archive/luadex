--- 类化机制控制组件
-- @module class
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Base
-- @field __class 类名
local component = setmetatable({
    __class = 'Base'
}, {
    __call = function ( self, name )
        local class = setmetatable({
            __class = name
        }, self)
        class.__index = class
        return class
    end
})
component.__index = component

--- 根据类名加载类
-- @function load
-- @param class 类名
-- @return Base
-- @usage local component = class.load'Node.Node'
function component.load( class )
    return require(tostring(class):lower():gsub('%.', '/'))
end

-- 继承类
-- @function extends
-- @param class 类名
-- @return Base
-- @usage local component = class:extends'Node.Node'
function component:extends( class )
    return setmetatable(self, component.load(class))
end

-- 获取父类
-- @function super
-- @return Base
-- @usage local super = class:super()
function component:super()
    return getmetatable(self)
end

-- 生成类实例
-- @function new
-- @param props 属性表
-- @param class 可选。原型类
-- @return Base
-- @usage local instance = class:new{ a = '1', b = 2 }
function component:new( props, class )
    local instance = setmetatable(props, class or self)
    instance.__index = instance
    return instance
end

return component
