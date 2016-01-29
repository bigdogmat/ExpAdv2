AddCSLuaFile()

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Net Strings
   --- */

if SERVER then
	util.AddNetworkString("expadv.loaded")
	util.AddNetworkString("expadv.request")
	util.AddNetworkString("expadv.upload")
	util.AddNetworkString("expadv.cl_loaded")
	util.AddNetworkString("expadv.open")
	util.AddNetworkString("expadv.download")
	util.AddNetworkString( "expadv.config" )
	util.AddNetworkString( "expadv.notify" )
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Util functions
   --- */

function writeCompressedString(string)
	string = util.Compress(string)
	net.WriteUInt(#string, 16)
	net.WriteData(string, #string)
end

function readCompressedString()
	local size = net.ReadUInt(16)
	local string = net.ReadData(size)
	return util.Decompress(string)
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Sending Code -> Client -> Server
   --- */

if SERVER then
	function EXPADV.RequestCode(player, entity)
		net.Start("expadv.request")
			net.WriteUInt(entity:EntIndex(), 16)
		net.Send(player)
	end

	net.Receive( "expadv.upload", function(len, player)
		local entity = Entity(net.ReadUInt(16))

		local script = readCompressedString()
		local name = net.ReadString()

		if IsValid(entity) and entity.ExpAdv then
			if entity.ReceiveScript then
				entity:ReceiveScript(script, name)
			end
		end -- TODO ^ That function!
	end)

elseif CLIENT then
	net.Receive( "expadv.request", function()
		local eid = net.ReadUInt(16)
		local entity = Entity(eid)

		local script = EXPADV.Editor.GetCode()
		if !script or script == "" then return end

		local editor = EXPADV.Editor.GetInstance( )
		local name = editor:GetName()

		net.Start("expadv.upload")
			net.WriteUInt(eid, 16)
			writeCompressedString(script)
			net.WriteString(name)
		net.SendToServer()

		if IsValid(entity) then
			editor.GateTabs[entity] = editor.TabHolder:GetActiveTab()
		end
	end )
end

/* --- --------------------------------------------------------------------------------
	@: Server -> Client
   --- */

if SERVER then
	function EXPADV.SendToClient(target, entity, script, owner)
		net.Start("expadv.download")
			net.WriteUInt(entity:EntIndex(), 16)
			writeCompressedString(script)
			net.WriteEntity(owner)

		if target then
			net.Send(target)
		else
			net.Broadcast()
		end
	end
elseif CLIENT then
	net.Receive( "expadv.download", function(len)
		local entity = Entity(net.ReadUInt(16)) 
		local script = readCompressedString()
		local owner = net.ReadEntity()

		if IsValid(entity) and entity.ExpAdv then
			if entity.ReceiveScript then
				entity:ReceiveScript(script, owner)
			end
		end
	end)
end

/* --- --------------------------------------------------------------------------------
	@: Server -> Editor
   --- */

if SERVER then
	function EXPADV.SendToEditor(target, entity)
		net.Start("expadv.open")
			net.WriteUInt(entity:EntIndex(), 16)
		net.Send(target)
	end
elseif CLIENT then
	net.Receive( "expadv.open", function(len)
		local eid = net.ReadUInt(16)
		local entity = Entity(eid)

		if IsValid(entity) and entity.ExpAdv then
			local script = entity.root

			if script and script ~= "" then
				local editor = EXPADV.Editor.GetInstance()
				local tab = editor.GateTabs[entity]

				local name = "generic"
				if entity.GetGateName then
					name = entity:GetGateName()
				end

				if !IsValid( tab ) then
					editor:NewTab(script, nil, name)
					tab = editor.TabHolder:GetActiveTab()
					tab.Entity = entity
					editor.GateTabs[entity] = tab
				else
					editor.TabHolder:SetActiveTab(tab)
					tab:GetPanel( ):SetCode(script)
				end

				editor:SetVisible(true)
				editor:MakePopup()
			end
		end
	end)
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Client has loaded
   --- */

if SERVER then
	net.Receive( "expadv.cl_loaded", function(len, player)
		local entity = Entity(net.ReadUInt(16))

		if IsValid(entity) and entity.ExpAdv then
			EXPADV.CallHook("ClientLoaded", entity, player)
			
			if entity.OnClientLoaded then
				entity:OnClientLoaded(player)
			end
		end
	end)
elseif CLIENT then
	function EXPADV.SendCodeLoaded(entity)
		net.Start("expadv.cl_loaded")
			net.WriteUInt(entity:EntIndex(), 16)
		net.SendToServer()
	end
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Sending Config
   --- */

if SERVER then
	function EXPADV.SendConfig(target, init)
		net.Start("expadv.config")
			net.WriteBit(init)
			
			local seralized = EXPADV.von.serialize(EXPADV.Config)
			writeCompressedString(seralized)

			--net.WriteTable(EXPADV.Config)

		if target then
			net.Send(target)
		else
			net.Broadcast()
		end

	end
elseif CLIENT then
	net.Receive( "expadv.config", function(len)
		local init = net.ReadBit() == 1

		local seralized = readCompressedString()
		if !seralized then print("SERALIZING NIL?") end
		EXPADV.Config = EXPADV.von.deserialize(seralized)

		--EXPADV.Config = net.ReadTable()

		if init then EXPADV.LoadCore( ) end
	end)
end

/* --- --------------------------------------------------------------------------------
	@: Notifi
   --- */

if SERVER then
	function EXPADV.Notifi( target, message, type, duration )
		if !message or message == "" then return end

		net.Start("expadv.notify")
			net.WriteString( message )
			net.WriteUInt( type or 0, 8 )
			net.WriteFloat( duration )
		
		if target then
			net.Send(target)
		else
			net.Broadcast()
		end
	end

	net.Receive( "expadv.notify", function( )
		local player = net.ReadEntity()
		local message = net.ReadString()
		local type = net.ReadUInt(8)
		local duration = net.ReadFloat()

		if !message or message == "" then return end
		
		if IsValid(player) then
			EXPADV.Notifi( player ,message, type, duration )
		end
	end)
elseif CLIENT then
	function EXPADV.Notifi( target, message, type, duration )
		if !IsValid(target) then return end
		
		if !message or message == "" then return end

		if target == LocalPlayer() then
			GAMEMODE:AddNotify(message, type, duration)
			MsgN(message)
		else
			net.Start("expadv.notify")
				net.WriteEntity(target)
				net.WriteString(message)
				net.WriteUInt(type or 0, 8)
				net.WriteFloat(duration)
			net.SendToServer()
		end
	end

	net.Receive( "expadv.notify", function()
		local message = net.ReadString()
		local type = net.ReadUInt(8)
		local duration = net.ReadFloat()

		if !message or message == "" then return end

		GAMEMODE:AddNotify(message, type, duration)
		MsgN(message)
	end)
end
