-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseInQuart = Animation:Extend()

function EaseInQuart:Evaluate(Start, Target, Progress)
	local t = Progress * Progress * Progress * Progress
	return Start + (Target - Start) * t
end

return EaseInQuart
