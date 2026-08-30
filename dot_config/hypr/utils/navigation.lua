local M = {}

local function vertical_neighbor(window, step)
	if window == nil or window.workspace == nil or window.floating then
		return nil
	end

	local neighbor
	local nearest = math.huge
	for _, candidate in ipairs(window.workspace:get_windows()) do
		local distance = (candidate.at.y - window.at.y) * step
		if
			candidate.address ~= window.address
			and candidate.mapped
			and not candidate.hidden
			and not candidate.floating
			and candidate.at.x == window.at.x
			and distance > 0
			and distance < nearest
		then
			neighbor = candidate
			nearest = distance
		end
	end

	return neighbor
end

local function workspace_in_direction(step)
	local current = hl.get_active_workspace()
	if current == nil or current.special then
		return nil
	end

	local neighbor
	local nearest = math.huge
	for _, workspace in ipairs(hl.get_workspaces()) do
		local distance = (workspace.id - current.id) * step
		if not workspace.special and distance > 0 and distance < nearest then
			neighbor = workspace
			nearest = distance
		end
	end

	return neighbor
end

local function workspace_selector(workspace)
	if workspace.id < 0 then
		return "name:" .. workspace.name
	end

	return tostring(workspace.id)
end

local function workspace_has_windows(workspace)
	return workspace ~= nil and not workspace.special and #workspace:get_windows() > 0
end

local function focus_workspace(step)
	local workspace = workspace_in_direction(step)
	if workspace ~= nil then
		hl.dispatch(hl.dsp.focus({ workspace = workspace_selector(workspace) }))
	elseif step > 0 and workspace_has_windows(hl.get_active_workspace()) then
		hl.dispatch(hl.dsp.focus({ workspace = "emptyn" }))
	end
end

local function tiled_columns(workspace)
	local by_x = {}
	for _, window in ipairs(workspace:get_windows()) do
		if window.mapped and not window.hidden and not window.floating then
			local x = window.at.x
			local column = by_x[x]
			if column == nil then
				column = { x = x, right = x, windows = {} }
				by_x[x] = column
			end
			column.right = math.max(column.right, x + window.size.x)
			column.windows[window.address] = true
		end
	end

	local columns = {}
	for _, column in pairs(by_x) do
		table.insert(columns, column)
	end
	table.sort(columns, function(a, b)
		return a.x < b.x
	end)

	return columns
end

local function column_index(workspace, target)
	for index, column in ipairs(tiled_columns(workspace)) do
		if column.windows[target.address] then
			return index
		end
	end

	return nil
end

local function projected_center(window, workspace)
	local center = window.at.x + window.size.x / 2
	local source_monitor = window.monitor
	local target_monitor = workspace.monitor
	if source_monitor == nil or target_monitor == nil then
		return center
	end

	local source_width = source_monitor.width / source_monitor.scale
	local target_width = target_monitor.width / target_monitor.scale
	if source_width <= 0 or target_width <= 0 then
		return center
	end

	local relative = (center - source_monitor.x) / source_width
	return target_monitor.x + relative * target_width
end

local function insertion_index(workspace, x)
	local columns = tiled_columns(workspace)
	if #columns == 0 then
		return 1
	end

	local nearest_index = 1
	local nearest_distance = math.huge
	for index, column in ipairs(columns) do
		local center = (column.x + column.right) / 2
		local distance = math.abs(center - x)
		if distance < nearest_distance then
			nearest_index = index
			nearest_distance = distance
		end
	end

	local nearest = columns[nearest_index]
	local nearest_center = (nearest.x + nearest.right) / 2
	return x < nearest_center and nearest_index or nearest_index + 1
end

local function place_column_at(window, workspace, target_index)
	local window_index = column_index(workspace, window)
	if window_index == nil then
		return
	end

	if window_index > target_index then
		for _ = target_index, window_index - 1 do
			hl.dispatch(hl.dsp.layout("swapcol l"))
		end
	else
		for _ = window_index, target_index - 1 do
			hl.dispatch(hl.dsp.layout("swapcol r"))
		end
	end
end

local function compensate_tape(window, target_center)
	local current_center = window.at.x + window.size.x / 2
	local delta = target_center - current_center
	if math.abs(delta) < 1 then
		return
	end

	hl.dispatch(hl.dsp.layout(string.format("move %.3f", delta)))
	hl.dispatch(hl.dsp.layout("inhibit_scroll 1"))
	hl.dispatch(hl.dsp.focus({ window = window }))
	hl.dispatch(hl.dsp.layout("inhibit_scroll 0"))
end

local function restore_size(window, size)
	hl.dispatch(hl.dsp.window.resize({ x = size.x, y = size.y, window = window }))
end

local function focus_window_or_workspace(step)
	local window = hl.get_active_window()
	if window ~= nil and window.floating then
		hl.dispatch(hl.dsp.focus({ direction = step > 0 and "d" or "u" }))
		return
	end

	local window_neighbor = vertical_neighbor(window, step)
	if window_neighbor ~= nil then
		hl.dispatch(hl.dsp.focus({ window = window_neighbor }))
	else
		local workspace_neighbor = workspace_in_direction(step)
		if workspace_neighbor ~= nil then
			hl.dispatch(hl.dsp.focus({ workspace = workspace_selector(workspace_neighbor) }))
		elseif step > 0 and workspace_has_windows(hl.get_active_workspace()) then
			hl.dispatch(hl.dsp.focus({ workspace = "emptyn" }))
		end
	end
end

local function move_window_or_workspace(step)
	local window = hl.get_active_window()
	if window == nil then
		return
	end
	if window.floating then
		hl.dispatch(hl.dsp.window.move({ direction = step > 0 and "d" or "u", group_aware = true }))
		return
	end

	local window_neighbor = vertical_neighbor(window, step)
	if window_neighbor ~= nil then
		hl.dispatch(hl.dsp.window.swap({ target = window_neighbor }))
	else
		local workspace_neighbor = workspace_in_direction(step)
		if workspace_neighbor ~= nil then
			local size = window.size
			local target_center = projected_center(window, workspace_neighbor)
			local target_index = insertion_index(workspace_neighbor, target_center)
			hl.dispatch(hl.dsp.window.move({ workspace = workspace_selector(workspace_neighbor) }))
			place_column_at(window, workspace_neighbor, target_index)
			restore_size(window, size)
			compensate_tape(window, target_center)
		elseif step > 0 and window.workspace ~= nil and not window.workspace.special then
			local size = window.size
			hl.dispatch(hl.dsp.window.move({ workspace = "emptyn" }))
			restore_size(window, size)
		end
	end
end

function M.focus_window_or_workspace_down()
	focus_window_or_workspace(1)
end

function M.focus_window_or_workspace_up()
	focus_window_or_workspace(-1)
end

function M.focus_previous_workspace()
	focus_workspace(-1)
end

function M.focus_next_workspace()
	focus_workspace(1)
end

function M.move_window_down_or_to_workspace_down()
	move_window_or_workspace(1)
end

function M.move_window_up_or_to_workspace_up()
	move_window_or_workspace(-1)
end

return M
