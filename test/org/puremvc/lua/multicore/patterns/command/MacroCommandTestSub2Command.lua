local MacroCommandTestSub2Command = class('MacroCommandTestSub2Command', pm.SimpleCommand)

function MacroCommandTestSub2Command:ctor()
end

function MacroCommandTestSub2Command:execute(note)
	local vo = note:getBody()
	vo.result2 = vo.input * vo.input
end

return MacroCommandTestSub2Command