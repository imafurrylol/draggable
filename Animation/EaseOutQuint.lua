-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseOutQuint = Animation:Extend()

function EaseOutQuint:Evaluate(Start, Target, Progress)
	local t = 1 - math.pow(1 - Progress, 5)
	return Start + (Target - Start) * t
end

return EaseOutQuint
