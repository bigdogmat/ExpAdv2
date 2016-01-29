/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Shared Info!
   --- */

AddCSLuaFile( )

ENT.Type 			= "anim"
ENT.Base 			= "expadv_screen"
ENT.ExpAdv 			= true
ENT.Screen 			= true
ENT.ScreenDerma 	= true

if SERVER then return end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Derma:
	@: Contributions from Overv, Divran, Python, Rusketh
   --- */

local function SetParent( self, Parent )
	if Parent then
		local Prev_Parent = self.Parent
		
		if Prev_Parent and Prev_Parent._Children then
			Prev_Parent._Children[self] = nil
		end

		if !Parent._Children then Parent._Children = {} end

		Parent._Children[self] = true
	end

	self.Parent = Parent

	self._SetParent( self, Parent )
end

function ENT:CreateDermaObject( Panel, Parent )
	if isstring(Panel) then Panel = vgui.Create(Panel) end

	if !ValidPanel(Panel) then return end -- Now thats sorted :D

	if !Parent and Parent != false then Parent = self.Panel end

	Panel.Parent = Parent
	Panel:SetParent(Parent)

	if Parent then 
		if !Parent._Children then Parent._Children = {} end
		Parent._Children[Panel] = true
	end
		
	if Panel.SetParent then
		Panel._SetParent = Panel.SetParent

		Panel.SetParent = SetParent
	end
	
	if Panel.CursorPos then
		Panel._CursorPos = Panel.CursorPos

		function Panel.CursorPos(Panel)
			local X, Y = self:absolutePanelPos(Panel)
			local x, y = self:getCursorPos()
			
			X = x - X
			Y = y - Y
			
			return X,Y
		end
	end
	
	if Panel.PerformLayout then
		Panel._PerformLayout = Panel.PerformLayout

		function Panel.PerformLayout(Panel, ...)
			for _, Child in pairs( Panel:GetChildren() ) do
				if !Child.Parent then
					self:CreateDermaObject( Child, Panel )
				end
			end

			return Panel:_PerformLayout(...)
		end
	end

	if Panel.MakePopup then
		Panel._MakePopup = Panel.MakePopup

		function Panel.MakePopup(Panel)
			Panel:SetZPos(32767)
			Panel:SetMouseInputEnabled(true)
			Panel:SetKeyboardInputEnabled(true)
		end
	end

	return Panel
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Entity
   --- */

function ENT:Initialize()
	self:InitDerma()

	hook.Add( "NetworkEntityCreated", self)

	self.BaseClass.Initialize(self)
end

function ENT:InitDerma()
	if self.Panel and self.Panel:IsValid() then self.Panel:Remove() end

	self.Hovered = false

	self.Panel = self:CreateDermaObject( "DPanel" )
	self.Panel:SetPos(0,0)
	self.Panel:SetDrawBackground(false)
	self.Panel:SetPaintedManually( true )

	self.Cursor_Image = self:CreateDermaObject( "DImage" )
	self.Cursor_Image:SetImage("omicron/lemongear.png")
	self.Cursor_Image:SetSize(16, 16)
	self.Cursor_Image:SetZPos( 32767 )
	self.Cursor_Image:SetVisible(false)

	local Panel = vgui.Create( "EditablePanel" )

	hook.Add("KeyPress", self, self.OnKeyPress)
	hook.Add("KeyRelease", self, self.OnKeyRelease)
	hook.Add("GUIMousePressed", self, self.GUIMousePressed)
	hook.Add("GUIMouseReleased", self, self.GUIMouseReleased)
end

function ENT:NetworkEntityCreated(e)
	if e ~= self then return end
	self:InitDerma()
end

function ENT:OnRemove()
	self:RestoreGuiMouse()
	EXPADV.CacheRenderTarget(self.RT_Data)

	if self.Panel and self.Panel:IsValid() then self.Panel:Remove() end

	EXPADV.CacheRenderTarget(self.RT_Data)
	
	hook.Remove( "PlayerInitialSpawn", self )
	hook.Remove( "NetworkEntityCreated", self )

	if !self:IsRunning( ) then return end
	
	self.Context:ShutDown( )
end

function ENT:PostDrawScreen(_, scrRes)
	if !ValidPanel(self.Panel) or !self.GetResolution then return end

	self:checkHover( self.Panel )
	self.Panel:SetSize(self:GetResolution(512), self:GetResolution(512))
	self.Panel:SetPaintedManually( false )
	self.Panel:PaintManual()
	self.Panel:SetPaintedManually( true )

	surface.DisableClipping(true)
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: gui.MouseX/Y fixes
	@: Author: Divran
   --- */

local Fixed, __X, __Y = false

function ENT:FixGuiMouse()
	if Fixed then return end

	Fixed = true

	 __X, __Y = gui.MouseX, gui.MouseY

	gui.MouseX, gui.MouseY = function()
		return self.CursorX or 0
	end, function()
		return self.CursorY or 0
	end
end
 
function ENT:RestoreGuiMouse()
	if !Fixed then return end

	Fixed = false

	gui.MouseX, gui.MouseY = __X, __Y
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: DMenu Fixes
	@: Author: Rusketh
   --- */

local DMenu_Open = DMenu.Open

function DMenu.Open(...)
	if !Fixed then return DMenu_Open(...) end

	local MouseX, MouseY = gui.MouseX, gui.MouseY

	gui.MouseX, gui.MouseY = __X, __Y

	DMenu_Open(...)

	gui.MouseX, gui.MouseY = MouseX, MouseY
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: 3D2D vgui wrapper
	@: Author: Overv
   --- */

function ENT:getCursorPos()
	return self.CursorX or 0, self.CursorY or 0
end

function ENT:MouseX()
	return self.CursorX or 0
end

function ENT:MouseY()	
	return self.CursorY or 0
end

function ENT:absolutePanelPos( Panel )
	if !Panel or !Panel:IsValid() then return 0, 0 end

	if Panel.Parent then
		local x, y = self:absolutePanelPos( Panel.Parent )
		local xx, yy = Panel:GetPos()
		return x + xx, y + yy
	end

	return Panel:GetPos()
end
 
function ENT:pointInsidePanel( Panel, x, y )
	if !Panel or !Panel:IsValid() then return false end

	local px, py = self:absolutePanelPos( Panel )

	local sx, sy = Panel:GetSize()

	return x >= px and y >= py and x <= px + sx and y <= py + sy
end
 
function ENT:isMouseOver( Panel )
	if !self.IsAimed then return end
	
	return self:pointInsidePanel( Panel, self:getCursorPos() )
end
 
function ENT:checkHover( Panel )
	if !self.IsAimed then
		Panel.Hovered = false
		return -- Not Aimed!
	end

	Panel.Hovered = self:pointInsidePanel( Panel, self:getCursorPos() )
	
	for Child in pairs( Panel._Children or {} ) do
		if Child:IsValid() then
			self:checkHover( Child )
		else
			Panel._Children[Child] = nil
		end
	end
end
 
function ENT:postPanelEvent( Panel, event, ... )
	if !Panel:IsValid() or !self:isMouseOver( Panel ) then return false end
	
	local handled = false
	
	for Child in pairs( Panel._Children or {} ) do
		if !Child:IsValid() then
			Panel._Children[child] = nil
		elseif self:postPanelEvent( Child, event, ... ) then
			handled = true
			break
		end
	end
	
	if !handled and Panel[ event ] then
		local ok, msg = pcall( Panel[ event ], Panel, ... )
		
		if !ok then
			self:LuaError( msg )
			-- TODO: Shutdown :D
		end

		return true
	end

	return false
end
 
function ENT:KeyPress( key )
	self:checkHover( self.Panel )
	self:postPanelEvent( self.Panel, "OnMousePressed", key )
end
 
function ENT:KeyRelease( key )
	self:checkHover( self.Panel )
	self:postPanelEvent( self.Panel, "OnMouseReleased", key )
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Think - Brains :D
   --- */

function ENT:Think()
	self.BaseClass.Think(self)
 	
 	if !ValidPanel(self.Panel) then return end

 	local CursorPos = self:GetCursor( LocalPlayer() )

 	if !CursorPos then
 		self.CursorX, self.CursorY = 0, 0

 		if self.Hovered == true then self:RestoreGuiMouse() end

		self.Hovered, self.IsAimed = false, false

		return
 	end

	self.CursorX, self.CursorY = CursorPos.x, CursorPos.y

	self.Cursor_Image:SetPos(self.CursorX + 1, self.CursorY + 1)

	self.IsAimed = vgui.GetHoveredPanel( ) == nil

	if self.Hovered == false then self:FixGuiMouse() end

	self.Hovered = true
	
end

function ENT:OnKeyPress( Player, Key )
	if !self.IsAimed then return end

	if Player ~= LocalPlayer() then return end

	if Key == IN_USE then
		self:KeyPress( MOUSE_LEFT )
	end
end

function ENT:OnKeyRelease( Player, Key )
	if !self.IsAimed then return end

	if Player ~= LocalPlayer() then return end

	if Key == IN_USE then
		self:KeyRelease( MOUSE_LEFT )
	end
end

function ENT:GUIMousePressed( Key )
	if !self.IsAimed then return end

	self:KeyPress( Key )
end

function ENT:GUIMouseReleased( Key )
	if !self.IsAimed then return end

	self:KeyRelease( Key )
end

local LEFT_CLICK, RIGHT_CLICK = false, false

hook.Add("Tick", "expadv.dermascreen", function()
	local Player = LocalPlayer()

	if !IsValid(Player) then return end
	
	local ExpAdv = Player:GetEyeTrace().Entity
	
	if IsValid(ExpAdv) and ExpAdv.ExpAdv and ExpAdv.ScreenDerma then

		local LeftBtn = input.IsMouseDown( MOUSE_LEFT )

		if LeftBtn and !LEFT_CLICK then
			LEFT_CLICK = true
			ExpAdv:GUIMousePressed( MOUSE_LEFT )
		elseif !LeftBtn and LEFT_CLICK then
			LEFT_CLICK = false
			ExpAdv:GUIMouseReleased( MOUSE_LEFT )
		end

		local RightBtn = input.IsMouseDown( MOUSE_LEFT )

		if RightBtn and !RIGHT_CLICK then
			RIGHT_CLICK = true
			ExpAdv:GUIMousePressed( MOUSE_RIGHT )
		elseif !RightBtn and RIGHT_CLICK then
			RIGHT_CLICK = false
			ExpAdv:GUIMouseReleased( MOUSE_RIGHT )
		end
	end
end )

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: OnRemove
   --- */

function ENT:OnRemove( )
	hook.Remove("KeyPress", self)
	hook.Remove("KeyRelease", self)
	hook.Remove("GUIMousePressed", self)
	hook.Remove("GUIMouseReleased", self)
	hook.Remove( "NetworkEntityCreated", self )
	
	if self.Panel then self.Panel:Remove() end

	return self.BaseClass.BaseClass.OnRemove( self )
end