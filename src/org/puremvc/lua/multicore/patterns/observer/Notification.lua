--[[
 * @author PureMVC Lua Native Port by Sean 
 * @author Copyright(c) 2006-2012 Futurescale, Inc., Some rights reserved.
 * 
 * @class puremvc.Notification
 * 
 * A base Notification implementation.
 * 
 * PureMVC does not rely upon underlying event models such as the one provided 
 * with the DOM or other browser centric W3C event models.
 * 
 * The Observer Pattern as implemented within PureMVC exists to support 
 * event-driven communication between the application and the actors of the MVC 
 * triad.
 * 
 * Notifications are not meant to be a replacement for events in the browser. 
 * Generally, Mediator implementors place event listeners on their view 
 * components, which they then handle in the usual way. This may lead to the 
 * broadcast of Notifications to trigger commands or to communicate with other 
 * Mediators. {@link puremvc.Proxy Proxy},
 * {@link puremvc.SimpleCommand SimpleCommand}
 * and {@link puremvc.MacroCommand MacroCommand}
 * instances communicate with each other and 
 * {@link puremvc.Mediator Mediator}s
 * by broadcasting Notifications.
 * 
 * A key difference between browser events and PureMVC Notifications is that
 * events follow the 'Chain of Responsibility' pattern, 'bubbling' up the 
 * display hierarchy until some parent component handles the event, while 
 * PureMVC Notification follow a 'Publish/Subscribe' pattern. PureMVC classes 
 * need not be related to each other in a parent/child relationship in order to 
 * communicate with one another using Notifications.
 * 
 * @constructor 
 * @param {string} name
 *  The Notification name
 * @param {Object} [body]
 *  The Notification body
 * @param {Object} [type]
 *  The Notification type
]]
local Notification = class("Notification")

function Notification:ctor(name, body, type)
	self.name = name
	self.body = body
	self.type = type
end
--[[
 * Get the name of the Notification instance
 *
 * @return {string}
 *  The name of the Notification instance
]]
function Notification:getName()
	return self.name
end
--[[
 * Set this Notifications body. 
 * @param {Object} body
 * @return {void}
]]
function Notification:setBody(body)
	self.body = body
end
--[[
 * Get the Notification body.
 *
 * @return {Object}
]]
function Notification:getBody()
	return self.body
end
--[[
 * Set the type of the Notification instance.
 *
 * @param {Object} type
 * @return {void}
]]
function Notification:setType(type)
	self.type = type
end
--[[
 * Get the type of the Notification instance.
 * 
 * @return {Object}
]]
function Notification:getType()
	return self.type
end
--[[
 * Get a string representation of the Notification instance
 *
 * @return {string}
]]
function Notification:toString()
	local msg = "Notification Name: " .. self:getName()
	msg = msg .. "\nBody: " .. tostring(self:getBody())
	msg = msg .. "\nType: " .. self:getType()
	return msg
end

return Notification