-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local GameSettings = {}
local listeners = {}

local gameSettings = UserSettings().GameSettings

gameSettings.Changed:Connect(function(setting)
	local success, value = pcall(function()
		return gameSettings[setting]
	end)

	if not success then return end
	local settingListeners = listeners[setting]
	if settingListeners == nil then return end	

	for _, listener in ipairs(settingListeners) do
		local _success, _error = pcall(listener.Callback, value)
		if _success then return end

		warn("listener for " .. setting ..  " errored: " .. _error)
	end
end)

function GameSettings.Get(name)
	if name == nil then return gameSettings end

	local success, value = pcall(function()
		return gameSettings[name]
	end)

	if not success then return nil end
	return value
end	

function GameSettings.OnChange(settingName, callback)
	local self = {
		Name = settingName,
		Callback = callback,
		Connected = true,
		Disconnect = function()
			if not self.Connected then return end

			for i, listener in ipairs(listeners[settingName]) do
				if listener == self then
					table.remove(listeners[settingName], i)
					break
				end
			end

			if #listeners[settingName] == 0 then
				listeners[settingName] = nil
			end

			self.Connected = false
		end
	}

	listeners[settingName] = listeners[settingName] or {}
	table.insert(listeners[settingName], self)
	return self
end

return GameSettings
