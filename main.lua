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

local function parse_version(version_str) 
	local major, minor, patch = version_str:gmatch("(%d+)%.(%d+)%.(%d+)")()

	major = tonumber(major)
	minor = tonumber(minor)
	patch = tonumber(patch)
	summed = patch * 100 + minor * 100 * 1000 + major * 100 * 1000 * 1000
	return summed
end

-- TODO: raw version check
local LOCAL_VERSION = parse_version("0.1.0")
local body,code = https.request("https://raw.githubusercontent.com/LucasWilsonGit/cppref/refs/heads/main/version.txt")
if code == 200 then
	body = body:gsub("\n","")
	local version = parse_version(body)
	if version > LOCAL_VERSION then
		print("cppref: An update is available (v" .. body .. ")")
	end
end
