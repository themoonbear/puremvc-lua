local MacroCommandTestSub1Command = import(".MacroCommandTestSub1Command")
local MacroCommandTestSub2Command = import(".MacroCommandTestSub2Command")

local MacroCommandTestCommand = class('MacroCommandTestCommand', pm.MacroCommand)

function MacroCommandTestCommand:ctor()
	MacroCommandTestCommand.super.ctor(self)
end

function MacroCommandTestCommand:initializeMacroCommand()
	self:addSubCommand(MacroCommandTestSub1Command)
	self:addSubCommand(MacroCommandTestSub2Command)
end

return MacroCommandTestCommand