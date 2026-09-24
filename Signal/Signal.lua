-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Signal = {}
local SignalMetatable = { __index = Signal }

local Vector = require(script:GetAttribute("VectorModule"):Get())
local Connection = require(script.Connection)

export type Signal<T... = (any)> = {
	Connect: (self: Signal<T...>, Callback: (T...) -> ()) -> Connection<T...>,
	Once: (self: Signal<T...>, Callback: (T...) -> ()) -> Connection<T...>,
	Fire: (self: Signal<T...>, T...) -> (),
	Wait: (self: Signal<T...>) -> T...,
	DisconnectAll: (self: Signal<T...>) -> (),
	GetConnectionCount: (self: Signal<T...>) -> number
}

function Signal.Connect<T...>(self: Signal<T...>, Callback: (T...) -> ()): Connection<T...>
	return self.Connections:emplace_back(Connection.new, Callback)
end

function Signal.Once<T...>(self: Signal<T...>, Callback: (T...) -> ()): Connection<T...>
	local Connection: Connection<T...>

	Connection = self.Connect(function(...: T...)
		Connection:Disconnect()
		Callback(...)
	end)

	return Connection
end

function Signal.DisconnectAll<T...>(self: Signal<T...>): ()
	for _, Connection: Connection<T...> in self.Connections:iter() do
		Connection:Disconnect()
	end

	self.Connections:clear()
end

function Signal.GetConnectionCount<T...>(self: Signal<T...>): number
	return self.Connections:count_if(function(Connection: Connection<T...>)
		return Connection.Connected
	end)
end

function Signal.Fire<T...>(self: Signal<T...>, ...: T...): ()
	local Objects = self.Connections._Objects
	local Size = self.Connections:size()

	for i = 1, Size do
		local Connection: Connection<T...> = Objects[i]
		if not Connection.Connected then continue end

		local Coroutine = Connection.Coroutine
		if Coroutine ~= nil then
			task.defer(Coroutine, ...)
		else
			Coroutine = task.spawn(Connection.Worker, Connection, ...)
			Connection.Coroutine = Coroutine
		end
	end

	self.Connections:erase_if(function(Connection: Connection<T...>)
		return not Connection.Connected
	end)
end

function Signal.Wait<T...>(self: Signal<T...>): T...
	assert(coroutine.isyieldable(), "Signal:Wait() cannot be called from a non-yieldable context")

	local Coroutine = coroutine.running()
	local Connection: Connection<T...>
	Connection = self.Connect(function(...: T...)
		Connection:Disconnect()

		if coroutine.status(Coroutine) == "suspended" then
			coroutine.resume(Coroutine, ...)
		end
	end)

	return coroutine.yield()
end

function Signal.new<T...>(): Signal<T...>
	local self = setmetatable({
		Connections = Vector.new<<Connection<T...>>>()
	}, SignalMetatable)

	return self
end

return Signal
