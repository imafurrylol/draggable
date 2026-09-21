-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local LerpAnimation = Animation:Extend()

function LerpAnimation:Evaluate(Start, Target, Progress)
	return Start + (Target - Start) * Progress
end

return LerpAnimation
