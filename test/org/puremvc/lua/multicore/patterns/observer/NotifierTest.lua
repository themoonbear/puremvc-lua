local Notifier = pm.Notifier
local Facade = pm.Facade

local TestCase = {}
TestCase["Test Notifier:initializeNotifier()"] = function()
	local notifier = Notifier.new()
	should.equalNil("Expecting note.facade == 'nil'", notifier.facade)
	local facade = Facade.getInstance('123')
	notifier:initializeNotifier('123')
	should.equal("Expecting note.facade exist", notifier.facade, facade)
	Facade.removeCore('123')
end

for _, case in pairs(TestCase) do
	print(_ .. ':')
	case()
	print('========================')	
end