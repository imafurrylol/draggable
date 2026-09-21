-- created by @xvZiuV9zoZsEqkfWwyWc on Roblox
local Animation = require(script.Parent)
local EaseOutBounce = Animation:Extend()

function EaseOutBounce:Evaluate(Start, Target, Progress)
	local n1 = 7.5625
	local d1 = 2.75
	local t

	if (Progress < 1 / d1) then
		t = n1 * Progress * Progress
	elseif (Progress < 2 / d1) then
		t = n1 * (Progress -= 1.5 / d1) * Progress + 0.75
	elseif (Progress < 2.5 / d1) then
		t = n1 * (Progress -= 2.25 / d1) * Progress + 0.9375
	else
		t = n1 * (Progress -= 2.625 / d1) * Progress + 0.984375
	end

	return Start + (Target - Start) * t
end

return EaseOutBounce
