https://create.roblox.com/store/asset/74653002513678

Example:
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
local ThirdConnection = ValueAnimation:Reverse():Play():Connect(function(Value)
	print("Value: " .. Value)
end)

--[[
	Just like connections, whenever you created a "Completed" connection, it persists for the lifetime of the Animation.
	Ensure you clean up any Completed connections!
]]
ValueAnimation:Completed(function(Value)
	print("Finished on: " .. Value)
end):Wait():Disconnect()

-- Clean up the connection
ThirdConnection:Disconnect()

ValueAnimation:Reverse():Play():Completed(function(Value)
	print("The others were disconnected! Finished on: " .. Value)
end):Wait():Disconnect()
```
