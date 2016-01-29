/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
	@: Client
   --- */

include( "shared.lua" )

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
    @: Utility func
   --- */

local function Shorten( Num )
    if Num < 1000 then return math.ceil(Num) end
    if Num < 1000000 then return math.Round(Num / 1000, 3) .. "k" end
    if Num < 1000000000 then return math.Round(Num / 1000000, 3) .. "m" end
    return math.Round(Num / 1000000000, 3) .. "b" -- Lets hope we never reach the billions :D
end

EXPADV.Shorten = Shorten

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
    @: VARS
   --- */

local Rot = 0
local Mult = 1.25
local TextColor = Color( 0, 0, 0 )

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
    @: Font
   --- */

surface.CreateFont( "ExpAdv_OverlayFont", {
        font = "Default",
        size = 10 * Mult,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
} )

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
    @: Derma Overlay
    @: Images - Omicron
   --- */

local xPos, yPos

local function drawBG(sv, state)
    surface.SetDrawColor(Color(255,255,255,255))

    if sv and state >= EXPADV_STATE_CRASHED then
        surface.SetMaterial( Material( "omicron/overlay_serverred.png" ) )
        surface.DrawTexturedRect( xPos, yPos, 200*Mult, 100 * Mult )
    elseif sv and state >= EXPADV_STATE_ONLINE then
        surface.SetMaterial( Material( "omicron/overlay_servergreen.png" ) )
        surface.DrawTexturedRect( xPos, yPos, 200*Mult, 100 * Mult )
    elseif !sv and state >= EXPADV_STATE_CRASHED then
        surface.SetMaterial( Material( "omicron/overlay_clientred.png" ) )
        surface.DrawTexturedRect( xPos, yPos, 200*Mult, 100 * Mult )
    elseif !sv and state >= EXPADV_STATE_ONLINE then
        surface.SetMaterial( Material( "omicron/overlay_clientgreen.png" ) )
        surface.DrawTexturedRect( xPos, yPos, 200*Mult, 100 * Mult )
    end
end

local function drawHeader(sv, x, y, w, h)
    surface.SetTextColor(Color(0,0,0,255))

    surface.SetFont("ExpAdv_OverlayFont")
    local tw, th = surface.GetTextSize(sv and "Server" or "Client")

    local tx = x + ((w*0.5)-(tw*0.5))
    surface.SetTextPos(tx, y + 2)
    surface.DrawText(sv and "Server" or "Client")

    surface.SetDrawColor(Color(0,0,0,255))
    surface.DrawLine(tx - 2, y + th + 4, tx + tw + 2, y + th + 4)
end

local function drawLoading(state, loaded, x, y, w, h)
    if state ~= EXPADV_STATE_COMPILE then
        if loaded > 0 then return false end
    end

    surface.SetDrawColor(Color(255,255,255,250))
    surface.SetMaterial( Material("omicron/lemongear.png") )
    surface.DrawTexturedRectRotated(x + (w*0.5), y + (h*0.5), 45*Mult, 45*Mult, Rot)

    local _x, _y = x + (w*0.125), y + (h*0.5) - 5
    local _w, _h = w*0.75, 10*Mult

    surface.SetDrawColor(Color(0,0,0,150))
    surface.DrawRect(_x, _y, _w, _h)

    surface.SetDrawColor(Color(0,255,0,150))
    surface.DrawRect(_x + 2, _y + 2, (_w - 4) * (loaded/100), _h - 4)

    surface.SetTextColor(Color(255,255,255,255))
    surface.SetFont("ExpAdv_OverlayFont")
    local tw, th = surface.GetTextSize("Loading")
    surface.SetTextPos(x + ((w*0.5)-(tw*0.5)), y + ((h*0.5)-(th*0.5)))
    surface.DrawText("Loading")

    return true
end

local function drawCPU(tick, soft, x, y, w, h)
    local hardtext = (soft / expadv_hardquota > 0.33) and "(+" .. tostring(math.Round(soft / expadv_hardquota * 100)) .. "%)" or ""
    local str = string.format("%s us, %i%% %s", Shorten(tick), tick / expadv_softquota * 100, hardtext)

    surface.SetTextColor(Color(0,0,0,255))
    surface.SetFont("ExpAdv_OverlayFont")
    local tw, th = surface.GetTextSize(str)
    surface.SetTextPos(x + ((w*0.5)-(tw*0.5)), y + ((h*0.5)-(th*0.5)) - (8*Mult))
    surface.DrawText(str)
end

local function drawAverage(ave, x, y, w, h)
    local str = string.format("Average %s us", Shorten(ave))

    surface.SetTextColor(Color(0,0,0,255))
    surface.SetFont("ExpAdv_OverlayFont")
    local tw, th = surface.GetTextSize(str)
    surface.SetTextPos(x + ((w*0.5)-(tw*0.5)), y + ((h*0.5)-(th*0.5)) - (Mult))
    surface.DrawText(str)
end

local function drawBar(tick, soft, x, y, w, h)
    local bw, bh = w*0.75, 10*Mult
    local bx, by = x + (w*0.125), y + h - bh - (10*Mult)
    local sw = bw * 0.7
    local qw = sw * math.min(tick / expadv_softquota, 1) + (bw - sw) * (soft / expadv_hardquota)

    surface.SetDrawColor( Color(153,255,51,255) )
    surface.DrawRect(bx, by, sw, bh)

    surface.SetDrawColor(Color(170,0,0,255))
    surface.DrawRect(bx + sw, by, bw - sw, bh)

    surface.SetDrawColor(Color(51,51,0,255))
    surface.DrawRect(bx, by, qw, bh)

    surface.SetDrawColor(Color(0,0,0,255))
    surface.DrawLine(bx, by, bx + bw, by)
    surface.DrawLine(bx, by + bh - 1, bx + bw, by + bh - 1)
    surface.DrawLine(bx, by, bx, by + bh - 1)
    surface.DrawLine(bx + bw, by, bx + bw, by + bh - 1)
end

local function drawTile(ent, sv)
    local tick          = (sv and ent:GetTickQuota() or ent.ClientTickQuota) or 0
    local soft          = (sv and ent:GetTickQuota( ) or ent.ClientTickQuota) or 0
    local average       = (sv and ent:GetAverage( ) or ent.ClientAverage) or 0
    local state         = (sv and ent:GetServerState() or ent:GetClientState()) or 0
    local loaded        = (sv and ent:GetServerLoaded( ) or ent:GetClientLoaded( )) or 0
    
    if soft > 0 then soft = (soft / expadv_hardquota) * 100 else soft = 0 end

    local w = 100*Mult
    local x = sv and xPos + w or xPos
    local y, h = yPos + (20*Mult), 55*Mult

    local loading = drawLoading(state, loaded, x, y, w, h)

    if !loading then
        drawBG(sv, state, x, y)
    end

    drawHeader(sv, x, y, w, h)

    if !loading then
        drawCPU(tick, soft, x, y, w, h)
        drawAverage(average, x, y, w, h)
        drawBar(tick, soft, x, y, w, h)
    end
end

local function PaintOverlay(ent)
    surface.SetMaterial( Material( "omicron/ea2_overlay_bg.png" ) )
    surface.SetDrawColor( Color( 255, 255, 255, 200 ) )
    surface.DrawTexturedRect( xPos, yPos, 200 * Mult, 100 * Mult )

    draw.SimpleText( ent:GetPlayerName( ), "ExpAdv_OverlayFont", xPos + (100*Mult), yPos + (10*Mult), TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    local Name = ent:GetGateName( )
    if !Name or Name == "" then Name = "LemonGate #2" end
    draw.SimpleText( "Current Script: " .. Name, "ExpAdv_OverlayFont", xPos + (5*Mult), yPos + (92*Mult), TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    drawTile(ent, false)
    drawTile(ent, true)
end

hook.Add( "HUDPaint", "Expadv.overlay", function( )
    local ent = LocalPlayer():GetEyeTrace( ).Entity

    if !IsValid(ent) or !ent.ExpAdv then return end

    if ( EyePos():Distance( ent:GetPos() ) > 156 ) then return end

    local DrawPos = ent:GetOverlayPos( ):ToScreen( )

    xPos, yPos = DrawPos.x, DrawPos.y
    
    PaintOverlay(ent)

    Rot = Rot + 1
end )

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
    @: Rendering Model
   --- */

function ENT:Draw( )
    self:DrawModel()

    local cl_state = self:GetClientState( )
    
    if cl_state == EXPADV_STATE_COMPILE then
        self:DrawPulse(0,0,1)
    elseif cl_state == EXPADV_STATE_BURNED or state == EXPADV_STATE_CRASHED then
        self:DrawPulse(1,0,0)
    elseif cl_state == EXPADV_STATE_ALERT then
        self:DrawPulse(0,1,0)
    end

    local sv_state = self:GetServerState( )
    
    if cl_state ~= EXPADV_STATE_ONLINE then
        if sv_state == EXPADV_STATE_COMPILE then
            self:DrawPulse(0,0,1)
        elseif sv_state == EXPADV_STATE_BURNED or state == EXPADV_STATE_CRASHED then
            self:DrawPulse(1,0,0)
        elseif sv_state == EXPADV_STATE_ALERT then
            self:DrawPulse(0,1,0)
        end
    end
end

function ENT:GetOverlayPos( )
    return self:GetPos( )
end

/* --- ----------------------------------------------------------------------------------------------------------------------------------------------
    @: DrawPulse
   --- */

function ENT:DrawPulse(red, green, blue)
    local radius, width = (self.radius or 1) + 0.1, Lerp(self.radius or 0, 5, 15)
    if radius > 150 then radius = 0 end
    self.radius = radius

    local pos = self:LocalToWorld(self:OBBCenter())
    if self:GetModel( ) == "models/lemongate/lemongate.mdl" then
        pos = self:GetAttachment(self:LookupAttachment("fan_attch")).Pos
    end

    local p, a, r = pos, self:GetAngles(), 0.1

    render.SetStencilEnable( true )
    render.SetStencilWriteMask( 3 )
    render.SetStencilTestMask( 3 )
    render.ClearStencil( )

    render.SetStencilReferenceValue(1)
    render.SetStencilPassOperation( STENCIL_REPLACE )
    render.SetStencilFailOperation( STENCIL_REPLACE )
    render.SetStencilZFailOperation( STENCIL_REPLACE )

    render.SetStencilCompareFunction(STENCIL_NEVER)

    cam.Start3D2D(p, a, r)
        for i = 0, 4 do
            surface.SetDrawColor(Color(0, 0, 255, 255))
            surface.DrawTexturedRectRotated(0, 0, (radius) * 2, (radius) * 2, i * 45)
        end
    cam.End3D2D()

    render.SetStencilReferenceValue(1)
    render.SetStencilPassOperation( STENCIL_ZERO )
    render.SetStencilFailOperation( STENCIL_ZERO )
    render.SetStencilZFailOperation( STENCIL_ZERO )

    render.SetStencilCompareFunction(STENCIL_NEVER)

    cam.Start3D2D(p, a, r)
        for i = 0, 4 do
            surface.SetDrawColor(Color(0, 0, 255, 255))
            surface.DrawTexturedRectRotated(0, 0, (radius - width) * 2, (radius - width) * 2, i * 45)
        end
    cam.End3D2D()

    render.SetStencilCompareFunction(STENCIL_EQUAL)

    render.SetColorModulation(red, green, blue)
    self:DrawModel()
    render.SetColorModulation(1,1,1)
    render.SetStencilEnable( false )
end