-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseInBack = Animation:Extend()

function EaseInBack:Evaluate(Start, Target, Progress)
	local c1 = 1.70158
	local c3 = c1 + 1
	local t = c3 * Progress * Progress * Progress - c1 * Progress * Progress
	return Start + (Target - Start) * t
end

return EaseInBack
