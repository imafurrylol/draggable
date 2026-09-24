-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Maid = {}
local MaidMetatable = { __index = Maid }

local Vector = require(script:GetAttribute("VectorModule"):Get())
local Task = require(script.Task)

export type Maid = {
	Alive: boolean,
	AddTask: (self: Maid, Task: Task) -> Task,
	RemoveTask: (self: Maid, Task: Task) -> (),
	Cleanup: (self: Maid) -> (),
	Destroy: (self: Maid) -> ()
}

function Maid.AddTask(self: Maid, _Task: Task): Task
	if self == Maid then
		error("AddTask: called on ModuleScript!")
	end

	if not self.Alive then
		error("AddTask: called on dead Maid!")
	end
	
	if self.Tasks:contains(_Task) then
		error("AddTask: Task provided already registered!")
	end

	return self.Tasks:push_back(_Task)
end

function Maid.RemoveTask(self: Maid, _Task: Task)
	if self == Maid then
		error("RemoveTask: called on ModuleScript!")
	end

	if not self.Alive then
		error("RemoveTask: called on dead Maid!")
	end

	self.Tasks:erase_if(function(_Task2: Task)
		if _Task2 == _Task then
			Task.Cleanup(_Task2)
			return true
		end

		return false
	end)
end

function Maid.Cleanup(self: Maid)
	if self == Maid then
		error("Cleanup: called on ModuleScript!")
	end

	if not self.Alive then
		error("Cleanup: called on dead Maid!")
	end

	for _, _Task in self.Tasks:iter() do
		Task.Cleanup(_Task)
	end

	self.Tasks:clear()
end

function Maid.Destroy(self: Maid)
	if self == Maid then
		error("Destroy: called on ModuleScript!")
	end

	if not self.Alive then
		error("Destroy: called on dead Maid!")
	end

	self:Cleanup()
	self.Alive = false
end

function Maid.new(): Maid
	return setmetatable({
		Tasks = Vector.new<<Task>>(),
		Alive = true
	}, MaidMetatable)
end

return Maid
