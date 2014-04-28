local Proxy = pm.Proxy
local TestCase = {}
TestCase["Test Proxy Constructor"] = function()
	local proxy = Proxy.new('TestProxy', 1234)
	should.equal("Expecting proxy.name == 'TestProxy'", proxy:getProxyName(), 'TestProxy')	
end

TestCase["Test Proxy:getData()"] = function()
	local proxy = Proxy.new('TestProxy', 1234)
	should.equal("Expecting note.data == 1234", proxy:getData(), 1234)	
end

TestCase["Test Proxy:setData()"] = function()
	local proxy = Proxy.new()
	proxy:setData(111)
	should.equal("Expecting note.data == 111", proxy:getData(), 111)	
end

TestCase["Test Proxy:getProxyName() by default"] = function()
	local proxy = Proxy.new()
	should.equal("Expecting note.name == " .. Proxy.NAME, proxy:getProxyName(), Proxy.NAME)	
end

for _, case in pairs(TestCase) do
	print(_ .. ':')
	case()
	print('========================')
end