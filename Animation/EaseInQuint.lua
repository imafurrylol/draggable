-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseInQuint = Animation:Extend()

function EaseInQuint:Evaluate(Start, Target, Progress)
	local t = Progress * Progress * Progress * Progress * Progress
	return Start + (Target - Start) * t
end

return EaseInQuint
