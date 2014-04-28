local FacadeTestMediator = class('FacadeTestMediator', pm.Mediator)

function FacadeTestMediator:ctor(...)
	FacadeTestMediator.super.ctor(self,...)
	self.executed = false
end

function FacadeTestMediator:listNotificationInterests()
	return {'FacadeTestMediator'}
end

function FacadeTestMediator:handleNotification(notification)
	self.executed = true
end

return FacadeTestMediator