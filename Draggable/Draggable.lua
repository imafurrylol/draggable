-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Draggable = {}
local Draggables = {}
local ActiveDraggable = nil
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function IsWithin(Position, Inst)
    local AbsolutePosition = Inst.AbsolutePosition
    local AbsoluteSize = Inst.AbsoluteSize
    return Position.X >= AbsolutePosition.X and Position.X <= AbsolutePosition.X + AbsoluteSize.X and Position.Y >= AbsolutePosition.Y and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y
end

local function Smooth(From, To, Options, DeltaTime)
    if not Options.Smooth then
        return To
    end

    local t = math.clamp(Options.Speed, 0, 1)
    t = 1 / (1 + math.exp(-12 * (t - 0.5)))
    t = 1 - (1 - t) ^ (DeltaTime * 60)

    return From + (To - From) * t
end

UserInputService.InputBegan:Connect(function(Input: InputObject, GameProcessedEvent: boolean)
    if ActiveDraggable ~= nil then return end
    if GameProcessedEvent then return end
    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end

    for _, draggable in pairs(Draggables) do
        if not IsWithin(Input.Position, draggable.GetHandle()) then continue end

        draggable.Positions["x"] = Input.Position.X
        draggable.Positions["y"] = Input.Position.Y
        draggable.Positions["sx"] = draggable.Positions["x"] - draggable.Positions["cx"]
        draggable.Positions["sy"] = draggable.Positions["y"] - draggable.Positions["cy"]
        draggable.Dragging = true
        draggable.Input = Input
        draggable.OnStartDragging(draggable.Frame.Position)
        ActiveDraggable = draggable
        break
    end
end)

UserInputService.InputEnded:Connect(function(Input: InputObject)
    if ActiveDraggable == nil then return end
    if Input ~= ActiveDraggable.Input then return end

    ActiveDraggable.Dragging = false
    ActiveDraggable.Input = nil
    ActiveDraggable.OnStopDragging(ActiveDraggable.Frame.Position)
    ActiveDraggable = nil
end)

UserInputService.InputChanged:Connect(function(Input: InputObject)
    if ActiveDraggable == nil then return end
    if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input ~= ActiveDraggable.Input then return end

    ActiveDraggable.Positions["x"] = Input.Position.X
    ActiveDraggable.Positions["y"] = Input.Position.Y	
end)

RunService.Heartbeat:Connect(function(DeltaTime)
    for _, draggable in pairs(Draggables) do
        draggable.Update(DeltaTime)
    end
end)

function Draggable.New(Frame, Options)
    local self = {
        OnStartDragging = function(position) end,
        OnStopDragging = function(position) end,
        OnUpdate = function(position) end,
        Update = function(DeltaTime) end,
        Destroy = function() end,
        GetHandle = function() end,
        Dragging = false,
        Input = nil,
        Frame = Frame,
        Options = {
            Smooth = true,
            Speed = 0.44,
            Handle = nil
        },
        Positions = {},
    }

    if Options then
        for key, value in pairs(Options) do
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

    self.Update = function(DeltaTime)
        if self.Dragging then
            self.Positions["cx"] = self.Positions["x"] - self.Positions["sx"]
            self.Positions["cy"] = self.Positions["y"] - self.Positions["sy"]
        end

        local OldX = self.Positions["fx"]
        local OldY = self.Positions["fy"]
        self.Positions["fx"] = Smooth(self.Positions["fx"], self.Positions["cx"], self.Options, DeltaTime)
        self.Positions["fy"] = Smooth(self.Positions["fy"], self.Positions["cy"], self.Options, DeltaTime)
        self.Frame.Position = UDim2.new(self.Frame.Position.X.Scale, self.Positions["fx"], self.Frame.Position.Y.Scale, self.Positions["fy"])

        if self.Options.Smooth then
            if math.abs(self.Positions["fx"] - self.Positions["cx"]) > 1 or math.abs(self.Positions["fy"] - self.Positions["cy"]) > 1 then
                self.OnUpdate(self.Frame.Position)
            end
            return
        end

        if OldX ~= self.Positions["fx"] or OldY ~= self.Positions["fy"] then
            self.OnUpdate(self.Frame.Position)
        end
    end

    self.Destroy = function()
        if ActiveDraggable == self then
            ActiveDraggable = nil
        end

        for i, drag in ipairs(Draggables) do
            if drag == self then
                table.remove(Draggables, i)
                break
            end
        end
    end

    table.insert(Draggables, self)
    return self
end

return Draggable
