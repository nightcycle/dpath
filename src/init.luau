--!strict
local _Package = script
local _Packages = _Package.Parent
-- Services
-- Packages
-- Modules
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local DictionaryPathUtil = {}
DictionaryPathUtil.SEPARATOR = "/"

function DictionaryPathUtil.get(dict: {[string]: any}, path: string): any
	local keys = path:split(DictionaryPathUtil.SEPARATOR)
	local function get(source: any, index: number): any
		local key = keys[index]
		if index == #keys then
			return source[key]
		else
			return get(source[key], index+1)
		end
	end
	return get(dict, 1)
end

function DictionaryPathUtil.search(dict: {[string]: any}, searchLists: boolean, includeTables: boolean, subPath: string?): {[string]: any}
	local out: {[string]: any} = {}
	local function search(source: {[string]: any}, path: string): ()
		if path ~= "" then
			path ..= DictionaryPathUtil.SEPARATOR
		end
		for k, v in pairs(source) do
			if type(k) ~= "number" or (type(k) == "number" and searchLists) then
				local nextPath = path..tostring(k)
				if type(v) == "table" then
					if includeTables then
						out[nextPath] = v
					end
					search(v, nextPath)
				else
					out[nextPath] = v
				end
			end
		end
	end
	if subPath then
		local source = DictionaryPathUtil.get(dict, subPath)
		if not source then
			return {}
		end
		assert(type(source) == "table")
		search(source, "")
		return out
	else
		search(dict, "")
		return out
	end
end

function DictionaryPathUtil.set(dict: {[string]: any}, path: string, value: any?): ()
	local keys = path:split(DictionaryPathUtil.SEPARATOR)
	local function set(source: any, index: number): ()
		local key = keys[index]
		if index == #keys then
			source[key] = value
		else
			set(source[key], index+1)
		end
	end
	return set(dict, 1)
end

return DictionaryPathUtil