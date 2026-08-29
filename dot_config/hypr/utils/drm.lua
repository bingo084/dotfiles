local M = {}

local drm_path = "/sys/class/drm"

local function read_line(path)
	local file = io.open(path)
	if not file then
		return nil
	end

	local value = file:read("l")
	file:close()
	return value
end

local function list_entries()
	local process = io.popen("LC_ALL=C /usr/bin/ls -1 " .. drm_path .. " 2>/dev/null")
	if not process then
		return {}
	end

	local entries = {}
	for entry in process:lines() do
		table.insert(entries, entry)
	end
	process:close()
	return entries
end

local function card_index(card)
	return tonumber(card:match("%d+")) or math.huge
end

function M.preferred_devices()
	local cards = {}
	local external_card
	local internal_card

	for _, entry in ipairs(list_entries()) do
		if entry:match("^card%d+$") then
			table.insert(cards, entry)
		else
			local card, connector = entry:match("^(card%d+)%-(.+)$")
			local connected = card and read_line(drm_path .. "/" .. entry .. "/status") == "connected"

			if connected and (connector:match("^eDP%-") or connector:match("^LVDS%-")) then
				internal_card = internal_card or card
			elseif connected and not connector:match("^Writeback%-") then
				external_card = external_card or card
			end
		end
	end

	table.sort(cards, function(a, b)
		return card_index(a) < card_index(b)
	end)

	local primary_card = external_card or internal_card or cards[1]
	if not primary_card then
		return {}
	end

	local devices = { "/dev/dri/" .. primary_card }
	for _, card in ipairs(cards) do
		if card ~= primary_card then
			table.insert(devices, "/dev/dri/" .. card)
		end
	end

	return devices
end

return M
