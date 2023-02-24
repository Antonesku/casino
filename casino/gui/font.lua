local brail = require("/lib/braille")
local component = require("component")
local gpu = component.gpu

local font = {}
local numbers = {}
local symbols = {}

local function createNumbers()
    local zero = brail.matrix(5, 7)
    brail.line(zero, 2, 1, 4, 1)
    brail.line(zero, 2, 7, 4, 7)
    brail.line(zero, 1, 2, 1, 6)
    brail.line(zero, 5, 2, 5, 6)
    brail.set(zero, 2, 5, 1)
    brail.set(zero, 3, 4, 1)
    brail.set(zero, 4, 3, 1)

    numbers[0] = zero

    local one = brail.matrix(5,7)
    brail.line(one, 3, 1, 3, 7)
    brail.line(one, 1, 7, 5, 7)
    brail.set(one, 2, 2, 1)
    
    numbers[1] = one

    local two = brail.matrix(5,7)
    brail.set(two, 1, 2, 1)
    brail.line(two, 2, 1, 4, 1)
    brail.line(two, 5, 2, 5, 3)
    brail.line(two, 3, 4, 4, 4)
    brail.set(two, 2, 5, 1)
    brail.set(two, 1, 6, 1)
    brail.line(two, 1, 7, 5, 7)
    brail.set(two, 5, 6, 1)

    numbers[2] = two

    local three = brail.matrix(5, 7)
    brail.set(three, 1, 2, 1)
    brail.line(three, 2, 1, 4, 1)
    brail.line(three, 5, 2, 5, 3)
    brail.line(three, 3, 4, 4, 4)
    brail.line(three, 5, 5, 5, 6)
    brail.line(three, 2, 7, 4, 7)
    brail.set(three, 1, 6, 1)

    numbers[3] = three

    local four = brail.matrix(5, 7)
    brail.line(four, 5, 1, 5, 7)
    brail.line(four, 1, 5, 7, 5)
    brail.line(four, 1, 4, 4, 1)

    numbers[4] = four

    local five = brail.matrix(5, 7)
    brail.line(five, 1, 1, 5, 1)
    brail.set(five, 1, 2, 1)
    brail.line(five, 1, 3, 4, 3)
    brail.line(five, 5, 4, 5, 6)
    brail.line(five, 2, 7, 4, 7)
    brail.set(five, 1, 6, 1)

    numbers[5] = five

    local six = brail.matrix(5, 7)
    brail.line(six, 3, 1, 4, 1)
    brail.set(six, 2, 2, 1)
    brail.line(six, 1, 3, 1, 6)
    brail.line(six, 5, 5, 5, 6)
    brail.line(six, 2, 4, 4, 4)
    brail.line(six, 2, 7, 4, 7)

    numbers[6] = six

    local seven = brail.matrix(5, 7)
    brail.set(seven, 1, 2, 1)
    brail.line(seven, 1, 1, 5, 1)
    brail.line(seven, 5, 2, 5, 3)
    brail.set(seven, 4, 4, 1)
    brail.line(seven, 3, 5, 3, 7)

    numbers[7] = seven

    local eight = brail.matrix(5, 7)
    brail.line(eight, 2, 1, 4, 1)
    brail.line(eight, 1, 2, 1, 3)
    brail.line(eight, 5, 2, 5, 3)
    brail.line(eight, 2, 4, 4, 4)
    brail.line(eight, 1, 5, 1, 6)
    brail.line(eight, 5, 5, 5, 6)
    brail.line(eight, 2, 7, 4, 7)

    numbers[8] = eight

    local nine = brail.matrix(5, 7)
    brail.line(nine, 2, 1, 4, 1)
    brail.line(nine, 1, 2, 1, 3)
    brail.line(nine, 5, 2, 5, 5)
    brail.line(nine, 2, 4, 4, 4)
    brail.set(nine, 4, 6, 1)
    brail.line(nine, 2, 7, 4, 6)

    numbers[9] = nine

    local dot = brail.matrix(1,7)
    brail.set(dot, 1, 7, 1)

    numbers["."] = dot
end

local function createSymbols()
    local zero = brail.matrix(5, 7)
    brail.line(zero, 2, 1, 4, 1)
    brail.line(zero, 2, 7, 4, 7)
    brail.line(zero, 1, 2, 1, 6)
    brail.line(zero, 5, 2, 5, 6)
    brail.set(zero, 2, 5, 1)
    brail.set(zero, 3, 4, 1)
    brail.set(zero, 4, 3, 1)

    symbols[0] = zero

    local one = brail.matrix(5,7)
    brail.line(one, 3, 1, 3, 7)
    brail.line(one, 1, 7, 5, 7)
    brail.set(one, 2, 2, 1)
    
    symbols[1] = one

    local two = brail.matrix(5,7)
    brail.set(two, 1, 2, 1)
    brail.line(two, 2, 1, 4, 1)
    brail.line(two, 5, 2, 5, 3)
    brail.line(two, 3, 4, 4, 4)
    brail.set(two, 2, 5, 1)
    brail.set(two, 1, 6, 1)
    brail.line(two, 1, 7, 5, 7)
    brail.set(two, 5, 6, 1)

    symbols[2] = two

    local three = brail.matrix(5, 7)
    brail.set(three, 1, 2, 1)
    brail.line(three, 2, 1, 4, 1)
    brail.line(three, 5, 2, 5, 3)
    brail.line(three, 3, 4, 4, 4)
    brail.line(three, 5, 5, 5, 6)
    brail.line(three, 2, 7, 4, 7)
    brail.set(three, 1, 6, 1)

    symbols[3] = three

    local four = brail.matrix(5, 7)
    brail.line(four, 5, 1, 5, 7)
    brail.line(four, 1, 5, 7, 5)
    brail.line(four, 1, 4, 4, 1)

    symbols[4] = four

    local five = brail.matrix(5, 7)
    brail.line(five, 1, 1, 5, 1)
    brail.set(five, 1, 2, 1)
    brail.line(five, 1, 3, 4, 3)
    brail.line(five, 5, 4, 5, 6)
    brail.line(five, 2, 7, 4, 7)
    brail.set(five, 1, 6, 1)

    symbols[5] = five

    local six = brail.matrix(5, 7)
    brail.line(six, 3, 1, 4, 1)
    brail.set(six, 2, 2, 1)
    brail.line(six, 1, 3, 1, 6)
    brail.line(six, 5, 5, 5, 6)
    brail.line(six, 2, 4, 4, 4)
    brail.line(six, 2, 7, 4, 7)

    symbols[6] = six

    local seven = brail.matrix(5, 7)
    brail.set(seven, 1, 2, 1)
    brail.line(seven, 1, 1, 5, 1)
    brail.line(seven, 5, 2, 5, 3)
    brail.set(seven, 4, 4, 1)
    brail.line(seven, 3, 5, 3, 7)

    symbols[7] = seven

    local eight = brail.matrix(5, 7)
    brail.line(eight, 2, 1, 4, 1)
    brail.line(eight, 1, 2, 1, 3)
    brail.line(eight, 5, 2, 5, 3)
    brail.line(eight, 2, 4, 4, 4)
    brail.line(eight, 1, 5, 1, 6)
    brail.line(eight, 5, 5, 5, 6)
    brail.line(eight, 2, 7, 4, 7)

    symbols[8] = eight

    local nine = brail.matrix(5, 7)
    brail.line(nine, 2, 1, 4, 1)
    brail.line(nine, 1, 2, 1, 3)
    brail.line(nine, 5, 2, 5, 5)
    brail.line(nine, 2, 4, 4, 4)
    brail.set(nine, 4, 6, 1)
    brail.line(nine, 2, 7, 4, 6)

    symbols[9] = nine

    local dot = brail.matrix(3,7)
    brail.set(dot, 2, 7, 1)

    symbols["."] = dot

    ----------------------------------
    local br = brail
    local mx = br.matrix

    local a = brail.matrix(5, 7)
    br.line(a, 2, 3, 4, 3)
    br.line(a,5,4,5,7)
    br.line(a,2,7,4,7)
    br.set(a,1,6,1)
    br.line(a,2,5,4,5)

    symbols["a"] = a

    local b = mx(5,7)
    br.line(b,1,1,1,7)
    br.line(b,1,7,4,7)
    br.line(b,5,4,5,6)
    br.line(b,3,3,4,3)
    br.set(b,2,4,1)

    symbols["b"] = b

    local c = mx(5,7)
    br.set(c, 5,4,1)
    br.line(c,2,3,4,3)
    br.line(c,1,4, 1,6)
    br.line(c,2,7,4,7)
    br.set(c,5,6,1)

    symbols["c"] = c

    local d = mx(5,7)
    br.line(d,5,1,5,7)
    br.line(d,2,7,5,7)
    br.line(d,1,4,1,6)
    br.line(d,2,3,3,3)
    br.set(d,4,4,1)

    symbols["d"] = d

    local e = mx(5,7)
    br.line(e,2,3,4,3)
    br.line(e,1,4,1,6)
    br.line(e,2,7,5,7)
    br.line(e,2,5,5,5)
    br.set(e, 5, 4, 1)

    symbols["e"] = e

    local f = mx(5,7)
    br.line(f, 2,2,2,7)
    br.line(f,1,3,4,3)
    br.line(f,3,1,4,1)

    symbols["f"] = f

    local g = mx(5,8)

    br.line(g, 2,3,5,3)
    br.line(g,1,4,1,5)
    br.line(g,2,6,5,6)
    br.line(g,5,3,5,7)
    br.line(g,1,8,4,8)

    symbols["g"] = g

    local h = mx(5,7)
    br.line(h,1,1,1,7)
    br.set(h,2,4,1)
    br.line(h,3,3,4,3)
    br.line(h,5,4,5,7)

    symbols["h"] = h

    local i = mx(1,7)

    br.set(i, 1,1,1)
    br.line(i, 1,3,1,7)

    symbols["i"] = i

    local j = mx(5,8)

    br.set(j,5,3,1)
    br.line(j,5,5,5,7)
    br.line(j,2,8,4,8)
    br.line(j,1,6,1,7)

    symbols["j"] = j

    local k = mx(5,7)

    br.line(k,1,1,1,7)
    br.set(k,2,5,1)
    br.set(k,3,4,1)
    br.set(k,4,3,1)
    br.set(k,3,6,1)
    br.set(k,4,7,1)

    symbols["k"] = k

    local l = mx(3,7)

    br.line(l,1,1,1,6)
    br.set(l,2,7,1)

    symbols["l"] = l

    local m = mx(5,7)

    br.line(m,1,3,1,7)
    br.set(m,2,3,1)
    br.line(m,3,4,3,5)
    br.set(m,4,3,1)
    br.line(m,5,4,5,7)

    symbols["m"] = m

    local n = mx(5,7)

    br.line(n,1,3,1,7)
    br.line(n,1,3,4,3)
    br.line(n,5,4,5,7)

    symbols["n"] = n

    local o = mx(5,7)

    br.line(o, 2,3,4,3)
    br.line(o,1,4,1,6)
    br.line(o,2,7,4,7)
    br.line(o,5,4,5,6)

    symbols["o"] = o

    local p = mx(5,8)

    br.line(p,1,3,1,8)
    br.set(p,2,4,1)
    br.line(p,3,3,4,3)
    br.line(p,5,4,5,5)
    br.line(p,2,6,4,6)

    symbols["p"] = p

    local q = mx(5,8)

    br.line(q,5,3,5,8)
    br.set(q,4,4,1)
    br.line(q,2,3,3,3)
    br.line(q,1,4,1,5)
    br.line(q,2,6,4,6)

    symbols["q"] = q

    local r = mx(5,7)

    br.line(r,1,3,1,7)
    br.set(r,2,4,1)
    br.line(r,3,3,4,3)
    br.set(r,5,4,1)

    symbols["r"] = r

    local s = mx(5,7)

    br.line(s,2,3,5,3)
    br.set(s,1,4,1)
    br.line(s,2,5,4,5)
    br.set(s,5,6,1)
    br.line(s,1,7,4,7)

    symbols["s"] = s

    local t = mx(3,7)

    br.line(t,2,1,2,6)
    br.line(t,1,3,3,3)
    br.set(t,3,7,1)

    symbols["t"] = t

    local u = mx(5,7)

    br.line(u,1,3,1,6)
    br.line(u,2,7,5,7)
    br.line(u,5,3,5,7)

    symbols["u"] = u

    local v = mx(5,7)

    br.line(v,1,3,1,5)
    br.set(v,2,6,1)
    br.set(v,3,7,1)
    br.set(v,4,6,1)
    br.line(v, 5,3,5,5)

    symbols["v"] = v

    local w = mx(5,7)

    br.line(w,1,3,1,6)
    br.line(w,2,7,5,7)
    br.line(w,3,5,3,6)
    br.line(w,5,3,5,7)

    symbols["w"] = w

    local x = mx(5,7)

    br.line(x,1,3,5,7)
    br.line(x,5,3,1,7)

    symbols["x"] = x

    local y = mx(5,8)

    br.line(y,1,3,1,5)
    br.line(y,2,6,5,6)
    br.line(y,5,3,5,7)
    br.line(y,2,8,4,8)

    symbols["y"] = y

    local z = mx(5,7)

    br.line(z,1,3,5,3)
    br.line(z,1,7,5,7)
    br.line(z,4,4,2,6)

    symbols["z"] = z

    local underscores = mx(5,7)

    br.line(underscores,1,7,5,7)

    symbols["_"] = underscores

    local minus = mx(5,7)
    br.line(minus,1,5,5,5)

    symbols["-"] = minus





end

font.drawNumber = function(number, x, y, vertical)
    local strNumber = tostring(number)
    

    for i = 1, #strNumber do
        local margin = 1
        local nmbr = string.sub(strNumber,i,i)

        if nmbr ~= "." then
            nmbr = tonumber(nmbr)
            margin = 3
        end
        
        local drwNmbr = numbers[nmbr]
        
        brail.render(drwNmbr, x, y)
        x = x + margin
    end
end


font.getNumbers = function()
    return numbers
end

font.drawString = function(str, x, y, vertical)
    for i = 1, #str do
        local margin = 1
        local char = str:sub(i,i)

        if tonumber(char) ~= nil then
            char = tonumber(char)
        end

        brail.render(symbols[char], x, y)
        if char == "i"  then
            margin = 1
        elseif char == "t" or char == "l" or char == "."  then
            margin = 2
        else
            margin = 3
        end

        x = x + margin
        
    end
end


createNumbers()
createSymbols()

return font