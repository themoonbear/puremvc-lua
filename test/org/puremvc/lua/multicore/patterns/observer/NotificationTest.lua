local Notification = pm.Notification
local TestCase = {}
TestCase["Test Notification:getName()"] = function()
	local notification = Notification.new('TestNote')
	should.equal("Expecting note.getName() == 'TestNote'", notification:getName(), 'TestNote')
end

TestCase["Test Notification:getBody()"] = function()
	local notification = Notification.new('TestNote')
	notification:setBody(5)
	should.equal("Expecting note.getBody() == 5", notification:getBody(), 5)
end

TestCase["Test Notification Constructor"] = function()
	local notification = Notification.new('TestNode', 5, 'type')
	should.equal("Expecting note.getName() == TestNode", notification:getName(), 'TestNode')	
	should.equal("Expecting note.getBody() == 5", notification:getBody(), 5)
	should.equal("Expecting note.getType() == type", notification:getType(), 'type')	
end

for _, case in pairs(TestCase) do
	print(_ .. ':')
	case()
	print('========================')	
end