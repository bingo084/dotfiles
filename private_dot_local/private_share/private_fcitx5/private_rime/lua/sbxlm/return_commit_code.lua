local XK_Return = 0xff0d
local rime = require("lib")

local this = {}

-- Return 实现 commit_code 的效果
---@param key_event KeyEvent
---@param env Env
function this.func(key_event, env)
	if key_event.keycode ~= XK_Return or key_event:release() then
		return rime.process_results.kNoop
	end

	local context = env.engine.context
	if context:get_option("ascii_mode") then
		return rime.process_results.kNoop
	end

	local segment = context.composition:back()
	if not segment or not segment:has_tag("abc") then
		return rime.process_results.kNoop
	end

	local input = context.input
	if input:len() == 0 then
		return rime.process_results.kNoop
	end

	env.engine:commit_text(input)
	context:clear()
	context:set_option("ascii_mode", true)
	return rime.process_results.kAccepted
end

return this
