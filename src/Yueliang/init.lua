--[[
  `/shdmmmmmmmmmd-`ymmmddyo:`       //                sm- /h/                        --             
`yNMMMMMMMMMMMMm-.dMMMMMMMMMN+     `MN  `-:::.`   .-:-hM- -o-  .-::.  .::-.   `.:::` MN--. `-::-.   
yMMMMMMMMMMMMMd.:NMMMMMMMMMMMM+    `MN  yMs+oNh  oNy++mM- +Mo -Mm++:`hmo+yN+ .dmo++- MNoo/ `o+odN:  
yMMMMMMMMMMMMy`+NMMMMMMMMMMMMM+    `MN  yM:  dM. MN   yM- +Mo -Mh   /Mmss    sM+     MN    +h ohMo  
`yNMMMMMMMMMo`sMMMMMMMMMMMMMNo     `MN  yM:  dM. oNy//dM- +Mo -Mh   `dNs++o. -mm+//- dM+/+ mN+/sMo  
  `/shddddd/ odddddddddddho:`       ::  .:`  -:   `:///-` .:. `:-     .://:`  `-///. `-//: `-///:. 

 __   __          _ _
 \ \ / /   _  ___| (_) __ _ _ __   __ _ 
  \ V / | | |/ _ \ | |/ _` | '_ \ / _` |
   | || |_| |  __/ | | (_| | | | | (_| |
   |_| \__,_|\___|_|_|\__,_|_| |_|\__, |
                                  |___/

A fork of Kein-Hong Man <khman@users.sf.net>'s bytecode compiler Yueliang mantained by the Indirecta LUIC team with additional features for
Luau compatibility.

Contributors: khman, einsteinK, Stravant, Sceleratis, fxeP1, joritochip, ccuser44
]]

local waitDeps = {
	'FiOne';
	'LuaK';
	'LuaP';
	'LuaU';
	'LuaX';
	'LuaY';
	'LuaZ';
}

for _, v in ipairs(waitDeps) do 
	script:WaitForChild(v)
end

local luaX = require(script.LuaX)
local luaY = require(script.LuaY)
local luaZ = require(script.LuaZ)
local luaU = require(script.LuaU)
local fiOne = require(script.FiOne)

luaX:init()
local LuaState = {}

getfenv().script = nil

return function(str,env)
	local f, writer, buff
	env = env or getfenv(2)
	local name = (env.script and env.script:GetFullName())
	local ran, error = pcall(function()
		local zio = luaZ:init(luaZ:make_getS(str), nil)
		if not zio then return error() end
		local func = luaY:parser(LuaState, zio, nil, name or "::Adonis::Loadstring::")
		writer, buff = luaU:make_setS()
		luaU:dump(LuaState, func, writer, buff)
		f = fiOne(buff.data, env)
	end)
	
	if ran then
		return f, buff.data
	else
		return nil, error
	end
end
