[Draggable](https://create.roblox.com/store/asset/78228119243178) (UI drag) example:
```lua
local Draggable = require(game.ReplicatedStorage.Draggable)
local drag = Draggable.new(script.Parent)
-- options:
-- Smooth: boolean (whether it smooths or not, default is true
-- Speed: number (higher = faster, lower = slower, default is 0.44)
-- Handle: GuiObject (default is nil, if not specific anywhere on the input GuiObject will start the dragging)
-- example: local drag = Draggable.new(GUI, { Smooth = false, Handle = GUI.handle })

drag.StartDragging = function()
	print("start")
end

drag.StopDragging = function()
	print("stop")
end

drag.OnUpdate = function(position) -- Called until the GuiObject has reached the position it was dragged to
	print("x: " .. position.X.Offset .. ", y: " .. position.Y.Offset)
end

wait(5)
drag.Destroy()
```

GameSettings example:
```lua
local GameSettings = require(game.ReplicatedStorage:WaitForChild("GameSettings"))

local savedQualitySettingListener = GameSettings.OnChange("SavedQualityLevel", function(value: Enum.SavedQualitySetting)
	print("SavedQualitySetting: " .. value.Value)
end)

wait(5)

savedQualitySettingListener.Disconnect()
print("hi, SavedQualitySetting: " .. GameSettings.Get("SavedQualitySetting").Value)
```
