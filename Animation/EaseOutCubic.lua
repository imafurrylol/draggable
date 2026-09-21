-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseOutCubic = Animation:Extend()

function EaseOutCubic:Evaluate(Start, Target, Progress)
	local t = 1 - math.pow(1 - Progress, 3)
	return Start + (Target - Start) * t
end

return EaseOutCubic
