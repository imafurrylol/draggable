-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseInCubic = Animation:Extend()

function EaseInCubic:Evaluate(Start, Target, Progress)
	local t = Progress * Progress * Progress
	return Start + (Target - Start) * t
end

return EaseInCubic
