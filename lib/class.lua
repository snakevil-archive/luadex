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
            --- 字符串类型转化机制
            -- 至 LuaJIT-2.0.4 为止，`tostring()` 函数都只会检查并调用**元表**的 `__tostring` 函数。
            --
            -- ```
            -- print(setmetatable({
            --     __tostring = function ( self )
            --         return '3'
            --     end
            -- }, setmetatable({
            --     __tostring = function ( self )
            --         return '2'
            --     end
            -- }, {
            --     __tostring = function ( self )
            --         return '1'
            --     end
            -- })))
            -- ```
            --
            -- 在上面的案例中，输出内容是 `2`。如果将该函数定义删除，输出内容就变成了 `table: 0x01c773b8` 这样的值。
            --
            -- 转以面向对象的思维来理解，`3` 是类的实例，`2` 是类，`1` 是父类。
            --
            -- 因此为了能够使用本基类统一的 `__tostring` 方法，在定义每个派生类时，都需要显性地定义派生类中的方法，使其能逐层递归调用至基类。
            __tostring = function ( self )
                return getmetatable(self):super().__tostring(self)
            end,
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

--- 导出数据内容
-- @param data 任意数据
-- @param margin 可选。缩进
-- @return string
local function var_export( data, margin )
    local kind, indent, margin = type(data), '  ', margin or ''
    if 'function' == kind or 'thread' == kind or 'userdata' == kind then
        return '<' .. tostring(data) .. '>'
    elseif 'string' == kind then
        return string.format('%q', data)
    elseif 'table' ~= kind then
        return tostring(data)
    end
    local table, export, fields = data, "{\n", {
        __class = true,
        __index = true
    }
    while table do
        for k, v in pairs(table) do
            if not fields[k] then
                fields[k] = true
                export = export .. margin .. indent .. k .. ' = ' .. var_export(v, margin .. indent) .. ",\n"
            end
        end
        table = getmetatable(table)
    end
    export = export:sub(1, -3) .. "\n}"
    if data.__class then
        export = '<' .. data.__class .. '> ' .. export
    end
    return export
end

-- 转化为字符串
-- @function __tostring
-- @return string
-- @usage local dump = tostring(instance)
function component:__tostring()
    return var_export(self)
end

return component
