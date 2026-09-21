<h6>if you find a bug with something please create an issue :)</h6>

[Draggable](https://create.roblox.com/store/asset/78228119243178) (UI drag) example:
```lua
local Draggable = require(game.ReplicatedStorage.Draggable)
local drag = Draggable.New(script.Parent)
-- options:
-- Smooth: boolean (whether it smooths or not, default is true
-- Speed: number (higher = faster, lower = slower, default is 0.44)
-- Handle: GuiObject (default is nil, if not specific anywhere on the input GuiObject will start the dragging)
-- example: local drag = Draggable.new(GUI, { Smooth = false, Handle = GUI.handle })

drag.OnStartDragging = function()
	print("start")
end

drag.OnStopDragging = function()
	print("stop")
end

drag.OnUpdate = function(position) -- Called until the GuiObject has reached the position it was dragged to
	print("x: " .. position.X.Offset .. ", y: " .. position.Y.Offset)
end

wait(5)
drag.Destroy()
```
<h6>-----</h6>
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
<h6>-----</h6>
[Animation](https://create.roblox.com/store/asset/74653002513678) example:
```lua
local BaseAnimation = game.ReplicatedStorage:WaitForChild("Animation")
local EaseOutCubic = require(BaseAnimation:WaitForChild("EaseOutCubic"))

local Animation = EaseOutCubic:New(script.Parent, 1000, { Position = UDim2.new(1, 0, 0, 0) })
local HasReversed = false

Animation:Play(function(progress)
	if progress > 0.75 and not HasReversed then
		HasReversed = true
		Animation:SetReversed(true)
		print("Back we go :D")
	end

	if progress < 0.05 then
		Animation:SetReversed(false)
		print("Nevermind")
	end
end):Wait()

local Animation2 = EaseOutCubic:New({
	Value = 0,
	Target = 10,
	Duration = 2500
}):Play(function(value)
	print(value)
end)
print("Hello from before finishing!")
Animation2:Wait()
print("Hello from after finishing!")
Animation:Reverse():Play()
```
