-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseInSine = Animation:Extend()

function EaseInSine:Evaluate(Start, Target, Progress)
	local t = 1 - math.cos((Progress * math.pi) / 2)
	return Start + (Target - Start) * t
end

return EaseInSine
