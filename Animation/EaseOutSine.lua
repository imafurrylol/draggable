-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseOutSine = Animation:Extend()

function EaseOutSine:Evaluate(Start, Target, Progress)
	local t = math.sin((Progress * math.pi) / 2)
	return Start + (Target - Start) * t
end

return EaseOutSine
