--[[
 * @author PureMVC Lua Native Port by Sean 
 * @author Copyright(c) 2006-2012 Futurescale, Inc., Some rights reserved.
 * 
 * @class puremvc.Controller
 * 
 * In PureMVC, the Controller class follows the 'Command and Controller' 
 * strategy, and assumes these responsibilities:
 * 
 * - Remembering which
 * {@link puremvc.SimpleCommand SimpleCommand}s
 * or 
 * {@link puremvc.MacroCommand MacroCommand}s
 * are intended to handle which 
 * {@link puremvc.Notification Notification}s
 * - Registering itself as an 
 * {@link puremvc.Observer Observer} with
 * the {@link puremvc.View View} for each 
 * {@link puremvc.Notification Notification}
 * that it has an 
 * {@link puremvc.SimpleCommand SimpleCommand} 
 * or {@link puremvc.MacroCommand MacroCommand} 
 * mapping for.
 * - Creating a new instance of the proper 
 * {@link puremvc.SimpleCommand SimpleCommand}s
 * or 
 * {@link puremvc.MacroCommand MacroCommand}s
 * to handle a given 
 * {@link puremvc.Notification Notification} 
 * when notified by the
 * {@link puremvc.View View}.
 * - Calling the command's execute method, passing in the 
 * {@link puremvc.Notification Notification}.
 *
 * Your application must register 
 * {@link puremvc.SimpleCommand SimpleCommand}s
 * or {@link puremvc.MacroCommand MacroCommand}s 
 * with the Controller.
 *
 * The simplest way is to subclass 
 * {@link puremvc.Facade Facade},
 * and use its 
 * {@link puremvc.Facade#initializeController initializeController} 
 * method to add your registrations.
 *
 * @constructor
 * This Controller implementation is a Multiton, so you should not call the 
 * constructor directly, but instead call the static #getInstance factory method, 
 * passing the unique key for this instance to it.
 * @param {string} key
 * @throws {Error}
 *  If instance for this Multiton key has already been constructed
]]
local View = import('.View')
local Observer = import('..patterns.observer.Observer')
local Controller = class('Controller')

function Controller:ctor(key)
	if Controller.instanceMap[key] ~= nil then
		error(Controller.MULTITON_MSG)
	end
	self.multitonKey = key	
	Controller.instanceMap[self.multitonKey] = self
	self.commandMap = {}	
	self:initializeController()
end
--[[
 * @protected
 * 
 * Initialize the multiton Controller instance.
 *
 * Called automatically by the constructor.
 *
 * Note that if you are using a subclass of View
 * in your application, you should *also* subclass Controller
 * and override the initializeController method in the
 * following way.
 * 
 *     MyController.prototype.initializeController= function ()
 *     {
 *         this.view= MyView.getInstance(this.multitonKey);
 *     };
 * 
 * @return {void}
]]
function Controller:initializeController()
	self.view = View.getInstance(self.multitonKey);
end
--[[
 * The Controllers multiton factory method. 
 * Note that this method will return null if supplied a null 
 * or undefined multiton key. 
 *
 * @param {string} key
 *  A Controller's multiton key
 * @return {puremvc.Controller}
 *  the Multiton instance of Controller
]]
function Controller.getInstance(key)
	if nil == key then
		return nil
	end
	if(nil == Controller.instanceMap[key]) then
		return Controller.new(key)
	else
		return Controller.instanceMap[key]
	end
end
--[[
 * If a SimpleCommand or MacroCommand has previously been registered to handle
 * the given Notification then it is executed.
 *
 * @param {puremvc.Notification} note
 * @return {void}
]]
function Controller:executeCommand(note)
	local commandClassRef = self.commandMap[note:getName()]
	if(commandClassRef == nil) then
		return
	end
	local commandInstance = commandClassRef.new()
	commandInstance:initializeNotifier(self.multitonKey)
	commandInstance:execute(note)
end
--[[
 * Register a particular SimpleCommand or MacroCommand class as the handler for 
 * a particular Notification.
 *
 * If an command already been registered to handle Notifications with this name, 
 * it is no longer used, the new command is used instead.
 *
 * The Observer for the new command is only created if this the irst time a
 * command has been regisered for this Notification name.
 *
 * @param {string} notificationName
 *  the name of the Notification
 * @param {Function} commandClassRef
 *  a command constructor
 * @return {void}
]]
function Controller:registerCommand(notificationName, commandClassRef)
	if(self.commandMap[notificationName] == nil) then
		self.view:registerObserver(notificationName, Observer.new(self.executeCommand, self));
	end
	self.commandMap[notificationName] = commandClassRef
end
--[[
 * Check if a command is registered for a given Notification
 *
 * @param {string} notificationName
 * @return {boolean}
 *  whether a Command is currently registered for the given notificationName.
]]
function Controller:hasCommand(notificationName)
	return self.commandMap[notificationName] ~= nil
end
--[[
 * Remove a previously registered command to
 * {@link puremvc.Notification Notification}
 * mapping.
 *
 * @param {string} notificationName
 *  the name of the Notification to remove the command mapping for
 * @return {void}
]]
function Controller:removeCommand(notificationName)
	if self:hasCommand(notificationName) then
		self.view:removeObserver(notificationName, self)
		self.commandMap[notificationName] = nil
	end
end
--[[
 * @static
 * Remove a Controller instance.
 *
 * @param {string} key 
 *  multitonKey of Controller instance to remove
 * @return {void}
]]
function Controller.removeController(key)
	Controller.instanceMap[key] = nil
end
--[[
 * Multiton key to Controller instance mappings
 * 
 * @static
 * @protected
 * @type {Object}
]]
Controller.instanceMap= {}
--[[
 * @ignore
 * 
 * Message constants
 * @static
 * @protected
 * @type {string}
]]
Controller.MULTITON_MSG= "controller key for this Multiton key already constructed"

return Controller