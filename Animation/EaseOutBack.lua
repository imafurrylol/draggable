-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseOutBack = Animation:Extend()

function EaseOutBack:Evaluate(Start, Target, Progress)
	local c1 = 1.70158
	local c3 = c1 + 1
	local t = 1 + c3 * math.pow(Progress - 1, 3) + c1 * math.pow(Progress - 1, 2)
	return Start + (Target - Start) * t
end

return EaseOutBack
