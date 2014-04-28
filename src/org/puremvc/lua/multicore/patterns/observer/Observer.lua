--[[
 * @author PureMVC Lua Native Port by Sean 
 * @author Copyright(c) 2006-2012 Futurescale, Inc., Some rights reserved.
 * 
 * @class puremvc.Observer
 * 
 * A base Observer implementation.
 * 
 * An Observer is an object that encapsulates information
 * about an interested object with a method that should 
 * be called when a particular Notification is broadcast. 
 * 
 * In PureMVC, the Observer class assumes these responsibilities:
 * 
 * - Encapsulate the notification (callback) method of the interested object.
 * - Encapsulate the notification context (this) of the interested object.
 * - Provide methods for setting the notification method and context.
 * - Provide a method for notifying the interested object.
 * 
 * 
 * The notification method on the interested object should take 
 * one parameter of type Notification.
 * 
 * 
 * @param {Function} notifyMethod 
 *  the notification method of the interested object
 * @param {Object} notifyContext 
 *  the notification context of the interested object
 * @constructor
]]
local Observer = class('Observer')

function Observer:ctor(notifyMethod, notifyContext)
	self:setNotifyMethod(notifyMethod)
	self:setNotifyContext(notifyContext)
end
--[[
 * Set the Observers notification method.
 * 
 * The notification method should take one parameter of type Notification
 * @param {Function} notifyMethod
 *  the notification (callback) method of the interested object.
 * @return {void}
]]
function Observer:setNotifyMethod(notifyMethod)
	self.notify = notifyMethod
end
--[[
 * Set the Observers notification context.
 * 
 * @param {Object} notifyContext
 *  the notification context (this) of the interested object.
 * 
 * @return {void}
]]
function Observer:setNotifyContext(notifyContext)
	self.context = notifyContext
end
--[[
 * Get the Function that this Observer will invoke when it is notified.
 * 
 * @private
 * @return {Function}
]]
function Observer:getNotifyMethod()
	return self.notify
end
--[[
 * Get the Object that will serve as the Observers callback execution context
 * 
 * @private
 * @return {Object}
]]
function Observer:getNotifyContext()
	return self.context
end
--[[
 * Notify the interested object.
 * 
 * @param {puremvc.Notification} notification
 *  The Notification to pass to the interested objects notification method
 * @return {void}
]]
function Observer:notifyObserver(notification)
	self.notify(self.context, notification)
end
--[[
 * Compare an object to this Observers notification context.
 * 
 * @param {Object} object
 *  
 * @return {boolean}
]]
function Observer:compareNotifyContext(object)
	return object == self.context
end

return Observer