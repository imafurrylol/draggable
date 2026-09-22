If you find a bug with something, please create an [issue](https://github.com/imafurrylol/roblox/issues/new) :)


Draggable example:
<h6>get it here: https://create.roblox.com/store/asset/78228119243178</h6>
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



GameSettings example:
<h6>get it here: https://github.com/imafurrylol/roblox/blob/main/GameSettings.lua</h6>
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



Animation example:
<h6>get it here: [https://create.roblox.com/store/asset/78228119243178](https://create.roblox.com/store/asset/74653002513678)</h6>
```lua
local BaseAnimation = game:GetService("ReplicatedStorage"):WaitForChild("Animation")
local EaseOutCubic = require(BaseAnimation:WaitForChild("EaseOutCubic"))
local ScreenGui = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.fromOffset(100, 100)

-- The duration is in milliseconds
local Animation = EaseOutCubic:New(Frame, 3000, { Position = UDim2.new(1, -100, 1, -100) }):Play()
print(":Play() does not yield")

-- To yield (wait until the Animation has completed), you can call :Wait()
Animation:Wait()
print("Animation completed")

-- You can re-use Animations and also reverse them.
Animation:Reverse():Play() -- Method calls are chainable! Reverse flips the current Direction

-- You can create connections for the Animation, either before you play it or while it's running.
--[[
	Once you've created a connection, it persists for the lifetime of the Animation.
	Make sure to disconnect it if it's no longer in use!
]]
local Connection = Animation:Connect(function(Progress) -- When you are Animating an Instance, the parameter is a normalized progress from 0-1
	print("Progress: " .. Progress)
end):Wait() -- Calling :Wait() on a Connection waits for the Animation to finish, then returns the Connection itself.

Connection:Disconnect()

task.wait(1)

local State = -1
local SecondConnection = Animation:Reverse():Play():Connect(function(Progress) -- Changing the direction of the Animation during the Animation is supported!
	if Progress >= 0.7 and State == -1 then
		State = 0
		Animation:Reverse() -- Flips the direction, causing it to go backwards
		print("Backwards!")
	end

	if Progress <= 0.05 and State == 0 then
		State = 1
		Animation:SetReversed(false) -- Explicitly set it to go forwards. Not needed here, though useful if you are unsure of the current direction.
		print("Forwards!")
	end
end)
SecondConnection:Wait():Disconnect() -- You can also chain calls like this! If you wanted, it could be directly after the connect, e.g. Animation:Connect(x):Wait():Disconnect()

task.wait(1)

-- You can create raw value Animations, you do not have to Animate an instance's properties.
local ValueAnimation = EaseOutCubic:New({
	Value = 0,
	Target = 1000,
	Duration = 2500
})

ValueAnimation:Play():Connect(function(Value) -- When it's a raw value Animation, it is the actual value, not a normalized progress of 0-1
	print("Value: " .. Value)
end):Wait():Disconnect()

task.wait(1)
print("Back to 0!")

-- You can also reverse value Animations
ValueAnimation:Reverse():Play():Connect(function(Value)
	print("Value: " .. Value)
end):Wait():Disconnect()
```
