-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseOutExpo = Animation:Extend()

function EaseOutExpo:Evaluate(Start, Target, Progress)
	local t = Progress == 1 and 1 or 1 - math.pow(2, -10 * Progress)
	return Start + (Target - Start) * t
end

return EaseOutExpo
