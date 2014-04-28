require("lfs")
local testPath = lfs.currentdir()
local srcPath = testPath:gsub('test', 'src')
package.path = package.path .. ';' .. testPath .. '\\?.lua'
package.path = package.path .. ';' .. srcPath .. '\\?.lua'
require('init')
require('should')
import(pm.PACKAGE_NAME .. '.patterns.proxy.ProxyTest')
import(pm.PACKAGE_NAME .. '.patterns.observer.NotifierTest')
import(pm.PACKAGE_NAME .. '.patterns.observer.NotificationTest')
import(pm.PACKAGE_NAME .. '.patterns.mediator.MediatorTest')
import(pm.PACKAGE_NAME .. '.patterns.facade.FacadeTest')
import(pm.PACKAGE_NAME .. '.patterns.command.MacroCommandTest')
