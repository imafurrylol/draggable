-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseInExpo = Animation:Extend()

function EaseInExpo:Evaluate(Start, Target, Progress)
	local t = Progress == 0 and 0 or math.pow(2, 10 * Progress - 10);
	return Start + (Target - Start) * t
end

return EaseInExpo
