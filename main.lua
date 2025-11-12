local home = os.getenv("HOME")
package.path = package.path .. ";"..home.."/cppref/?"

local https=require("ssl.https")

local db = dofile(home .. "/cppref/flat.kps")


if arg[1] == nil then
	print("Invalid number of arguments provided. Please specify an item to search for")
	print("Usage: " .. arg[0] .. " <item>")
	os.exit(-1)
end

local param=arg[1]
local l,r = param:match("([%a_]+):+([%a_]+)")
if l and r then
	local url = db[l]:reverse():sub(6):reverse() .. "/" .. r .. ".html"
	local body,code = https.request(url)
	if code == 200 then
		page = url
	end
else
	page = db[param]
end

if not page then
	print("Could not find a page for '" .. arg[1] .. "'. Maybe run scan.lua")
	os.exit(1)
end

os.execute("xdg-open " .. page)

-- TODO: raw version check
-- local body,code = https.request("
