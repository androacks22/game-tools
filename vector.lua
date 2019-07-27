--[[
Lua vector
Developer: Deybis Melendez
Web: https://github.com/DeybisMelendez/lua-vector

MIT License

Copyright (c) 2019 Deybis Melendez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local vector = {_VERSION = "v0.5.0", _TYPE = "module", _NAME = "vector"}
local vecMt = {
    __tostring = function(self)
        return self:string()
    end,
    __add = function(a, b)
        if type(a) == "number" then return vector(a + b.x, a + b.y) end
        if type(b) == "number" then return vector(a.x + b, a.y + b) end
        return vector(a.x + b.x, a.y + b.y)
    end,
    __sub = function(a, b)
        if type(a) == "number" then return vector(a - b.x, a - b.y) end
        if type(b) == "number" then return vector(a.x - b, a.y - b) end
        return vector(a.x - b.x, a.y - b.y)
    end,
    __mul = function(a, b)
        if type(a) == "number" then return vector(a * b.x, a * b.y) end
        if type(b) == "number" then return vector(a.x * b, a.y * b) end
        return vector(a.x * b.x, a.y * b.y)
    end,
    __div = function(a, b)
        if type(a) == "number" then return vector(a / b.x, a / b.y) end
        if type(b) == "number" then return vector(a.x / b, a.y / b) end
        return vector(a.x / b.x, a.y / b.y)
    end,
    __unm = function(t)
        return vector(-t.x, -t.y)
    end,
    __eq = function(a, b)
        return a.x == b.x and a.y == b.y
    end,
    __pow = function(vec, value)
        return vector(vec.x ^ value, vec.y ^ value)
    end,
    __concat = function(a, b)
        if type(a) == "string" then return a .. b:string() end
        if type(b) == "string" then return a:string() .. b end
        return a:string() .. b:string()
    end
}
local mt = { -- Metatable of vector
    __call = function(_, x, y)
        local vec = {x = x, y = y}
        function vec:string()
            return "vector(" .. self.x .. ", " .. self.y ..")"
        end
        function vec:angle() -- Radians
            return math.atan2(self.y, self.x)
        end
        function vec:normalized()
            local m = (self.x^2 + self.y^2)^0.5 --magnitude
            self.x, self.y = self.x / m, self.y / m
        end
        function vec:distanceSquaredTo(v)
            local x1, y1 = self.x, self.y
            local x2, y2 = v.x, v.y
            return (x2 - x1)^2 + (y2 - y1)^2
        end
        function vec:distanceTo(v)
            return self:distanceSquaredTo(v)^0.5
        end
        function vec:distanceSquared()
            return self.x^2 + self.y^2
        end
        function vec:distance()
            return (self:distanceSquared())^0.5
        end
        function vec:dot(v)
            return self.x * v.x + self.y * v.y
        end
        function vec:perpDot(v)
            return self.x * v.x - self.y * v.y
        end
        function vec:abs()
            self.x, self.y = math.abs(self.x), math.abs(self.y)
        end
        function vec:round(dec)
            dec = dec or 0
            local mult = 10^(dec)
            local nx, ny
            if self.x >= 0 then nx = math.floor(self.x * mult + 0.5) / mult
            else nx = math.ceil(self.x * mult - 0.5) / mult end
            if self.y >= 0 then ny = math.floor(self.y * mult + 0.5) / mult
            else ny = math.ceil(self.y * mult - 0.5) / mult end
            self.x, self.y = nx, ny
        end
        function vec:toPolar(angle, len)
            len = len or 1
            self.x, self.y = math.cos(angle) * len, math.sin(angle) * len
        end
        function vec:rotated(phi)
            self.x = math.cos(phi) * self.x - math.sin(phi) * self.y
            self.y = math.sin(phi) * self.x + math.cos(phi) * self.y
        end
        function vec:cross(v)
            return self.x * v.y - self.y * v.x
        end
        function vec:perpendicular()
            self.x = -self.y
            self.y = self.x
        end
        function vec:lerpTo(v, t)
            local i = 1 - t
            self.x, self.y = self.x * i + v.x * t, self.y * i + v.y * t
        end
        function vec:unpack()
            return self.x, self.y
        end
        setmetatable(vec, vecMt)
        return vec
    end
}

setmetatable(vector, mt)

-- CONSTANTS

vector.DOWN = vector(0, 1)
vector.UP = vector(0, -1)
vector.LEFT = vector(-1, 0)
vector.RIGHT = vector(1, 0)
vector.ZERO = vector(0, 0)
vector.ONE = vector(1, 1)

return vector
