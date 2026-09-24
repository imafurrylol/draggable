-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Vector = {}
local VectorMetatable = { __index = Vector }

export type Vector<T> = {
	front: () -> T,
	back: () -> T,

	push_front: (Value: T) -> T,
	push_back: (Value: T) -> T,

	pop_front: () -> (),
	pop_back: () -> (),
	
	emplace: (Index: number, Constructor: (...any) -> T, ...any) -> T,
	emplace_back: (Constructor: (...any) -> T, ...any) -> T,
	emplace_front: (Constructor: (...any) -> T, ...any) -> T,

	insert: (Index: number, Value: T) -> T,

	erase: (Index: number) -> (),
	erase_if: (Predicate: (T) -> boolean) -> (),
	erase_range: (Begin: number, End: number) -> (), -- vector:erase_range(1, 4) results in indexes 1, 2 and 3 being erased, 4 is left and moved to the first index (if there were only 4 objects in the vector)
	at: (Index: number) -> T, -- vector:at(3)

	clear: () -> (),
	empty: () -> boolean,
	size: () -> number,
	count: (Value: T) -> number,
	count_if: (Predicate: (T) -> boolean) -> number,

	iter: () -> () -> (number, T)?,

	find: (Value: T) -> number?,
	find_if: (Predicate: (T) -> boolean) -> (number?, T?),
	contains: (Value: T) -> boolean,

	filter: (Predicate: (T) -> boolean) -> Vector<T>,
	sort: (Comparator: (T, T) -> boolean) -> (),
	reverse: () -> (),
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

local function Insert<T>(self: Vector<T>, Index: number, Value: T): T
	local Size = self:size()

	for index = Size, Index, -1 do
		self._Objects[index + 1] = self._Objects[index]
	end

	self._Objects[Index] = Value
	return self._Objects[Index]
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

function Vector.contains<T>(self: Vector<T>, Value: T): boolean
	return self:find(Value) ~= nil
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
	local Size = self:size()

	for index = 1, Size do
		local value = self._Objects[index]

		if Predicate(value) then
			FreshVector:push_back(value)
		end
	end

	return FreshVector
end

function Vector.sort<T>(self: Vector<T>, Comparator: (T, T) -> boolean)
	local Size = self:size()

	if Size <= 1 then
		return
	end

	local Buffer = table.create(Size)

	local function Merge(Low: number, Mid: number, High: number)
		local Left = Low
		local Right = Mid + 1
		local Index = Low

		while Left <= Mid and Right <= High do
			if Comparator(self._Objects[Left], self._Objects[Right]) then
				Buffer[Index] = self._Objects[Left]
				Left += 1
			else
				Buffer[Index] = self._Objects[Right]
				Right += 1
			end

			Index += 1
		end

		while Left <= Mid do
			Buffer[Index] = self._Objects[Left]
			Left += 1
			Index += 1
		end

		while Right <= High do
			Buffer[Index] = self._Objects[Right]
			Right += 1
			Index += 1
		end

		for i = Low, High do
			self._Objects[i] = Buffer[i]
		end
	end

	local function Sort(Low: number, High: number)
		if Low >= High then
			return
		end

		local Mid = math.floor((Low + High) / 2)
		Sort(Low, Mid)
		Sort(Mid + 1, High)

		if not Comparator(self._Objects[Mid + 1], self._Objects[Mid]) then
			return
		end

		Merge(Low, Mid, High)
	end

	Sort(1, Size)
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

function Vector.erase_range<T>(self: Vector<T>, Begin: number, End: number)
	AssertInteger(Begin)
	AssertInteger(End)
	AssertInBounds(self, Begin, -1)
	AssertInBounds(self, End, 1)
	if Begin > End then
		error("erase_range: begin index " .. Begin .. " is greater than end index " .. End, 2)
	end

	local Size = self:size()
	local Index = 1
	for index = 1, Size do
		local value = self._Objects[index]

		if index < Begin or index >= End then
			self._Objects[Index] = value
			Index += 1
		end
	end

	for index = Index, Size do
		self._Objects[index] = nil
	end
end

function Vector.count<T>(self: Vector<T>, Value: T): number
	local Count = 0
	local Size = self:size()

	for index = Size, 1, -1 do
		local value = self._Objects[index]

		if value == Value then
			Count += 1
		end
	end

	return Count
end

function Vector.count_if<T>(self: Vector<T>, Predicate: (T) -> boolean): number
	local Count = 0
	local Size = self:size()

	for index = Size, 1, -1 do
		local value = self._Objects[index]
		if Predicate(value) then
			Count += 1
		end
	end

	return Count
end

function Vector:erase(Index: number)
	AssertInteger(Index)
	AssertInBounds(self, Index)

	local Size = self:size()
	for index = Index, Size - 1 do
		self._Objects[index] = self._Objects[index + 1]
	end

	self._Objects[Size] = nil
end

function Vector.emplace<T>(self: Vector<T>, Index: number, Constructor: (...any) -> T, ...): T
	AssertInteger(Index)
	AssertInBounds(self, Index, 1)
	return Insert(self, Index, Constructor(...))
end

function Vector.emplace_back<T>(self: Vector<T>, Constructor: (...any) -> T, ...): T
	return self:emplace(self:size() + 1, Constructor, ...)
end

function Vector.emplace_front<T>(self: Vector<T>, Constructor: (...any) -> T, ...): T
	return self:emplace(1, Constructor, ...)
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
	return Insert(self, Index, Value)
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

function Vector.push_back<T>(self: Vector<T>, Value: T): T
	local Index = self:size() + 1
	self._Objects[Index] = Value
	return self._Objects[Index]
end

function Vector.push_front<T>(self: Vector<T>, Value: T): T
	return self:insert(1, Value)
end

function Vector:front()
	return self:at(1)
end

function Vector:back()
	return self:at(self:size())
end

function Vector:at(Index: number)
	AssertInteger(Index)
	AssertInBounds(self, Index)

	return self._Objects[Index]
end

function Vector.new<T>(...: T): Vector<T>
	local self: Vector<T> = setmetatable({}, VectorMetatable)
	self._Objects = { ... }
	return self
end

return Vector
