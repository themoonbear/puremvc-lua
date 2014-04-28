--[[
 * @author PureMVC Lua Native Port by Sean 
 * @author Copyright(c) 2006-2012 Futurescale, Inc., Some rights reserved.
 * 
 * @class puremvc.Proxy
 * @extends puremvc.Notifier
 *
 * A base Proxy implementation. 
 * 
 * In PureMVC, Proxy classes are used to manage parts of the application's data 
 * model.
 * 
 * A Proxy might simply manage a reference to a local data object, in which case 
 * interacting with it might involve setting and getting of its data in 
 * synchronous fashion.
 * 
 * Proxy classes are also used to encapsulate the application's interaction with 
 * remote services to save or retrieve data, in which case, we adopt an 
 * asyncronous idiom; setting data (or calling a method) on the Proxy and 
 * listening for a 
 * {@link puremvc.Notification Notification} 
 * to be sent  when the Proxy has retrieved the data from the service. 
 * 
 * 
 * @param {string} [proxyName]
 *  The Proxy's name. If none is provided, the Proxy will use its constructors
 *  NAME property.
 * @param {Object} [data]
 *  The Proxy's data object
 * @constructor
]]
local Notifier = import('..observer.Notifier')
local Proxy = class('Proxy', Notifier)

function Proxy:ctor(proxyName, data)
	self.proxyName = proxyName or Proxy.NAME
	if data ~= nil then
		self:setData(data)
	end
end

Proxy.NAME = "Proxy"
--[[
 * Get the Proxy's name.
 *
 * @return {string}
]]
function Proxy:getProxyName()
	return self.proxyName
end
--[[
 * Set the Proxy's data object
 *
 * @param {Object} data
 * @return {void}
]]
function Proxy:setData(data)
	self.data = data
end
--[[
 * Get the Proxy's data object
 *
 * @return {Object}
]]
function Proxy:getData()
    return self.data
end
--[[
 * Called by the {@link puremvc.Model Model} when
 * the Proxy is registered.
 *
 * @return {void}
]]
function Proxy:onRegister()
end
--[[
 * Called by the {@link puremvc.Model Model} when
 * the Proxy is removed.
 * 
 * @return {void}
]]
function Proxy:onRemove()
end

return Proxy