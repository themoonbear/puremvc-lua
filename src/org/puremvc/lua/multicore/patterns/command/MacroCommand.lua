--[[
 * @author PureMVC Lua Native Port Sean 
 * @author Copyright(c) 2006-2012 Futurescale, Inc., Some rights reserved.
 * 
 * @class puremvc.MacroCommand
 * @extends puremvc.Notifier
 * 
 * A base command implementation that executes other commands, such as
 * {@link puremvc.SimpleCommand SimpleCommand}
 * or {@link puremvc.MacroCommand MacroCommand}
 * subclasses.
 *  
 * A MacroCommand maintains an list of
 * command constructor references called *SubCommands*.
 * 
 * When #execute is called, the MacroCommand
 * instantiates and calls #execute on each of its *SubCommands* in turn.
 * Each *SubCommand* will be passed a reference to the original
 * {@link puremvc.Notification Notification} 
 * that was passed to the MacroCommands #execute method
 * 
 * Unlike {@link puremvc.SimpleCommand SimpleCommand}, 
 * your subclass should not override #execute but instead, should 
 * override the #initializeMacroCommand method, calling #addSubCommand once for 
 * each *SubCommand* to be executed.
 * 
 * If your subclass does define a constructor, be sure to call "super" like so
 * 
 *     function MyMacroCommand ()
 *     {
 *         MacroCommand.call(this);
 *     };
 * @constructor
]]
local Notifier = import('..observer.Notifier')
local MacroCommand = class('MacroCommand', Notifier)

function MacroCommand:ctor()
    MacroCommand.super.ctor(self)
    self.subCommands= {}
    self:initializeMacroCommand()
end
--[[
 * @protected
 * Initialize the MacroCommand.
 * 
 * In your subclass, override this method to 
 * initialize the MacroCommand's *SubCommand*  
 * list with command class references like 
 * this:
 * 
 *     // Initialize MyMacroCommand
 *     MyMacroCommand.prototype.initializeMacroCommand= function ()
 *     {
 *         this.addSubCommand( com.me.myapp.controller.FirstCommand );
 *         this.addSubCommand( com.me.myapp.controller.SecondCommand );
 *         this.addSubCommand( com.me.myapp.controller.ThirdCommand );
 *     };
 * 
 * Note that *SubCommand*s may be any command implementor,
 * MacroCommands or SimpleCommands are both acceptable.
 * @return {void}
]]
function MacroCommand:initializeMacroCommand() end

--[[
 * @protected
 * Add a *SubCommand*
 * 
 * The *SubCommand*s will be called in First In / First Out (FIFO) order
 * @param {Function} commandClassRef
 *  A reference to a subclassed SimpleCommand or MacroCommand constructor
]]
function MacroCommand:addSubCommand(commandClassRef)
	table.insert(self.subCommands, commandClassRef)
end

--[[
 * Execute this MacroCommands *SubCommands*
 * 
 * The *SubCommand*s will be called in First In / First Out (FIFO) order
 * @param {puremvc.Notification} note
 *  The Notification object to be passed to each *SubCommand*
]]
function MacroCommand:execute(note)
    -- SIC- TODO optimize
    while(#self.subCommands > 0) do
        local ref= table.remove(self.subCommands)
        local cmd= ref.new()
        cmd:initializeNotifier(self.multitonKey)
        cmd:execute(note)
    end
end

return MacroCommand