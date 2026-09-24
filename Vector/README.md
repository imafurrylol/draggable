https://create.roblox.com/store/asset/81712460662745

C++ std::vector-ish vector implementation. No documentation/example usage, read the type.

```lua
local vector = Vector.new<<number>>()
local vector2 = Vector.new("hello")
```

```lua
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
```
