-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseInQuad = Animation:Extend()

function EaseInQuad:Evaluate(Start, Target, Progress)
	local t = Progress * Progress
	return Start + (Target - Start) * t
end

return EaseInQuad
