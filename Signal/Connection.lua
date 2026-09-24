-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Connection = {}
local ConnectionMetatable = { __index = Connection }

export type Connection<T... = (any)> = {
	Callback: (T...) -> (),
	Disconnect: (self: Connection<T...>) -> (),
	Connected: boolean
}

local function RunCallback<T...>(self: Connection<T...>, ...: T...): ()
	if not self.Connected then return end

	self.Coroutine = nil
	local Success, Error = xpcall(self.Callback, debug.traceback, ...)

	if not Success then
		warn(Error)
	end
end

local function Worker<T...>(self: Connection<T...>, ...: T...): ()
	RunCallback(self, ...)

	while self.Connected do
		self.Coroutine = coroutine.running()
		RunCallback(self, coroutine.yield())
	end
end

Connection.Worker = Worker

function Connection.new<T...>(Callback: (T...) -> ()): Connection<T...>
	return setmetatable({
		Callback = Callback,
		Connected = true,
		Coroutine = nil,
	}, ConnectionMetatable)
end

function Connection.Disconnect<T...>(self: Connection<T...>): ()
	if not self.Connected then return end

	self.Connected = false

	local Coroutine = self.Coroutine
	self.Coroutine = nil

	if Coroutine ~= nil then
		task.cancel(Coroutine)
	end
end

return Connection
