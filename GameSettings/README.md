Mostly useless, but useful whenever you need it.

Example:

```lua
local GameSettings = require(game.ReplicatedStorage:WaitForChild("GameSettings"))

local savedQualitySettingListener = GameSettings.OnChange("SavedQualityLevel", function(value: Enum.SavedQualitySetting)
	print("SavedQualitySetting: " .. value.Value)
end)

task.wait(5)

savedQualitySettingListener.Disconnect()
print("hi, SavedQualitySetting: " .. GameSettings.Get("SavedQualitySetting").Value)
```
