local Facade = pm.Facade
local Notification = pm.Notification
local Proxy = pm.Proxy
local Mediator = pm.Mediator
local FacadeTestCommand = import('.FacadeTestCommand')
local FacadeTestVO = import('.FacadeTestVO')
local FacadeTestMediator= import('.FacadeTestMediator')
local TestCase = {}

TestCase["Test Facade command"] = function()
	local vo = FacadeTestVO.new(32)
	local note = Notification.new('TestNode', vo)
	local testCommand = FacadeTestCommand.new()
	testCommand:execute(note)
	should.equal("Expecting vo.result == 64", vo.result, 64)
end

TestCase["Test Facade send notify"] = function()
	local facade = Facade.getInstance('TestFacade')
	facade:registerCommand('FacadeTestNote', FacadeTestCommand)
	local vo= FacadeTestVO.new(32)
	facade:sendNotification('FacadeTestNote', vo)
	should.equal("Expecting vo.result == 64", vo.result, 64)
	local mediator = FacadeTestMediator.new('FacadeTestMediator')
	facade:registerMediator(mediator)
	facade:sendNotification('FacadeTestMediator')
	should.equal("Expecting mediator.executed == true", mediator.executed, true)		
	Facade.removeCore('TestFacade')
end

TestCase["Test register and retrieve Proxy"] = function()
	local facade = Facade.getInstance('TestFacade')
	facade:registerProxy(Proxy.new('colors', {'red', 'green', 'blue'}))
	local proxy = facade:retrieveProxy('colors')
	local data = proxy:getData()
	should.equal("Expecting data.length == 3", #data, 3)
	should.equal("Expecting data[1] == 'red'", data[1], 'red')
	should.equal("Expecting data[2] == 'green'", data[2], 'green')
	should.equal("Expecting data[3] == 'blue'", data[3], 'blue')				
	Facade.removeCore('TestFacade')
end

TestCase["Test register and remove Proxy"] = function()
	local facade = Facade.getInstance('TestFacade')
	facade:registerProxy(Proxy.new('colors', {'red', 'green', 'blue'}))
	local proxy = facade:removeProxy('colors')
	should.equal("Expecting removed Proxy.getProxyName() == 'colors'", proxy:getProxyName(), "colors")
	proxy = facade:retrieveProxy('colors')
	should.equalNil("Expecting proxy is nil", proxy)				
	Facade.removeCore('TestFacade')
end

TestCase["Test Register Retrieve And Remove Mediator"] = function()
	local facade = Facade.getInstance('TestFacade')
	facade:registerMediator(Mediator.new(Mediator.NAME, {}));
	should.equalNotNil("Expecting mediator is not null", facade:retrieveMediator(Mediator.NAME))
	local removedMediator = facade:removeMediator(Mediator.NAME);
	should.equal("Expecting removedMediator.getMediatorName() == Mediator.NAME", removedMediator:getMediatorName(), Mediator.NAME)
    should.equalNil("Expecting facade.retrieveMediator( Mediator.NAME ) == null )", 
                        facade:retrieveMediator( Mediator.NAME ));					
	Facade.removeCore('TestFacade')
end

TestCase["Test Has Proxy"] = function()
	local facade = Facade.getInstance('TestFacade')
	facade:registerProxy(Proxy.new('hasProxyTest', {1, 2, 3}))
	should.equal("Expecting facade.hasProxy('hasProxyTest') == true",
		facade:hasProxy('hasProxyTest'), true)					
	Facade.removeCore('TestFacade')
end

TestCase["Test Has Mediator"] = function()
	local facade = Facade.getInstance('TestFacade')
	facade:registerMediator(Mediator.new('facadeHasMediatorTest', {1, 2, 3}))
	should.equal("Expecting facade.hasMediator('facadeHasMediatorTest') == true",
		facade:hasMediator('facadeHasMediatorTest'), true)
	facade:removeMediator('facadeHasMediatorTest')
	should.equal("Expecting facade.hasMediator('facadeHasMediatorTest') == false",
		facade:hasMediator('facadeHasMediatorTest'), false)					
	Facade.removeCore('TestFacade')
end

TestCase["Test Has Command"] = function()
	local facade = Facade.getInstance('TestFacade')
	facade:registerCommand('facadeHasCommandTest', FacadeTestCommand)
	should.equal("Expecting facade.hasCommand('facadeHasCommandTest') == true",
		facade:hasCommand('facadeHasCommandTest'), true)
	facade:removeCommand('facadeHasCommandTest')
	should.equal("Expecting facade.hasCommand('facadeHasCommandTest') == false",
		facade:hasCommand('facadeHasCommandTest'), false)					
	Facade.removeCore('TestFacade')
end

TestCase["Test Has Core and Remove Core"] = function()
	local facade = Facade.getInstance('TestFacade')
	should.equal("Expecting facade.hasCore('TestFacade') == true",
		Facade.hasCore('TestFacade'), true)
	Facade.removeCore('TestFacade')
	should.equal("Expecting facade.hasCore('TestFacade') == false",
		Facade.hasCore('TestFacade'), false)
end

for _, case in pairs(TestCase) do
	print(_ .. ':')
	case()
	print('========================')	
end