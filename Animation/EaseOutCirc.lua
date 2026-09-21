-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseOutCirc = Animation:Extend()

function EaseOutCirc:Evaluate(Start, Target, Progress)
	local t = math.sqrt(1 - math.pow(Progress - 1, 2))
	return Start + (Target - Start) * t
end

return EaseOutCirc
