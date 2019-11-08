--[[Basic class library:
  This simple class lib is added to engine.class, you can create a new class by calling:-
  
  local new_class = engine.class:extend()
  
  Extend does support multiclassing so you can pass another class as an argument to extend.
]]
local class = {}

function class:extend(subClass)
  return setmetatable(subClass or {}, {__index = self})
end

function class:new(...)
  local inst = setmetatable({}, {__index = self})
  return inst, inst:init(...)
end

function class:init(...) end

--[[Recursive Load:
  Recursively load files and store them in a table.
]]

local enet = require("enet")

game = {}
engine = {
  class = class,
  host = enet.host_create("*:6790"),
}

function scandir(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls -a "'..directory..'"')
  for filename in pfile:lines() do
    i = i + 1
    t[i] = filename
  end
  pfile:close()
  return t
end

local function getFile(tab, path, folder, file)
  if tab[folder] == nil then
    print("Loading: Creating table engine."..folder)
    tab[folder] = {}
  end
  local ext = string.sub(file, #file - 3, #file)
  file = string.sub(file, 1, #file - 4)
  local filePath = path.."/"..folder.."/"..file
  if ext == ".lua" then
    tab[folder][file] = require(path.."."..folder.."."..file)
  end
  if tab[folder][file] ~= nil then
    print("Loaded : engine."..folder.."."..file)
  end
end

local function getFiles(tab, path, folder)
  local filePath = path
  if folder == nil then
    folder = ""
  else
    filePath = path.."/"..folder
  end
  print("Loading: Checking "..filePath)
  local data = scandir(filePath)
  for i = 1, #data do
    local file = data[i]
    if file ~= "." and file ~= ".." then
      local f = io.open(filePath.."/"..file, "r")
      local x,err=f:read(1)
      if err == "Is a directory" then
        if folder ~= "" then
          getFiles(tab, filePath, file)
        else
          getFiles(tab, path, file)
        end
      else
        getFile(tab, path, folder, file)
      end
    end
  end
end

--[[Debug Functions:
  
]]

local function format_time(s)
  local secs = engine.string.r_pad(tostring(s % 60), 2, "0")
  local mins = engine.string.r_pad(tostring(math.floor(s / 60) % 60), 2, "0")
  local hours = engine.string.r_pad(tostring(math.floor(s / (60 * 60 * 24)) % 24), 2, "0")
  return hours..":"..mins..":"..secs
end

function engine.debug_text(key, value)
  local index = #engine.debug_log + 1
  if engine.debug_mode then
    if engine.debug_log[key] then
      index = engine.debug_log[key].index
      if engine.debug_log[key].value == value then
        engine.debug_log[key].last = value
        return
      end
    else
      engine.debug_log[key] = {
        value = value,
        index = index,
        last = "",
      }
      engine.debug_count = engine.debug_count + 1
      engine.debug_draw[engine.debug_count] = key
      return
    end
    engine.debug_log[key].changed = true
    engine.debug_log[key].value = value
  end
end

--[[Main Functions:
  load_game is called once at program start.

  Update is then looped until the exit condition is met.
]]

function load_game()
  
end

function update()
  
end

os.execute("clear")

getFiles(engine, "Lib")
