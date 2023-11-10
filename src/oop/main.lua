---
--- Created by SmartWalle.
--- DateTime: 2023/11/8 19:59
---

local Human = require("human")
local h1 = Human.new()
h1:setName("h1")
h1:setBirthday("2001-01-01")
print(h1:getName(), h1:getBirthday())

local Student = require("student")
local s1 = Student.new()
s1:setName("s1")
s1:setBirthday("2002-02-02")
s1:setNumber(10)
print(s1:getName(), s1:getBirthday(), s1:getNumber())

print("word")