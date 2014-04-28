--[[
 * @author PureMVC Lua Native Port by Sean 
 * @author Copyright(c) 2006-2012 Futurescale, Inc., Some rights reserved.
 * 
 * @class puremvc.Mediator
 * @extends puremvc.Notifier
 * 
 * A base Mediator implementation.
 *
 * In PureMVC, Mediator classes are used to mediate communication between a view 
 * component and the rest of the application.
 *
 * A Mediator should listen to its view components for events, and handle them 
 * by sending notifications (to be handled by other Mediators, 
 * {@link puremvc.SimpleCommand SimpleCommands} 
 * or
 * {@link puremvc.MacroCommand MacroCommands}) 
 * or passing data from the view component directly to a 
 * {@link puremvc.Proxy Proxy}, such as submitting 
 * the contents of a form to a service.
 * 
 * Mediators should not perform business logic, maintain state or other 
 * information for its view component, or break the encapsulation of the view 
 * component by manipulating the view component's children. It should only call 
 * methods or set properties on the view component.
 *  
 * The view component should encapsulate its own behavior and implementation by 
 * exposing methods and properties that the Mediator can call without having to 
 * know about the view component's children.
 * 
 * @constructor
 * @param {string} [mediatorName]
 *  The Mediators name. The Mediators static #NAME value is used by default
 * @param {Object} [viewComponent]
 *  The Mediators {@link #setViewComponent viewComponent}.
]]
local Notifier = import('..observer.Notifier')
local Mediator = class('Mediator', Notifier)

function Mediator:ctor(mediatorName, viewComponent)
	self.mediatorName = mediatorName or Mediator.NAME
	self.viewComponent = viewComponent
end
--[[
 * @static
 * The name of the Mediator.
 * 
 * Typically, a Mediator will be written to serve one specific control or group
 * of controls and so, will not have a need to be dynamically named.
 * 
 * @type {string}
]]
Mediator.NAME = 'Mediator'
--[[
 * Get the name of the Mediator
 * 
 * @return {string}
 *  The Mediator name
]]
function Mediator:getMediatorName()
	return self.mediatorName
end
--[[
 * Set the Mediators view component. This could
 * be a HTMLElement, a bespoke UiComponent wrapper
 * class, a MooTools Element, a jQuery result or a
 * css selector, depending on which DOM abstraction 
 * library you are using.
 * 
 * 
 * @param {Object} the view component
 * @return {void}
]]
function Mediator:setViewComponent(viewComponent)
	self.viewComponent = viewComponent
end
--[[
 * Get the Mediators view component.
 * 
 * Additionally, an optional explicit getter can be
 * be defined in the subclass that defines the 
 * view components, providing a more semantic interface
 * to the Mediator.
 * 
 * This is different from the AS3 implementation in
 * the sense that no casting is required from the
 * object supplied as the view component.
 * 
 *     MyMediator.prototype.getComboBox= function ()
 *     {
 *         return this.viewComponent;  
 *     }
 * 
 * @return {Object}
 *  The view component
 ]]
function Mediator:getViewComponent()
	return self.viewComponent
end
--[[
 * List the Notification names this Mediator is interested
 * in being notified of.
 * 
 * @return {Array} 
 *  The list of Notification names.
]]
function Mediator:listNotificationInterests()
	return {}
end
--[[
 * Handle Notifications.
 * 
 * Typically this will be handled in a switch statement
 * with one 'case' entry per Notification the Mediator
 * is interested in
 * 
 * @param {puremvc.Notification} notification
 * @return {void}
]]
function Mediator:handleNotification(notification)
end
--[[
 * Called by the View when the Mediator is registered
 * @return {void}
]]
function Mediator:onRegister()
end
--[[
 * Called by the View when the Mediator is removed
]]
function Mediator:onRemove()
end

return Mediator