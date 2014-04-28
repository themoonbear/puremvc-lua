local MacroCommandTestCommand = import('.MacroCommandTestCommand')
local MacroCommandTestVO = import('.MacroCommandTestVO')
local Notification = pm.Notification

local TestCase = {}

TestCase["Test Macro command"] = function()
	local vo = MacroCommandTestVO.new(5)
	local note = Notification.new('TestNode', vo)
	local testCommand = MacroCommandTestCommand.new()
	testCommand:initializeNotifier('MacroCommandTestCommand')
	testCommand:execute(note)
	should.equal("Expecting vo.result1 == 10", vo.result1, 10)
	should.equal("Expecting vo.result2 == 25", vo.result2, 25)	
end

for _, case in pairs(TestCase) do
	print(_ .. ':')
	case()
	print('========================')	
end