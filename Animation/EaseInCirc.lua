-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseInCirc = Animation:Extend()

function EaseInCirc:Evaluate(Start, Target, Progress)
	local t = 1 - math.sqrt(1 - math.pow(Progress, 2))
	return Start + (Target - Start) * t
end

return EaseInCirc
