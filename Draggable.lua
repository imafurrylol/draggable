-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Draggable = {}
local drags = {}
local activeDrag = nil

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local function IsWithin(position, instance)
	local absolutePosition = instance.AbsolutePosition
	local absoluteSize = instance.AbsoluteSize

	return position.X >= absolutePosition.X and position.X <= absolutePosition.X + absoluteSize.X and position.Y >= absolutePosition.Y and position.Y <= absolutePosition.Y + absoluteSize.Y
end

local function Smooth(from, to, options, dt)
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
		if not IsWithin(input.Position, drag.GetHandle()) then continue end

		drag.Positions["x"] = input.Position.X
		drag.Positions["y"] = input.Position.Y
		drag.Positions["sx"] = drag.Positions["x"] - drag.Positions["cx"]
		drag.Positions["sy"] = drag.Positions["y"] - drag.Positions["cy"]
		drag.Dragging = true
		drag.Input = input
		drag.OnStartDragging(drag.Frame.Position)
		activeDrag = drag
		break
	end
end)

userInputService.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if activeDrag == nil then return end
	if input ~= activeDrag.Input then return end

	activeDrag.Dragging = false
	activeDrag.Input = nil
	activeDrag.OnStopDragging(activeDrag.Frame.Position)
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

function Draggable.New(frame, options)
	local self = {
		OnStartDragging = function(position) end,
		OnStopDragging = function(position) end,
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
		Positions = {},
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

	self.Positions["cx"] = self.Frame.Position.X.Offset
	self.Positions["cy"] = self.Frame.Position.Y.Offset
	self.Positions["fx"] = self.Frame.Position.X.Offset
	self.Positions["fy"] = self.Frame.Position.Y.Offset

	self.Update = function(deltaTime)
		if self.Dragging then
			self.Positions["cx"] = self.Positions["x"] - self.Positions["sx"]
			self.Positions["cy"] = self.Positions["y"] - self.Positions["sy"]
		end

		local oldFx = self.Positions["fx"]
		local oldFy = self.Positions["fy"]
		self.Positions["fx"] = Smooth(self.Positions["fx"], self.Positions["cx"], self.Options, deltaTime)
		self.Positions["fy"] = Smooth(self.Positions["fy"], self.Positions["cy"], self.Options, deltaTime)
		self.Frame.Position = UDim2.new(self.Frame.Position.X.Scale, self.Positions["fx"], self.Frame.Position.Y.Scale, self.Positions["fy"])

		if self.Options.Smooth then
			if math.abs(self.Positions["fx"] - self.Positions["cx"]) > 1 or math.abs(self.Positions["fy"] - self.Positions["cy"]) > 1 then
				self.OnUpdate(self.Frame.Position)
			end
			return
		end

		if oldFx ~= self.Positions["fx"] or oldFy ~= self.Positions["fy"] then
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
