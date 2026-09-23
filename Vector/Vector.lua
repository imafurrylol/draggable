-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Vector = {}
local VectorMetatable = { __index = Vector }

export type Vector<T> = {
	push_front: (Value: T) -> (),
	push_back: (Value: T) -> (),
	emplace: (Index: number, Constructor: (...any) -> T, ...any) -> (),
	emplace_back: (Constructor: (...any) -> T, ...any) -> (),
	emplace_front: (Constructor: (...any) -> T, ...any) -> (),
	insert: (Index: number, Value: T) -> (),
	erase: (Index: number) -> (),
	at: (Index: number) -> T,
	clear: () -> (),
	empty: () -> boolean,
	size: () -> number,
	iter: () -> () -> (number, T)?,
	find: (Value: T) -> number?,
	find_if: (Predicate: (T) -> boolean) -> (number?, T?),
	filter: (Predicate: (T) -> boolean) -> Vector<T>,
	erase_if: (Predicate: (T) -> boolean) -> (),
	reverse: () -> (),
	pop_front: () -> (),
	pop_back: () -> (),
	front: () -> T,
	back: () -> T
}

local function AssertInBounds<T>(self: Vector<T>, Index: number, Extra: number?)
	local Size = self:size() + (Extra or 0)

	if Index > Size or Index < 1 then
		local FunctionName = debug.info(1, "n") or "?"
		error(FunctionName .. ": index " .. Index .. " out of bounds! begin: 1, end: " .. Size, 2)
	end
end

local function AssertNotEmpty<T>(self: Vector<T>)
	local Size = self:size()

	if Size == 0 then
		local FunctionName = debug.info(1, "n") or "?"
		error(FunctionName .. ": called on empty vector!", 2)
	end
end

local function AssertInteger(Index: number)
	if Index ~= Index or Index % 1 ~= 0 then
		local FunctionName = debug.info(1, "n") or "?"
		error(FunctionName .. ": index must be an integer", 2)
	end
end

local function Insert<T>(self: Vector<T>, Index: number, Value: T)
	local Size = self:size()

	for index = Size, Index, -1 do
		self._Objects[index + 1] = self._Objects[index]
	end

	self._Objects[Index] = Value
end

function Vector:iter()
	local Index = 0
	local Size = self:size()

	return function()
		Index += 1

		if Index <= Size then
			return Index, self._Objects[Index]
		end
	end
end

function Vector.find<T>(self: Vector<T>, Value: T): number?
	for index, value in self:iter() do
		if value == Value then
			return index
		end
	end

	return nil
end

function Vector.find_if<T>(self: Vector<T>, Predicate: (T) -> boolean): (number?, T?)
	for index, value in self:iter() do
		if Predicate(value) then
			return index, value
		end
	end

	return nil, nil
end

function Vector.filter<T>(self: Vector<T>, Predicate: (T) -> boolean): Vector<T>
	local FreshVector = Vector.new<<T>>()
	
	for _, value in self:iter() do
		if Predicate(value) then
			FreshVector:push_back(value)
		end
	end

	return FreshVector
end

function Vector.erase_if<T>(self: Vector<T>, Predicate: (T) -> boolean)
	local Size = self:size()
	local Index = 1

	for index = 1, Size do
		local value = self._Objects[index]

		if not Predicate(value) then
			self._Objects[Index] = value
			Index += 1
		end
	end

	for index = Index, Size do
		self._Objects[index] = nil
	end
end

function Vector:erase(Index: number)
	AssertInteger(Index)
	AssertNotEmpty(self)
	AssertInBounds(self, Index)

	local Size = self:size()
	for index = Index, Size - 1 do
		self._Objects[index] = self._Objects[index + 1]
	end

	self._Objects[Size] = nil
end

function Vector.emplace<T>(self: Vector<T>, Index: number, Constructor: (...any) -> T, ...)
	AssertInteger(Index)
	AssertInBounds(self, Index, 1)
	Insert(self, Index, Constructor(...))
end

function Vector.emplace_back<T>(self: Vector<T>, Constructor: (...any) -> T, ...)
	self:emplace(self:size() + 1, Constructor, ...)
end

function Vector.emplace_front<T>(self: Vector<T>, Constructor: (...any) -> T, ...)
	self:emplace(1, Constructor, ...)
end

function Vector:reverse()
	local Left = 1
	local Right = self:size()

	while Left < Right do
		self._Objects[Left], self._Objects[Right] = self._Objects[Right], self._Objects[Left]

		Left += 1
		Right -= 1
	end
end

function Vector.insert<T>(self: Vector<T>, Index: number, Value: T)
	AssertInteger(Index)
	AssertInBounds(self, Index, 1)
	Insert(self, Index, Value)
end

function Vector:empty()
	return self:size() == 0
end

function Vector:size()
	return #self._Objects
end

function Vector:clear()
	table.clear(self._Objects)
end

function Vector:pop_front()
	AssertNotEmpty(self)
	self:erase(1)
end

function Vector:pop_back()
	AssertNotEmpty(self)
	self._Objects[self:size()] = nil
end

function Vector.push_back<T>(self: Vector<T>, Value: T)
	self._Objects[self:size() + 1] = Value
end

function Vector.push_front<T>(self: Vector<T>, Value: T)
	self:insert(1, Value)
end

function Vector:front()
	AssertNotEmpty(self)
	return self:at(1)
end

function Vector:back()
	AssertNotEmpty(self)
	return self:at(self:size())
end

function Vector:at(Index: number)
	AssertInteger(Index)
	AssertNotEmpty(self)
	AssertInBounds(self, Index)

	return self._Objects[Index]
end

function Vector.new<T>(...: T): Vector<T>
	local self: Vector<T> = setmetatable({}, VectorMetatable)
	self._Objects = { ... }
	return self
end
	
return Vector
