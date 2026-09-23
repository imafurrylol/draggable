Draggable (https://create.roblox.com/store/asset/78228119243178) example:

```lua
local Draggable = require(game.ReplicatedStorage.Draggable)
local drag = Draggable.New(script.Parent)
-- options:
-- Smooth: boolean (whether it smooths or not, default is true)
-- Speed: number (higher = faster, lower = slower, default is 0.44)
-- Handle: GuiObject (default is nil, if not set, anywhere on the input GuiObject will start the drag)
-- example: local drag = Draggable.New(GUI, { Smooth = false, Handle = GUI.handle })

drag.OnStartDragging = function()
	print("start")
end

drag.OnStopDragging = function()
	print("stop")
end

drag.OnUpdate = function(position) -- Called until the GuiObject has reached the position it was dragged to
	print("x: " .. position.X.Offset .. ", y: " .. position.Y.Offset)
end

task.wait(5)
drag.Destroy()
```
