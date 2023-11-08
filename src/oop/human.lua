---
--- Created by SmartWalle.
--- DateTime: 2023/11/8 19:54
---

local Human = {}

function Human:new()
    local human = {
        name = "--",
        birthday = "0000-00-00"
    }
    setmetatable(human, self)
    self.__index = self
    return human
end

function Human:getName()
    return self.name
end

function Human:setName(name)
    self.name = name
end

function Human:getBirthday()
    return self.birthday
end

function Human:setBirthday(birthday)
    self.birthday = birthday
end

return {
    new = function()
        return Human:new()
    end
}