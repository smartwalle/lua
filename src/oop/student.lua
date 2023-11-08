---
--- Created by SmartWalle.
--- DateTime: 2023/11/8 19:55
---

local Human = require("human")

local Student = Human.new()

function Student:new()
    local student = {
        number = 0
    }
    setmetatable(student, self)
    self.__index = self
    return student
end

function Student:getNumber()
    return self.number
end

function Student:setNumber(number)
    self.number = number
end

return {
    new = function()
        return Student:new()
    end
}