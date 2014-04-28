local FacadeTestCommand = class('FacadeTestCommand', pm.SimpleCommand)

function FacadeTestCommand:ctor()
	self.executed = false
end

function FacadeTestCommand:execute(note)
	local vo = note:getBody()
	self.executed = true
	vo.result = 2 * vo.input
end

return FacadeTestCommand
