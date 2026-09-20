--[[
usage example:

local Draggable = require(game.ReplicatedStorage.Draggable)
local drag = Draggable.new(GUI)
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

drag.OnUpdate = function(position)
	print("x: " .. position.X.Offset .. ", y: " .. position.Y.Offset)
end

wait(5)
drag:Destroy()
]]

local Draggable = {}
local drags = {}
local activeDrag = nil

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local function within(position, instance)
	local absolutePosition = instance.AbsolutePosition
	local absoluteSize = instance.AbsoluteSize

	return position.X >= absolutePosition.X and position.X <= absolutePosition.X + absoluteSize.X and position.Y >= absolutePosition.Y and position.Y <= absolutePosition.Y + absoluteSize.Y
end

local function smooth(from, to, options, dt)
	if not options.Smooth then
		return to
	end

	local t = math.clamp(options.Speed, 0, 1)
	t = 1 / (1 + math.exp(-12 * (t - 0.5)))
	t = 1 - (1 - t) ^ (dt * 60)

	return from + (to - from) * t
end

userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if activeDrag ~= nil then return end
	if gameProcessedEvent then return end
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end

	for index, drag in pairs(drags) do
		if not within(input.Position, drag.GetHandle()) then continue end

		drag.Positions["x"] = input.Position.X
		drag.Positions["y"] = input.Position.Y
		drag.Positions["sx"] = drag.Positions["x"] - drag.Positions["cx"]
		drag.Positions["sy"] = drag.Positions["y"] - drag.Positions["cy"]
		drag.Dragging = true
		drag.Input = input
		drag.StartDragging(drag.Frame.Position)
		activeDrag = drag
		break
	end
end)

userInputService.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if activeDrag == nil then return end
	if input ~= activeDrag.Input then return end

	activeDrag.Dragging = false
	activeDrag.Input = nil
	activeDrag.StopDragging(activeDrag.Frame.Position)
	activeDrag = nil
end)

userInputService.InputChanged:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if activeDrag == nil then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input ~= activeDrag.Input then return end

	activeDrag.Positions["x"] = input.Position.X
	activeDrag.Positions["y"] = input.Position.Y	
end)

runService.Heartbeat:Connect(function(deltaTime)
	for index, drag in pairs(drags) do
		drag.Update(deltaTime)
	end
end)

function Draggable.new(frame, options)
	local self = {
		StartDragging = function(position) end,
		StopDragging = function(position) end,
		OnUpdate = function(position) end,

		Update = function(dt) end,
		Destroy = function() end,
		GetHandle = function() end,
		Dragging = false,
		Input = nil,
		Frame = frame,

		Options = {
			Smooth = true,
			Speed = 0.44,
			Handle = nil
		},

		Positions = setmetatable({}, {
			__index = function(self, i)
				self[i] = 0
				return 0
			end,
		}),
	}

	if options then
		for key, value in pairs(options) do
			self.Options[key] = value
		end
	end

	self.GetHandle = function()
		if self.Options.Handle ~= nil then
			if self.Options.Handle:IsA("GuiObject") then
				return self.Options.Handle
			end
		end

		return self.Frame
	end

	self.Positions["fx"] = self.Frame.Position.X.Offset
	self.Positions["fy"] = self.Frame.Position.Y.Offset

	self.Update = function(deltaTime)
		if self.Dragging then
			self.Positions["cx"] = self.Positions["x"] - self.Positions["sx"]
			self.Positions["cy"] = self.Positions["y"] - self.Positions["sy"]
		end

		self.Positions["fx"] = smooth(self.Positions["fx"], self.Positions["cx"], self.Options, deltaTime)
		self.Positions["fy"] = smooth(self.Positions["fy"], self.Positions["cy"], self.Options, deltaTime)
		self.Frame.Position = UDim2.new(self.Frame.Position.X.Scale, self.Positions["fx"], self.Frame.Position.Y.Scale, self.Positions["fy"])

		if math.abs(self.Positions["fx"] - self.Positions["cx"]) > 1 or math.abs(self.Positions["fy"] - self.Positions["cy"]) > 1 then
			self.OnUpdate(self.Frame.Position)
		end
	end

	self.Destroy = function()
		if activeDrag == self then
			activeDrag = nil
		end

		for i, drag in ipairs(drags) do
			if drag == self then
				table.remove(drags, i)
				break
			end
		end
	end

	table.insert(drags, self)
	return self
end

return Draggable
