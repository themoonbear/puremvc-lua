local Mediator = pm.Mediator
local TestCase = {}
TestCase["Test Mediator Constructor"] = function()
	local mediator = Mediator.new()
	should.equal("Expected Mediator.NAME for mediator.getMediatorName()", 
                Mediator.NAME, mediator:getMediatorName())	
end

TestCase["Test Mediator View"] = function()
	local mediator = Mediator.new('TestMediator', 123)
	should.equal("Expected mediator component == 123", 
                mediator:getViewComponent(), 123)	
end

for _, case in pairs(TestCase) do
	print(_ .. ':')
	case()
	print('========================')
end