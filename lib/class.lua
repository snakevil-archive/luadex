--- 类化机制控制组件
-- @module class
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @type Base
-- @field __class 类名
class = setmetatable({
    __class = 'Base'
}, {
    __call = function ( self, name )
        local derived = setmetatable({
            __class = name
        }, self)
        derived.__index = derived
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
        function derived.__tostring ( self )
            return derived:super().__tostring(self)
        end
        return derived
    end
})
class.__index = class

--- 根据类名加载类
-- @function load
-- @param name 类名
-- @return Base
-- @usage local component = class.load'Node.Node'
function class.load( name )
    return require(tostring(name):lower():gsub('%.', '/'))
end

--- 继承类
-- @function extends
-- @param name 类名
-- @return Base
-- @usage local component = class:extends'Node.Node'
function class:extends( name )
    return setmetatable(self, self.load(name))
end

--- 获取（原型）类
-- @function proto
-- @return Base
-- @usage local proto = class:proto()
-- @usage local proto = instance:proto()
function class:proto()
    local is, super = rawget(self, '__class'), getmetatable(self)
    if is then
        return self
    else
        return super
    end
end

--- 获取父类
-- @function super
-- @return Base
-- @usage local super = class:super()
-- @usage local super = instance:super()
function class:super()
    local is, super = rawget(self, '__class'), getmetatable(self)
    if is then
        return super
    else
        return getmetatable(super)
    end
end

--- 生成类实例
-- @function new
-- @param props 属性表
-- @return Base
-- @usage local instance = class:new{ a = '1', b = 2 }
function class:new( props )
    local instance = setmetatable(props, self)
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
    if rawget(data, '__class') then
        return '<' .. data.__class .. '>'
    end
    local table, export, empty, fields = data, "{\n", true, {
        __class = true,
        __index = true
    }
    while table do
        for k, v in pairs(table) do
            if not fields[k] then
                fields[k] = true
                empty = false
                export = export .. margin .. indent .. k .. ' = ' .. var_export(v, margin .. indent) .. ",\n"
            end
        end
        table = getmetatable(table)
    end
    if empty then
        export = export:sub(1, -2) .. '}'
    else
        export = export:sub(1, -3) .. "\n" .. margin .. '}'
    end
    if data.__class then
        export = '<' .. data.__class .. '> ' .. export
    end
    return export
end

--- 转化为字符串
-- @function __tostring
-- @return string
-- @usage local dump = tostring(instance)
function class:__tostring()
    return var_export(self)
end

--- 打印数据内容
-- @function dump
-- @param data 任意数据
-- @usage class.dump(data)
function class.dump( data )
    print(var_export(data))
end
