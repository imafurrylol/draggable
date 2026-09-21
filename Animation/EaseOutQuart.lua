-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseOutQuart = Animation:Extend()

function EaseOutQuart:Evaluate(Start, Target, Progress)
	local t = 1 - math.pow(1 - Progress, 4)
	return Start + (Target - Start) * t
end

return EaseOutQuart
