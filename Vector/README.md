Basically a fancy wrapper for normal tables.

```lua
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
```
