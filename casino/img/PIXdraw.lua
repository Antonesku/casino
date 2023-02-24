local shl = require("shell")
local com = require("computer")
local cmp = require("component")
local uni = require("unicode")
local trm = require("term")
local gpu = cmp.gpu
local args = shl.parse(...)
local sym = {"▄", "▀", "█", " "}
local b32 = require("bit32")
local args = shl.parse(...)

local function BtoI(str)
  local integer = 0
  for i=1, string.len(str) do
    integer = b32.lshift(integer, 8)  + string.byte(str, i)
  end
  return integer
end

local function BtoS(str, len)
  local out = ""
  local TEMP
  for i=1, #str do
    TEMP = str:byte(i)
    for j=6, 0, -2 do
      out = out..sym[math.floor(TEMP / (2 ^ j)) + 1]
      TEMP = TEMP % (2 ^ j)
    end
  end  
  return out
end

local function r(n)
  IND = IND + n
  return string.sub(STR, IND - n, IND - 1)
end

local function getFile(str)
  file = io.open(str, "rb")
  STR = file:read("*a")
  file:close()
  IND = 1

  --[[ FONE ]]
  
  fone = {BtoI(r(1)), BtoI(r(1)), BtoI(r(3)), BtoI(r(3))}  

  --[[ CLR ]]

  clr = {}

  local lenStr = BtoI(r(2))
  local STRING = BtoS(r(math.ceil(lenStr / 4)), lenStr)

  local function getStr(n) local temp = uni.sub(STRING, 1, n)
    STRING = uni.sub(STRING, n+1)
  return temp
  end
  
  local lenCLR = BtoI(r(2))
  for i=1, lenCLR do
    local F = BtoI(r(3))
    local lenCLR_F = BtoI(r(2))
    clr[F] = {}
    for j=1, lenCLR_F do
      local B = BtoI(r(3))
      local lenCLR_F_B = BtoI(r(2))
      clr[F][B] = {}
      for k=1, lenCLR_F_B do
        local ind = #clr[F][B] + 1
        local x = BtoI(r(1))
        local y = BtoI(r(1))
        local lstr = BtoI(r(1))
        clr[F][B][ind] = {x, y, getStr(lstr)}
      end
    end
  end


  
end

function drawPIX(path, x, y, colorBackground)
  local currentX, currentY
  x = x - 1
  timeFile = com.uptime()
  getFile(path)
  timeFile = com.uptime() - timeFile
  --gpu.setResolution(fone[1], fone[2])
  timeDraw = com.uptime()
  gpu.setBackground(colorBackground)
  gpu.fill(x - 1, y, fone[1], fone[2], " ")
  gpu.setForeground(fone[3])
  gpu.setBackground(fone[4])
  gpu.fill(1 + x,1 + y,fone[1],fone[2], "▄")
  for i, _ in pairs(clr) do
    gpu.setForeground(i)
    for j, _ in pairs(clr[i]) do
      gpu.setBackground(j)
      for k, _ in pairs(clr[i][j]) do
        gpu.set(clr[i][j][k][1] + x, clr[i][j][k][2] + y, clr[i][j][k][3])
      end
    end
  end
  timeDraw = com.uptime() - timeDraw
  gpu.setForeground(0xffffff)
  gpu.setBackground(0x000000)

  return fone[1],fone[2]
end