--[[
 * @author PureMVC Lua Native Port by Sean 
 * @author Copyright(c) 2006-2012 Futurescale, Inc., Some rights reserved.
 * 
 * @class puremvc.View
 * 
 * A Multiton View implementation.
 * 
 * In PureMVC, the View class assumes these responsibilities
 * 
 * - Maintain a cache of {@link puremvc.Mediator Mediator}
 *   instances.
 * 
 * - Provide methods for registering, retrieving, and removing 
 *   {@link puremvc.Mediator Mediator}.
 * 
 * - Notifiying {@link puremvc.Mediator Mediator} when they are registered or 
 *   removed.
 * 
 * - Managing the observer lists for each {@link puremvc.Notification Notification}  
 *   in the application.
 * 
 * - Providing a method for attaching {@link puremvc.Observer Observer} to an 
 *   {@link puremvc.Notification Notification}'s observer list.
 * 
 * - Providing a method for broadcasting a {@link puremvc.Notification Notification}.
 * 
 * - Notifying the {@link puremvc.Observer Observer}s of a given 
 *   {@link puremvc.Notification Notification} when it broadcast.
 * 
 * This View implementation is a Multiton, so you should not call the 
 * constructor directly, but instead call the static Multiton 
 * Factory #getInstance method.
 * 
 * @param {string} key
 * @constructor
 * @throws {Error} 
 *  if instance for this Multiton key has already been constructed
]]
local Observer = import('..patterns.observer.Observer')
local View = class('View')

function View:ctor(key)
	if View.instanceMap[key] ~= nil then
		error(View.MULTITON_MSG)
	end
	self.multitonKey = key
	View.instanceMap[self.multitonKey] = self
	self.mediatorMap = {}
	self.observerMap = {}
	self:initializeView()
end
--[[
 * @protected
 * Initialize the Singleton View instance
 * 
 * Called automatically by the constructor, this is your opportunity to
 * initialize the Singleton instance in your subclass without overriding the
 * constructor
 * 
 * @return {void}
]]
function View:initializeView() end
--[[
 * View Singleton Factory method.
 * Note that this method will return null if supplied a null 
 * or undefined multiton key.
 *  
 * @return {puremvc.View}
 *  The Singleton instance of View
]]
function View.getInstance(key)
	if nil == key then
		return nil
	end
	if View.instanceMap[key] == nil then
		View.instanceMap[key] = View.new(key)
	end
	return View.instanceMap[key]
end
--[[
 * Register an Observer to be notified of Notifications with a given name
 * 
 * @param {string} notificationName
 *  The name of the Notifications to notify this Observer of
 * @param {puremvc.Observer} observer
 *  The Observer to register.
 * @return {void}
]]
function View:registerObserver(notificationName, observer)
	if self.observerMap[notificationName] ~= nil then
		table.insert(self.observerMap[notificationName], observer)
	else
		self.observerMap[notificationName] = {observer}
	end
end
--[[
 * Notify the Observersfor a particular Notification.
 * 
 * All previously attached Observers for this Notification's
 * list are notified and are passed a reference to the INotification in 
 * the order in which they were registered.
 * 
 * @param {puremvc.Notification} notification
 *  The Notification to notify Observers of
 * @return {void}
]]
function View:notifyObservers(notification)
	if self.observerMap[notification:getName()] ~= nil then
		local observers_ref = self.observerMap[notification:getName()]
		local observers = {}
		local observer
		for _, o in pairs(observers_ref) do
			table.insert(observers, o)
		end

		for _, o in pairs(observers) do
			o:notifyObserver(notification)
		end
	end
end
--[[
 * Remove the Observer for a given notifyContext from an observer list for
 * a given Notification name
 * 
 * @param {string} notificationName
 *  Which observer list to remove from
 * @param {Object} notifyContext
 *  Remove the Observer with this object as its notifyContext
 * @return {void}
 ]]
 function View:removeObserver(notificationName, notifyContext)
 	local observers = self.observerMap[notificationName]
 	for _, o in pairs(observers) do
 		if o:compareNotifyContext(notifyContext) then
 			table.remove(o, _)
 			break
 		end
 	end

 	if #observers == 0 then
 		self.observerMap[notificationName] = nil
 	end
 end
--[[
 * Register a Mediator instance with the View.
 * 
 * Registers the Mediator so that it can be retrieved by name,
 * and further interrogates the Mediator for its 
 * {@link puremvc.Mediator#listNotificationInterests interests}.
 *
 * If the Mediator returns any Notification
 * names to be notified about, an Observer is created encapsulating 
 * the Mediator instance's 
 * {@link puremvc.Mediator#handleNotification handleNotification}
 * method and registering it as an Observer for all Notifications the 
 * Mediator is interested in.
 * 
 * @param {puremvc.Mediator} 
 *  a reference to the Mediator instance
]]
function View:registerMediator(mediator)
	if self.mediatorMap[mediator:getMediatorName()] ~= nil then
		return
	end
	mediator:initializeNotifier(self.multitonKey)
	self.mediatorMap[mediator:getMediatorName()] = mediator
	local interests = mediator:listNotificationInterests()
	if #interests > 0 then
		local observer = Observer.new(mediator.handleNotification, mediator)
		for _, i in pairs(interests) do
			self:registerObserver(i, observer)
		end
	end
	mediator:onRegister()
end
--[[
 * Retrieve a Mediator from the View
 * 
 * @param {string} mediatorName
 *  The name of the Mediator instance to retrieve
 * @return {puremvc.Mediator}
 *  The Mediator instance previously registered with the given mediatorName
]]
function View:retrieveMediator(mediatorName)
	return self.mediatorMap[mediatorName]
end
--[[
 * Remove a Mediator from the View.
 * 
 * @param {string} mediatorName
 *  Name of the Mediator instance to be removed
 * @return {puremvc.Mediator}
 *  The Mediator that was removed from the View
]]
function View:removeMediator(mediatorName)
	local mediator = self.mediatorMap[mediatorName]
	if mediator ~= nil then
		local interests = mediator:listNotificationInterests()
		for _, i in pairs(interests) do
			self:removeObserver(i, mediator)
		end
		self.mediatorMap[mediatorName] = nil
		mediator:onRemove()
	end
	return mediator
end
--[[
 * Check if a Mediator is registered or not.
 * 
 * @param {string} mediatorName
 * @return {boolean}
 *  Whether a Mediator is registered with the given mediatorname
 ]]
function View:hasMediator(mediatorName)
	return self.mediatorMap[mediatorName] ~= nil
end
--[[
 * Remove a View instance
 * 
 * @return {void}
]]
function View.removeView(key)
	View.instanceMap[key] = nil
end
--[[
 * @ignore
 * The internal map used to store multiton View instances
 *
 * @type Array
 * @protected
]]
View.instanceMap = {}
--[[
 * @ignore
 * The error message used if an attempt is made to instantiate View directly
 *
 * @type string
 * @protected
 * @const
 * @static
]]
View.MULTITON_MSG = "View instance for this Multiton key already constructed!"

return View