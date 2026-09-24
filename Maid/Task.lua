-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Task = {}

type Destroyable = {
	Destroy: (self: any) -> (),
}

type Disconnectable = {
	Disconnect: (self: any) -> (),
}

export type Task = (() -> ()) | Destroyable | Disconnectable

local function CleanupTask(self: Task)
	local Success, Err = xpcall(function()
		if type(self) == "function" then
			self()
			return
		end

		if self.Disconnect then
			self:Disconnect()
			return
		end

		if self.Destroy then
			self:Destroy()
			return
		end
	end, debug.traceback)

	if Success then return end

	warn("CleanupTask failed! Error: " .. tostring(Err))
end

Task.Cleanup = CleanupTask
return Task
