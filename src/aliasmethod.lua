---
--- Created by yang.
--- DateTime: 2023/11/21 12:32
---

--- 示例：
--- local AliasMethod = require("aliasmethod")
--- local method = AliasMethod.new()
--- method:add({ id = 1, weight = 20 })
--- method:add({ id = 2, weight = 20 })
--- method:add({ id = 3, weight = 60 })
--- method:prepare()
---
--- local result = {}
--- for _ = 1, 1000, 1 do
---     local item = method:nextItem()
---     local count = result[item.id]
---     if count == nil then
---         count = 1
---     else
---         count = count + 1
---     end
---     result[item.id] = count
--- end
---
--- for i, v in pairs(result) do
---     print(i, v)
--- end

---
--- 别名算法，主要用于随机抽奖、怪物随机产出道具等。
---@class AliasMethod
---@field private alias table @[]int
---@field private probs table @[]float
---@field private items table @[]table{weight=int, ...}
local AliasMethod = {}

local kProbability = 1.0

function AliasMethod:new()
    local o = {
        alias = {},
        probs = {},
        items = {},
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

--- 添加一个样本数据，样本必须为有一个字段名为 weight 的 table 类型，且 weight 的必须为整数类型。
---
--- 添加样本数据成功返回 true，否则返回 false。
---@param item table @{weight=int, ...}
---@return boolean
---@public
function AliasMethod:add(item)
    if item == nil or type(item) ~= "table" or item.weight == nil or type(item.weight) ~= "number" then
        return false
    end
    table.insert(self.items, item)
    return true
end

--- 用于预处理样本数据，所有样本数据都添加完毕之后，需要调用本方法对样本数据进行处理。
---
--- 预处理成功返回 true，否则返回 false。
---@public
---@return boolean
function AliasMethod:prepare()
    if #self.items == 0 then
        return false
    end

    local total = 0
    for _, v in pairs(self.items) do
        total = total + v.weight
    end

    local scale = total / kProbability

    local probs = {}
    for _, item in pairs(self.items) do
        table.insert(probs, item.weight / scale)
    end

    return self:process(probs)
end

---
---@return boolean
---@private
function AliasMethod:process(probs)
    local pLen = #probs
    local avg = kProbability / pLen
    local smallList = {}
    local largeList = {}

    for i, v in ipairs(probs) do
        self.probs[i] = 0
        self.alias[i] = 0

        if v >= avg then
            table.insert(largeList, i)
        else
            table.insert(smallList, i)
        end
    end

    while (#smallList > 0 and #largeList > 0)
    do
        local less = table.remove(smallList, #smallList)
        local more = table.remove(largeList, #largeList)

        self.probs[less] = probs[less] * pLen
        self.alias[less] = more

        probs[more] = probs[more] + probs[less] - avg

        if probs[more] >= kProbability / pLen then
            table.insert(largeList, more)
        else
            table.insert(smallList, more)
        end
    end

    for _, v in pairs(smallList) do
        self.probs[v] = kProbability
    end

    for _, v in pairs(largeList) do
        self.probs[v] = kProbability
    end

    return true
end

--- 随机获取一个样本数据的索引，索引为调用 add() 方法添加样本的顺序。
---@public
---@return number index
function AliasMethod:next()
    local pLen = #self.probs
    if pLen == 0 then
        return 0
    end

    local index = math.random(1, pLen)
    local value = math.random()

    local coin = value < self.probs[index]
    if coin then
        return index
    end
    return self.alias[index]
end

--- 随机获取一个样本数据。
---@public
---@return table item {weight=int, ...}
function AliasMethod:nextItem()
    local index = self:next()
    if index > 0 then
        return self.items[index]
    end
    return nil
end

return {
    new = function()
        return AliasMethod:new()
    end
}