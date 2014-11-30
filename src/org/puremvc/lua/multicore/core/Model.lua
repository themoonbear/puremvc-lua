--[[
 * @author PureMVC Lua Native Port by Sean 
 * @author Copyright(c) 2006-2012 Futurescale, Inc., Some rights reserved.
 * 
 * @class puremvc.Model
 *
 * A Multiton Model implementation.
 *
 * In PureMVC, the Model class provides
 * access to model objects (Proxies) by named lookup.
 *
 * The Model assumes these responsibilities:
 *
 * - Maintain a cache of {@link puremvc.Proxy Proxy}
 *   instances.
 * - Provide methods for registering, retrieving, and removing
 *   {@link puremvc.Proxy Proxy} instances.
 *
 * Your application must register 
 * {@link puremvc.Proxy Proxy} instances with the Model. 
 * Typically, you use a 
 * {@link puremvc.SimpleCommand SimpleCommand} 
 * or
 * {@link puremvc.MacroCommand MacroCommand} 
 * to create and register Proxy instances once the Facade has initialized the 
 * *Core* actors.
 *
 * This Model implementation is a Multiton, so you should not call the 
 * constructor directly, but instead call the 
 * {@link #getInstance static Multiton Factory method} 
 * @constructor
 * @param {string} key
 *  The Models multiton key
 * @throws {Error}
 *  An error is thrown if this multitons key is already in use by another instance
 ]]
local Model = class('Model')

function Model:ctor(key)
	if Model.instanceMap[key] then
 		error(Model.MULTITON_MSG)
 	end
 	self.multitonKey = key
 	Model.instanceMap[key] = self
 	self.proxyMap = {}
 	self:initializeModel()
end
--[[
 * Initialize the Model instance.
 * 
 * Called automatically by the constructor, this
 * is your opportunity to initialize the Singleton
 * instance in your subclass without overriding the
 * constructor.
 * 
 * @return void
]]
function Model:initializeModel() end
--[[
 * Model Multiton Factory method.
 * Note that this method will return null if supplied a null 
 * or undefined multiton key.
 *  
 * @param {string} key
 *  The multiton key for the Model to retrieve
 * @return {puremvc.Model}
 *  the instance for this Multiton key 
]]
function Model.getInstance(key)
	if nil == key then
		return nil
	end
	if Model.instanceMap[key] == nil then
		return Model.new(key)
	else
		return Model.instanceMap[key]		
	end
end
--[[
 * Register a Proxy with the Model
 * @param {puremvc.Proxy}
]]
function Model:registerProxy(proxy)
	proxy:initializeNotifier(self.multitonKey)
	self.proxyMap[proxy:getProxyName()] = proxy
	proxy:onRegister()
end
--[[
 * Retrieve a Proxy from the Model
 * 
 * @param {string} proxyName
 * @return {puremvc.Proxy}
 *  The Proxy instance previously registered with the provided proxyName
]]
function Model:retrieveProxy(proxyName)
	return self.proxyMap[proxyName]
end
--[[
 * Check if a Proxy is registered
 * @param {string} proxyName
 * @return {boolean}
 *  whether a Proxy is currently registered with the given proxyName.
]]
function Model:hasProxy(proxyName)
	return self.proxyMap[proxyName] ~= nil
end
--[[
 * Remove a Proxy from the Model.
 * 
 * @param {string} proxyName
 *  The name of the Proxy instance to remove
 * @return {puremvc.Proxy}
 *  The Proxy that was removed from the Model
]]
function Model:removeProxy(proxyName)
	local proxy = self.proxyMap[proxyName]
	if proxy ~= nil then
		self.proxyMap[proxyName] = nil
		proxy:onRemove()
	end
	return proxy
end
--[[
 * @static
 * Remove a Model instance.
 * 
 * @param {string} key
 * @return {void}
]]
function Model.removeModel(key)
	Model.instanceMap[key] = nil
end
--[[
 * @ignore
 * The map used by the Model to store multiton instances
 *
 * @protected
 * @static
 * @type Array
]]
Model.instanceMap = {}
--[[
 * @ignore
 * Message Constants
 * 
 * @static
 * @type {string}
]]
Model.MULTITON_MSG= "Model instance for this Multiton key already constructed!";

return Model