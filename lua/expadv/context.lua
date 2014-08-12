/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Create A Context object
   --- */

EXPADV.RootContext = { __deph = 0 }

EXPADV.RootContext.__index = EXPADV.RootContext

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: A few things that we need local.
   --- */

pcall = pcall
setmetatable = setmetatable

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Now we need a way to build this object
   --- */

-- Builds a new context from a compilers instance.
function EXPADV.BuildNewContext( Instance, Player, Entity ) -- Table, Player, Entity
	local Context = setmetatable( { player = Player, entity = Entity, Deph = 0, Online = false }, EXPADV.RootContext )

	Context.Trigger = { }
	Context.Changed = { }

	Context.Memory = { }
	Context.Delta = { }

	Context.Data = { }
	Context.Definitions = { }
	
	Context.Cells = Instance.Cells or { }
	Context.Strings = Instance.Strings or { }
	Context.Instructions = Instance.VMInstructions or { }
	Context.Enviroment = Instance.Enviroment or error( "No safe guard.", 0 )
	
	Context.Status = { }
	Context.Status.Bench = 0
	Context.Status.TickQuota = 0
	Context.Status.QuotaCount = 0
	Context.Status.AverageQuota = 0

	return Context
end

-- Pushes the contexts memory upwards.
function EXPADV.RootContext:Push( Trace, Cells ) -- Table, Table
	if self.Deph > 50 then self:Throw( Trace, "stack", "stack overflow" ) end

	local Memory = {
		__index = self.Memory, -- function( Table, Key ) return Cells[Key] and rawget( Table, Key ) or self.Memory[Key] end,
		__newindex = function( Table, Key, Value ) if Cells[Key] then rawset( Table, Key, Value ) else rawset(self.Memory, Key, Value )  end end,
	}

	local Delta = {
		__index = self.Delta, -- function( Table, Key ) return Cells[Key] and rawget( Table, Key ) or self.Memory[Key] end,
		__newindex = function( Table, Key, Value ) if Cells[Key] then rawset( Table, Key, Value ) else rawset(self.Delta, Key, Value )  end end,
	}

	local Changed = {
		__index = self.Changed, -- function( Table, Key ) return Cells[Key] and rawget( Table, Key ) or self.Memory[Key] end,
		__newindex = function( Table, Key, Value ) if Cells[Key] then rawset( Table, Key, Value ) else rawset(self.Changed, Key, Value ) end end,
	}

	return setmetatable( {
		Data = self.Data,
		Deph = self.Deph + 1,

		Definitions = self.Definitions,
		Cells = self.Cells,
		Strings = self.Strings,
		Instructions = self.Instructions,
		Enviroment = self.Enviroment,
		Status = self.Status,

		Memory = setmetatable( Memory, Memory ),
		Delta = setmetatable( Delta, Delta ),
		Changed = setmetatable( Changed, Changed ),

		player = self.player,
		entity = self.entity,
	}, EXPADV.RootContext )
end

local SysTime = SysTime

local function debug_hook( )
	local Time = SysTime( )

	if !EXPADV.EXECUTOR then
		return debug.sethook( )
	else
		local Context = EXPADV.EXECUTOR
		local TickQuota = Context.Status.TickQuota + (Time - Context.Status.Bench)
		Context.Status.TickQuota = TickQuota

		if TickQuota > expadv_tickquota then
			debug.sethook( )
			error( { Trace = {0,0}, Quota = true, Msg = Message, Context = Context }, 0 )
		end

		Context.Status.Bench = SysTime( )
	end
	
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Executeion
   --- */

local cv_expadv_luahook   = CreateConVar( "expadv_quota_hook", "500", {FCVAR_REPLICATED} )
   
EXPADV.Updates = { }

-- Should be called before executing.
function EXPADV.RootContext:PreExecute( )
	EXPADV.EXECUTOR = self
	self.Status.Bench = SysTime( )

	debug.sethook( debug_hook, "l", cv_expadv_luahook:GetInt( ) )
end

-- Should be called after executing.
function EXPADV.RootContext:PostExecute( )
	debug.sethook( )
	
	EXPADV.EXECUTOR = nil
	self.Definitions = { }
end

-- Safely execute a function on this context.
function EXPADV.RootContext:Execute( Location, Operation, ... ) -- String, Function, ...
	self:PreExecute( )

	local Ok, Result = pcall( Operation, ... )

	local TimeMrk = SysTime( )

	self:PostExecute( )
	
	if !Ok and isstring( Result ) then
		return self:Handel( "LuaError", Result )

	elseif Ok or Result.Exit then

		local TickQuota = self.Status.TickQuota + (TimeMrk - self.Status.Bench)
		
		self.Status.TickQuota = TickQuota

		if TickQuota > expadv_tickquota then
			return self:Handel( "HitQuota", Result )
		elseif self.Status.QuotaCount + TickQuota - expadv_softquota > expadv_hardquota then
			return self:Handel( "HitHardQuota", Result )
		end

		EXPADV.Updates[self] = true

		return true, Result

	elseif Result.Quota then
		return self:Handel( "HitQuota", Result )
	elseif Result.Script then
		return self:Handel( "ScriptError", Result )
	elseif Result.Exception then
		return self:Handel( "Exception", Result )
	end

	return false
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Breakouts
   --- */

-- Exits the currently executing code.
function EXPADV.RootContext:Exit( )
	error( { Exit = true, Context = self }, 0 )
end

-- Throws an exception
function EXPADV.RootContext:Throw( Trace, Name, Message ) -- Table, String, String
	error( { Trace = Trace, Exception = Name, Msg = Message, Context = self }, 0 )
end

-- Throws a script error, and shuts down the context.
function EXPADV.RootContext:ScriptError( Trace, Message ) -- Table, String
	error( { Trace = Trace, Script = true, Msg = Message, Context = self }, 0 )
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Context registery.
   --- */

-- Runs the root execution of the code.
function EXPADV.RootContext:StartUp( Execution ) -- Function
	self:Handel( "StartUp" )
	self.Online = true
	return self:Execute( "root", Execution, self )
end

-- Shuts down the context and execution.
function EXPADV.RootContext:ShutDown( )
	if !self.Online then return end

	self.Online = false
	self:Handel( "ShutDown" )
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Context Events.
   --- */

-- Calls A context based hook, with passthrough to main hook system.
function EXPADV.RootContext:Handel( Name, ... )
	local Hook = self["On" .. Name]
		
	if Hook then
		local Results = { Hook( self, ... ) }
		if Results[1] ~= nil then return unpack( ... ) end
	end

	return EXPADV.CallHook( Name, self, ... )
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Context registery.
--- */
   
local Registery = { }

EXPADV.CONTEXT_REGISTERY = Registery

function EXPADV.RegisterContext( Context )
	Registery[Context] = Context
	Context:Handel( "RegisterContext" )
end

function EXPADV.UnregisterContext( Context )
	Registery[Context] = nil
	Context:Handel( "UnregisterContext" )
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Context Updating.
--- */

local LastUpdated -- Means we dont need a zillion pcalls

local function CheckUpdates( )
	for Context, _ in pairs( EXPADV.Updates ) do
		LastUpdated = Context
		Context:Handel( "Update" )
	end
	
	EXPADV.Updates = { }
end

hook.Add( "Tick", "ExpAdv2.Update", function( )
	local Ok, Msg = pcall( CheckUpdates )
	
	if !Ok and LastUpdated then
		LastUpdated:Handel( "LuaError", Msg )
	end
	
	LastUpdated = nil
end )

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Reloading.
--- */

hook.Add( "ExpAdv2.UnloadCore", "expadv.context", function( )
	for Context, _ in pairs( Registery ) do
		Context:ShutDown( )
	end
end )