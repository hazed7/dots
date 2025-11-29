-- Allow overriding the module location through SKETCHYBAR_LUA_PATH
local module_path = os.getenv("SKETCHYBAR_LUA_PATH")
if module_path == nil or module_path == "" then
  module_path = "/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
end
package.cpath = package.cpath .. ";" .. module_path
