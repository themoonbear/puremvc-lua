local MacroCommandTestVO = class('MacroCommandTestVO')

function MacroCommandTestVO:ctor(input)
	self.input = input
	self.result1 = nil
	self.result2 = nil
end

return MacroCommandTestVO