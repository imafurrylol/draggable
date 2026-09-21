-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseOutQuad = Animation:Extend()

function EaseOutQuad:Evaluate(Start, Target, Progress)
	local t = 1 - (1 - Progress) * (1 - Progress)
	return Start + (Target - Start) * t
end

return EaseOutQuad
