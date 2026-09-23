-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local GameSettings = {}
local Settings = UserSettings().GameSettings
local Listeners = {}

Settings.Changed:Connect(function(SettingName)
    local Success, Value = pcall(function()
        return Settings[SettingName]
    end)

    if not Success then return end
    local SettingListeners = Listeners[SettingName]
    if SettingListeners == nil then return end	
	
    for index = #SettingListeners, 1, -1 do
        local Listener = SettingListeners[index]
        local Success, Err = pcall(Listener.Callback, Value)
        if Success then continue end
		
        warn("Listener for " .. SettingName .. " errored: " .. Err)
    end
end)

function GameSettings.Get(SettingName)
    if SettingName == nil then
        return Settings
    end

    local Success, Value = pcall(function()
        return Settings[SettingName]
    end)

    if not Success then return nil end
    return Value
end	

function GameSettings.OnChange(SettingName, Callback)
    if SettingName == nil or typeof(SettingName) ~= "string" then
        error("SettingName must be a string")
    end

    if Callback == nil or typeof(Callback) ~= "function" then
        error("Callback must be a function")
    end

    local self = {
        Name = SettingName,
        Callback = Callback,
        Connected = true,
        Disconnect = function()
            if not self.Connected then return end

            for i, listener in ipairs(Listeners[SettingName]) do
                if listener == self then
                    table.remove(Listeners[SettingName], i)
                    break
                end
            end

            if #Listeners[SettingName] == 0 then
                Listeners[SettingName] = nil
            end

            self.Connected = false
        end
    }

    Listeners[SettingName] = Listeners[SettingName] or {}
    table.insert(Listeners[SettingName], self)
    return self
end

return GameSettings
