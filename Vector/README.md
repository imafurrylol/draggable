https://create.roblox.com/store/asset/81712460662745

C++ std::vector-ish vector implementation. No documentation/example usage, read the type.

```lua
local vector = Vector.new<<number>>()
local vector2 = Vector.new("hello")
```

```lua
export type Vector<T> = {
	push_front: (Value: T) -> (), -- vector:push_front(1)
	push_back: (Value: T) -> (), -- vector:push_back(1)
	emplace: (Index: number, Constructor: (...any) -> T, ...any) -> (),
	emplace_back: (Constructor: (...any) -> T, ...any) -> (),
	emplace_front: (Constructor: (...any) -> T, ...any) -> (),
	insert: (Index: number, Value: T) -> (), -- vector:insert(3, 4)
	erase: (Index: number) -> (), -- vector:erase(3)
	at: (Index: number) -> T, -- vector:at(3)
	clear: () -> (), -- vector:clear()
	empty: () -> boolean, -- vector:empty()
	size: () -> number, -- vector:size()
	iter: () -> () -> (number, T)?, -- for index, value in vector:iter()
	find: (Value: T) -> number?, -- local index = vector:find(4)
	contains: (Value: T) -> boolean, -- if vector:contains(4) then ...
	find_if: (Predicate: (T) -> boolean) -> (number?, T?), -- local index, value = vector:find_if(function(v) return v == 4 end)
	filter: (Predicate: (T) -> boolean) -> Vector<T>, -- local nofours = vector:filter(function(v) return v == 4 end)
	sort: (Comparator: (T, T) -> boolean) -> (), -- vector:sort(function(v, v1) return v < v1 end)
	erase_if: (Predicate: (T) -> boolean) -> (), -- vector:erase_if(function(v) return v ~= 4 end)
	erase_range: (Begin: number, End: number) -> (), -- vector:erase_range(1, 4) -- erases 1,2,3
	count: (Value: T) -> number, -- local fours = vector:count(4)
	count_if: (Predicate: (T) -> boolean) -> number, -- local fours = vector:count_if(function(v) return v == 4 end)
	reverse: () -> (), -- vector:reverse()
	pop_front: () -> (), -- vector:pop_front()
	pop_back: () -> (), -- vector:pop_front()
	front: () -> T, -- local front = vector:front()
	back: () -> T -- local back = vector:back()
}
```
