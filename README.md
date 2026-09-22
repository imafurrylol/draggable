If you find a bug with something, please create an [issue](https://github.com/imafurrylol/roblox/issues/new) :)
<br>
<br>

[Draggable](https://create.roblox.com/store/asset/78228119243178) example:
```lua
local Draggable = require(game.ReplicatedStorage.Draggable)
local drag = Draggable.New(script.Parent)
-- options:
-- Smooth: boolean (whether it smooths or not, default is true
-- Speed: number (higher = faster, lower = slower, default is 0.44)
-- Handle: GuiObject (default is nil, if not set, anywhere on the input GuiObject will start the drag)
-- example: local drag = Draggable.New(GUI, { Smooth = false, Handle = GUI.handle })

drag.OnStartDragging = function()
	print("start")
end

drag.OnStopDragging = function()
	print("stop")
end

drag.OnUpdate = function(position) -- Called until the GuiObject has reached the position it was dragged to
	print("x: " .. position.X.Offset .. ", y: " .. position.Y.Offset)
end

task.wait(5)
drag.Destroy()
```
<br>
<br>

[GameSettings](https://github.com/imafurrylol/roblox/blob/main/GameSettings.lua) example:
```lua
-- yes, this is mostly useless, I am just lazy and prefer to write fewer lines of code
local GameSettings = require(game.ReplicatedStorage:WaitForChild("GameSettings"))

local savedQualitySettingListener = GameSettings.OnChange("SavedQualityLevel", function(value: Enum.SavedQualitySetting)
	print("SavedQualitySetting: " .. value.Value)
end)

task.wait(5)

savedQualitySettingListener.Disconnect()
print("hi, SavedQualitySetting: " .. GameSettings.Get("SavedQualitySetting").Value)
```
<br>
<br>

[Animation](https://create.roblox.com/store/asset/74653002513678) example:
```lua
local BaseAnimation = game.ReplicatedStorage:WaitForChild("Animation")
local EaseOutCubic = require(BaseAnimation:WaitForChild("EaseOutCubic"))

local Animation = EaseOutCubic:New(script.Parent, 3000, { Position = UDim2.new(1, -100, 1, -100) }):Play()
task.wait(0.05)
print(":Play() does not yield, you can use :Wait() for that behaviour")
Animation:Wait()

print("You can also reverse the animation and re-use it")
Animation:Reverse():Play()
task.wait(0.05)

print("You can create connections via :Connect(function), and they can be connected while the animation is playing")
local Connection = Animation:Connect(function(Progress)
	print("Progress: " .. Progress)
end)
Animation:Wait()

print("When the Animation finishes, the direction does not get reset. If it was reversed, playing it again will cause it to instantly complete!")
print("If you need the Animation to go forwards, explicitly change the direction.")
Animation:Reverse() -- You could also use Animation:SetReversed(false) to make sure! But in this scenario, this will always set it to go forwards.

print("But be careful, they stick around even after the Animation finishes, so be sure to call :Disconnect() when they are no longer needed.")
Connection:Disconnect()
task.wait(1)

print("You can also reverse the animation while it's playing")
local State = -1
Connection = Animation:Play():Connect(function(Progress)
	if Progress > 0.6 and State == -1 then
		State = 0
		Animation:SetReversed(true)
		print("Reversed!")
	end
	
	if Progress < 0.05 and State == 0 then
		State = 1
		Animation:SetReversed(false)
		print("And back forward!")
	end
end)
Animation:Wait()
Connection:Disconnect()
task.wait(1)

print("You can also do raw value animations,")
Animation = EaseOutCubic:New({
	Value = 0,
	Target = 1000,
	Duration = 2500
}):Play()

Connection = Animation:Connect(function(Value)
	print("Value: " .. Value)
end)
Animation:Wait()
print("The same functions are available for value Animations")
Connection:Disconnect()
```
