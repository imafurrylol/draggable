-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local function Extend(baseClass)
	local Class = {}
	Class.__index = Class
	setmetatable(Class, { __index = baseClass })

	function Class.New(First, ...)
		local self = setmetatable({}, Class)

		if First ~= Class then
			self:Constructor(First, ...)
		else
			self:Constructor(...)
		end

		return self
	end

	Class.Extend = Extend
	return Class
end

local function Interpolate(From, To, DeltaTime)
	if typeof(From) ~= typeof(To) then
		error("cant interpolate between different types")
	end

	local Success, Value = pcall(function()
		return From:Lerp(To, DeltaTime)
	end)
	if Success then return Value end

	local FromType = typeof(From)
	if FromType == "number" then
		return From + (To - From) * DeltaTime
	end

	if FromType == "UDim" then
		return UDim.new(From.Scale + (To.Scale - From.Scale) * DeltaTime, From.Offset + (To.Offset - From.Offset) * DeltaTime)
	end

	error("unsupported interpolation type: " .. FromType)
end

local Animation = Extend()

function Animation:Constructor(Options, Duration, Properties)
	if typeof(Options) == "Instance" then
		if typeof(Duration) ~= "number" or typeof(Properties) ~= "table" then
			error("invalid constructor")
		end

		self.Instance = Options
		self.Duration = math.max(1, Duration) / 1000
		self.Direction = 1
		self.Elapsed = 0
		self.Progress = 0
		self.Playing = false
		self.Properties = {}
		self.Connections = {}

		for property, target in pairs(Properties) do
			self.Properties[property] = { Start = self.Instance[property], Target = target }
		end

		return
	end

	if Options == nil or typeof(Options.Duration) ~= "number" then
		error("invalid constructor")
	end

	self.Value = Options.Value ~= nil and typeof(Options.Value) == "number" and Options.Value or 0
	self.StartValue = self.Value
	self.Target = typeof(Options.Target) == "number" and Options.Target or self.Value
	self.Duration = math.max(1, Options.Duration) / 1000
	self.Direction = 1
	self.Elapsed = 0
	self.Playing = false
	self.Connections = {}
end

function Animation:SetTarget(Target)
	if Target == nil or typeof(Target) ~= "number" then
		error("target must be a number")
	end
	self.Target = Target
end

function Animation:SetDuration(Duration)
	if Duration == nil or typeof(Duration) ~= "number" then
		error("duration must be a number")
	end
	self.Duration = math.max(1, Duration) / 1000
end

function Animation:Evaluate(Target, Start, DeltaTime)
	error("evaluate must be overridden")
end

function Animation:Step(DeltaTime)
	if self.Instance ~= nil then
		self.Elapsed = math.clamp(self.Elapsed + DeltaTime * self.Direction, 0, self.Duration)
		self.Progress = self:Evaluate(0, 1, self.Elapsed / self.Duration)

		for property, values in pairs(self.Properties) do
			self.Instance[property] = Interpolate(values.Start, values.Target, self.Progress)
		end

		return self.Progress
	end

	self.Elapsed = math.clamp(self.Elapsed + DeltaTime * self.Direction, 0, self.Duration)
	local Progress = self:Evaluate(0, 1, self.Elapsed / self.Duration)
	self.Value = Interpolate(self.StartValue, self.Target, Progress)
	return self.Value
end

function Animation:IsFinished()
	return self.Direction == 1 and self.Elapsed >= self.Duration or self.Elapsed <= 0
end

function Animation:Reverse()
	self.Direction *= -1
	return self	
end

function Animation:SetReversed(Reversed)
	self.Direction = Reversed and -1 or 1
	return self
end

function Animation:Wait()
	repeat task.wait() until not self.Playing
	return self
end

function Animation:Stop()
	self.Playing = false
	return self
end

function Animation:Connect(Callback)
	if Callback == nil or typeof(Callback) ~= "function" then
		error("Callback must be a function!")
	end

	local Connection = {
		Type = "Connection",
		Connected = true,
		Callback = Callback,
		Animation = self
	}
	
	function Connection:Wait()
		if not self.Connected then return end
		self.Animation:Wait()
		return self
	end
	
	function Connection:Disconnect()
		if not self.Connected then return end
		self.Connected = false

		for index, connection in pairs(self.Animation.Connections) do
			if connection ~= Connection then continue end
			table.remove(self.Animation.Connections, index)
			break
		end
	end

	table.insert(self.Connections, Connection)
	return Connection
end

function Animation:Play()
	if self.Playing then return self end
	if self.Instance == nil then
		self.Elapsed = self.Direction == 1 and 0 or self.Duration
	end

	self.Playing = true

	local Connection
	Connection = game:GetService("RunService").Heartbeat:Connect(function(DeltaTime)
		if not self.Playing then
			Connection:Disconnect()
			return
		end

		self:Step(DeltaTime)
		local Finished = self:IsFinished()

		if Finished then
			if self.Instance ~= nil then
				for property, values in pairs(self.Properties) do
					self.Instance[property] = self.Direction == 1 and values.Target or values.Start
				end
			else
				self.Value = self.Direction == 1 and self.Target or self.StartValue
			end
		end

		local Value = self.Instance ~= nil and self.Progress or self.Value
		for index = #self.Connections, 1, -1 do
			local Connection = self.Connections[index]
			local Success, Err = pcall(Connection.Callback, Value)
			if Success then continue end

			warn("Animation connection errored: " .. Err)
		end

		if Finished then
			self.Playing = false
			Connection:Disconnect()
		end
	end)

	return self
end

Animation.Interpolate = Interpolate
return Animation
