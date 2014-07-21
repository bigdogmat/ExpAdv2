/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Base Class
   --- */

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.PrintName       = "Expression Advanced 2"
ENT.Author          = "Rusketh"
ENT.Contact         = "WM/FacePunch"

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Context Look Up
		-- More useful clientside tbh :D
   --- */

local ContextFromEntID = { }

function EXPADV.GetEntityContext( ID )
	return ContextFromEntID[ ID ]
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: 
   --- */

function ENT:IsRunning( )
	return self.Context ~= nil and self.Context.Online
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Context Callbacks
   --- */

function ENT:OnStartUp( Context ) end

function ENT:OnShutDown( Context ) end

function ENT:OnLuaError( Context, Msg ) end

function ENT:OnScriptError( Context, Msg ) end

function ENT:OnUncatchedException( Context, Exception ) end --OnException

function ENT:OnContextUpdate( Context ) end -- OnUpdate

function ENT:DoPrint( Context, Msg ) end -- Print (TEMP)

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Context
   --- */

function ENT:GetContext( )
	return self.Context
end

function ENT:OnContextCreated( Context )
	-- For usage of derived classes only!
	-- Return true to disable context callbacks.
end

function ENT:CreateContext( Instance, Player )
	local Context = EXPADV.BuildNewContext( Instance, Player, self )

	if !self:OnContextCreated( Context ) then

		Context.OnStartUp = function( ctx ) return self:OnStartUp( ctx ) end

		Context.OnShutDown = function( ctx ) return self:OnShutDown( ctx ) end

		Context.OnLuaError = function( ctx, msg ) return self:OnLuaError( ctx, msg ) end

		Context.OnScriptError = function( ctx ) return self:OnScriptError( ctx, msg ) end

		Context.OnException = function( ctx, exc ) return self:OnUncatchedException( ctx, exc ) end
		
		Context.OnUpdate = function( ctx ) return self:OnContextUpdate( ctx ) end

		Context.Print = function( ctx, msg ) return self:DoPrint( ctx, msg ) end
	end

	ContextFromEntID[ self:EntIndex( ) ] = Context

	EXPADV.RegisterContext( Context )

	self.Context = Context

	return Context
end

function ENT:OnRemove( )
	if !self:IsRunning( ) then return end

	self.Context:ShutDown( )

	EXPADV.UnregisterContext( self.Context )
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Compiler
   --- */

function ENT:IsCompiling( )
	return self.Compiler ~= nil
end

function ENT:CompileScript( Root, Files )
	self.Compiler = EXPADV.Compile( Root, Files, CLIENT,
		function( ErMsg )
			local Cmp = self.Compiler

			self.Compiler = nil

			return self:OnCompileError( ErMsg, Cmp )
		end,

		function( Instance, Instruction )
			self.Compiler = nil -- The instance is the compiler :D
			return self:BuildInstance( Instance, Instruction )
		end )
	) -- Now we wait for the callback!
end

function ENT:OnCompileError( ErMsg, Compiler ) end

function ENT:BuildInstance( Instance, Instruction )
	
	local Native = table.concat( {
		"return function( Context )",
		"setfenv( 1, Context.Enviroment )",
		Instruction.Prepare or "",
		Instruction.Inline or "",
		"end"
	}, "\n" )

	local Compiled = CompileString( Native, "EXPADV2", false )

	Instance.NativeLog["Root"] = Native -- Debuggin purposes!

	if isstring( Compiled ) then
		return self:OnCompileError( Compiled, Instance )
	end

	local Context = self:CreateContext( Instance, self.player )
	
	-- TODO: WireLib!

	Context:StartUp( Compiled( ) )
end

function ENT:GetCompilePer( )
	if !self.Compiler then return 100 end

	return self.Compiler:PercentCompiled( )
end