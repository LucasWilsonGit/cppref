
local http_socket = require("socket.http")
local https_socket = require("ssl.https")
local url_parser = require("socket.url")
local lfs = require("lfs")

local base = "https://en.cppreference.com/w/"
-- https://en.cppreference.com/w/cpp/container.html

local body, code = https_socket.request(base .. "cpp.html")
-- <a href="cpp/language.html" title="cpp/language">Language</a>

-- <td style="padding: 0; background: #ff9966;"><a href="container/flat_map/swap.html" title="cpp/container/flat map/swap">

local function dir_exists(path)
	local attr = lfs.attributes(path)
	return attr and attr.mode == "directory"
end

local datadir = os.getenv("HOME").."/cppref"
if not dir_exists(datadir) then
	os.execute("mkdir -p " .. datadir)
end
local file = io.open(datadir .. "/flat.kps", "w")

local function link_extractor(html, linkpattern)
	return coroutine.wrap(function()
		for link, title, name in html:gmatch('<a href="(.-)".-title="(.-)".->(.-)<') do
			if link:match(linkpattern) then
				coroutine.yield({ name = name, link = link, title=title})
			end
		end
	end)
end

local seen_items = {}
function handle_library_entry(title, link)
	title_word = title:gsub("%s","_"):match("[%a_%s]-$")
    if not seen_items[title_word] or seen_items[title_word]:match("/header") then
		seen_items[title_word] = link
	end
end

local seen = {}
for item in link_extractor(body, "cpp/[%a_]-%.html") do
	if item.name:match("(library)") then
		if not seen[item.title] then
			seen[item.title] = true
			if item.name:match("Metaprogramming") then
				item.title = item.title:gsub("meta", "types")
			end

			local subbody, code = https_socket.request(base .. item.link)
			for subitem in link_extractor(subbody, item.title:sub(5) .. "/[%a_]-%.html") do
				handle_library_entry(subitem.title, base .."cpp/"..subitem.link)
			end
		end
	end
end

local function serialize(tbl)
	local result = "return {"
	for k,v in pairs(tbl) do 
		
		local k = type(k) == string and k or tostring(k)
		local v = type(v) == string and v or tostring(v)
		local msg = string.format("[\"%s\"] = \"%s\",\n", k, v)
		result = result .. msg 
	end
	result = result .. "}"
	return result
end

file:write(serialize(seen_items))
file:close()
