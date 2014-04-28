local MacroCommandTestSub1Command = class('MacroCommandTestSub1Command', pm.SimpleCommand)

function MacroCommandTestSub1Command:ctor()
end

function MacroCommandTestSub1Command:execute(note)
	local vo = note:getBody()
	vo.result1 = 2 * vo.input
end

return MacroCommandTestSub1Command