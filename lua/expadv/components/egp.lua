if !WireLib or !EGP then return end

/*==============================================================================================
	Section: API Hooks
==============================================================================================*/
local Component = EXPADV.AddComponent( "egp", true )

Component.Author = "Rusketh"
Component.Description = "Adds wirelink methods for use with the wire egp."

function Component:OnRegisterContext( Context )
	Context.prf = 0
	Context.Data.EGP = { }
end

function Component:OnUpdateContext( Context )
	Context.prf = 0

	for k,v in pairs( Context.Data.EGP ) do 
		if IsValid( k ) and v == true then 
			EGP:SendQueueItem( Context.player )
			-- EGP:StartQueueTimer( Context.player )
			Context.Data.EGP[k] = nil 
		end 
		Context.Data.EGP[k] = nil
	end 
end

EXPADV.ServerOperators()

/*==============================================================================================
	Section: Frames
==============================================================================================*/

Component:AddPreparedFunction( "egpSaveFrame", "wl:s", "", [[
if $EGP:ValidEGP( @value 1 ) then
	if @value 2 ~= "" then
		@define Bool, Frame = EGP:LoadFrame( Context.player, nil, @value 2 )
		
		if @Bool and EGP:IsDifferent( @value 1.RenderTable, @Frame ) then
			$EGP:DoAction( @value 1, Context, "SaveFrame", @value 1 )
			Context.Data.EGP[@value 1] = true
		end
	end
end]] )

Component:AddPreparedFunction( "egpLoadFrame", "wl:s", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	if @value 2 ~= "" then
		@define Bool, Frame = EGP:LoadFrame( Context.player, nil, @value 2 )
		
		if @Bool and EGP:IsDifferent( @value 1.RenderTable, @Frame ) then
			$EGP:DoAction( @value 1, Context, "LoadFrame", @value 1 )
			Context.Data.EGP[@value 1] = true
		end
	end
end]] )

/*==============================================================================================
	Section: Order
==============================================================================================*/
Component:AddPreparedFunction( "egpOrder", "wl:n,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	if @value 2 ~= @value 3 then
		@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
		if @Bool and EGP:SetOrder( @value 1, @A, @value 3 ) then
			$EGP:DoAction( @value 1, Context, "SendObject", @B )
			Context.Data.EGP[@value 1] = true
		end
	end
end]] )
		
Component:AddPreparedFunction( "egpOrder", "wl:n", "n", [[
if $EGP:ValidEGP( @value 1 ) then  
	if @value 2 ~= @value 3 then
		@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		@define result = @Bool and @A or 0
	end
end]], "@result" )	

/*==============================================================================================
	Section: Box / Outline / Rounded
==============================================================================================*/
Component:AddPreparedFunction( "egpBox", "wl:n,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["Box"], { index = @value 2, w = @value 4.x, h = @value 4.y, x = @value 3.x, y = @value 3.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]] )

Component:AddPreparedFunction( "egpBoxOutline", "wl:n,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["BoxOutline"], { index = @value 2, w = @value 4.x, h = @value 4.y, x = @value 3.x, y = @value 3.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]] )

Component:AddPreparedFunction( "egpRoundedBox", "wl:n,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["RoundedBox"], { index = @value 2, w = @value 4.x, h = @value 4.y, x = @value 3.x, y = @value 3.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]] )

Component:AddPreparedFunction( "egpRadius", "wl:n,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { radius = @value 3 } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]] )

Component:AddPreparedFunction( "egpRoundedBoxOutline", "wl:n,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["RoundedBoxOutline"], { index = @value 2, w = @value 4.x, h = @value 4.y, x = @value 3.x, y = @value 3.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]] )

/*==============================================================================================
	Section: Text
==============================================================================================*/
Component:AddPreparedFunction( "egpText", "wl:n,s,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["Text"], { index = @value 2, text = @value 3, x = @value 4.x, y = @value 4.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]] )

Component:AddPreparedFunction( "egpTextLayout", "wl:n,s,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["TextLayout"], { index = @value 2, text = @value 3, w = @value 5.x, h = @value 5.y, x = @value 4.x, y = @value 4.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]] )

Component:AddPreparedFunction( "egpSetText", "wl:n,s", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { text = @value 3 } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]] )

Component:AddPreparedFunction( "egpAlign", "wl:n,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { halign = math.Clamp(@value 3, 0, 2) } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]] )

Component:AddPreparedFunction( "egpAlign", "wl:n,n,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { valign = math.Clamp(@value 4, 0, 2), halign = math.Clamp(@value 3, 0, 2) } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]] )

Component:AddPreparedFunction( "egpFont", "wl:n,s", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool then
		local FontID = 0
		
        for K,V in ipairs( EGP.ValidFonts ) do
            if V:lower() == string.lower( @value 3 ) then
                FontID = K
                break
            end
        end
		
		if EGP:EditObject( @B, { fontid = FontID } ) then
			$EGP:DoAction( @value 1, Context, "SendObject", @B )
			Context.Data.EGP[@value 1] = true
		end
	end
end]] )

Component:AddPreparedFunction( "egpFont", "wl:n,s,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool then
		local FontID = 0
		
        for K,V in ipairs( EGP.ValidFonts ) do
            if V:lower() == string.lower( @value 3 ) then
                FontID = K
                break
            end
        end
		
		if EGP:EditObject( @B, { fontid = FontID, size = @value 4 } ) then
			$EGP:DoAction( @value 1, Context, "SendObject", @B )
			Context.Data.EGP[@value 1] = true
		end
	end
end]] )

/*==============================================================================================
	Section: Line
==============================================================================================*/
Component:AddPreparedFunction( "egpLine", "wl:n,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["Line"], { index = @value 2, x = @value 3.x, y = @value 3.y, x2 = @value 4.x, y2 = @value 4.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]] )

/*==============================================================================================
	Section: Circle
==============================================================================================*/
Component:AddPreparedFunction( "egpCircle", "wl:n,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["Circle"], { index = @value 2, x = @value 3.x, y = @value 3.y, w = @value 4.x, h = @value 4.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]] )

Component:AddPreparedFunction( "egpCircleOutline", "wl:n,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["CircleOutline"], { index = @value 2, x = @value 3.x, y = @value 3.y, w = @value 4.x, h = @value 4.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]] )

/*==============================================================================================
	Section: Triangle
==============================================================================================*/
Component:AddPreparedFunction( "egpTriangle", "wl:n,v2,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["Poly"], { index = @value 2, vertices = { { x = @value 3.x, y = @value 3.y }, { x = @value 4.x, y = @value 4.y }, { x = @value 5.x, y = @value 5.y } } }, Context.player )
	
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]])

Component:AddPreparedFunction( "egpTriangleOutline", "wl:n,v2,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["PolyOutline"], { index = @value 2, vertices = { { x = @value 3.x, y = @value 3.y }, { x = @value 4.x, y = @value 4.y }, { x = @value 5.x, y = @value 5.y } } }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]])

/*==============================================================================================
	Section: Wedge
==============================================================================================*/
Component:AddPreparedFunction( "egpWedge", "wl:n,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["Wedge"], { index = @value 2, x = @value 3.x, y = @value 3.y, w = @value 4.x, h = @value 4.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]])

Component:AddPreparedFunction( "egpWedgeOutline", "wl:n,v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["WedgeOutline"], { index = @value 2, x = @value 3.x, y = @value 3.y, w = @value 4.x, h = @value 4.y }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]])

/*==============================================================================================
	Section: Poly
==============================================================================================*/
Component:AddPreparedFunction( "egpPoly", "wl:n,...", "", [[
if $EGP:ValidEGP( @value 1 ) and #{%...} >= 3 then  
	local Vertices, I = { }, 0
	local Max = EGP.ConVars.MaxVertices:GetInt( )
	
	for _, Data in pairs( { %... } ) do
		local Var, Type = Data[1], Data[2]
		
		if I > Max then
			break
		elseif Type == "_v2" then
			I = I + 1
			Vertices[ I ] = { x = Var.x, y= Var.y }
		end
	end
	
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["Poly"], { index = @value 2, vertices = Vertices }, Context.player )
	
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]])

Component:AddPreparedFunction( "egpPolyOutline", "wl:n,...", "", [[
if $EGP:ValidEGP( @value 1 ) and #{%...} >= 3 then  
	local Vertices, I = { }, 0
	local Max = EGP.ConVars.MaxVertices:GetInt( )
	
	for _, Data in pairs( { %... } ) do
		local Var, Type = Data[1], Data[2]
		
		if I > Max then
			break
		elseif Type == "_v2" then
			I = I + 1
			Vertices[ I ] = { x = Var.x, y= Var.y }
		end
	end
	
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["PolyOutline"], { index = @value 2, vertices = Vertices }, Context.player )
	
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]])


Component:AddPreparedFunction( "egpPolyUV", "wl:n,...", "", [[
if $EGP:ValidEGP( @value 1 ) then 
	@define bool, _, object = EGP:HasObject( @value 1, @value 2 )
	if @bool and #{%...} >= 3 then 
		
		local Vertices = { } //@object.vertices or { }
		for i, v in ipairs( {%...} ) do
			if i > #@object.vertices then break end 
			Vertices[i] = { }
			Vertices[i].x = @object.vertices[i].x
			Vertices[i].y = @object.vertices[i].y
			Vertices[i].u = v[1].x
			Vertices[i].v = v[1].y
		end
		
		if EGP:EditObject( @object, { vertices = Vertices } ) then
			EGP:InsertQueue( @value 1, Context.player, EGP._SetVertex, "SetVertex", @value 2, Vertices, true )
			Context.Data.EGP[@value 1] = true
		end
	end 
end]])

/*============================================================================================================================================
	Section: Vertices
============================================================================================================================================*/

Component:AddPreparedFunction( "egpGlobalPos", "wl:n", "v", [[
if $EGP:ValidEGP( @value 1 ) then 
	@define bool, _, object = EGP:HasObject( @value 1, @value 2 )
	if @bool then
		@define hasvertices, posang = EGP:GetGlobalPos( @value 1, @value 2 )
		if @hasvertices then 
			@define result = Vector( @posang.x, @posang.y, @posang.angle )
		end
	end 
end]], "(@result or Vector(0,0,0))" )

/*==============================================================================================
	Section: 3D Tracker
==============================================================================================*/
Component:AddPreparedFunction( "egp3DTracker", "wl:n,v", "", [[ 
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, Obj = EGP:CreateObject( @value 1, EGP.Objects.Names["3DTracker"], { index = @value 2, target_x = @value 3.x, target_x = @value 3.y, target_x = @value 3.z }, Context.player )
    if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
		Context.Data.EGP[@value 1] = true
	end
end]]) -- Was v2 but made no sense

Component:AddPreparedFunction( "egpPos", "wl:n,v", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { target_x = @value 3.x, target_y = @value 3.y, target_z = @value 3.z } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]]) -- Was v2 but made no sense

/*==============================================================================================
	Section: Set Functions
==============================================================================================*/
Component:AddPreparedFunction( "egpSize", "wl:n,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { w = @value 3.x, h = @value 3.y } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])


Component:AddPreparedFunction( "egpSize", "wl:n,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { size = @value 3 } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])

Component:AddPreparedFunction( "egpPos", "wl:n,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { x = @value 3.x, y = @value 3.y } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])

----------------------------
-- Angle
----------------------------

Component:AddPreparedFunction( "egpAngle", "wl:n,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { angle = @value 3 } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])

Component:AddPreparedFunction( "egpAngle", "wl:n,v2,v2,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and @B.x and @B.y then
		
		@define Vec, Ang = $LocalToWorld(Vector(@value 4.x,@value 4.y,0), Angle(0,0,0), Vector(@value 3.x,@value 3.y,0), Angle(0,-@value 5,0))
		@define T = { x = @Vec.x, y = @Vec.y }
		
		if @B.angle then
			@T.angle = -@Ang.yaw
		end
		
		if EGP:EditObject( @B, @T ) then
			$EGP:DoAction( @value 1, Context, "SendObject", @B )
			Context.Data.EGP[@value 1] = true
		end
	end
end]])


----------------------------
-- Color
----------------------------
Component:AddPreparedFunction( "egpColor", "wl:n,c", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { r = @value 3.r, g = @value 3.g, b = @value 3.b, a = @value 3.a } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])

Component:AddPreparedFunction( "egpAlpha", "wl:n,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { a = @value 3 } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])

----------------------------
-- Material
----------------------------
Component:AddPreparedFunction( "egpMaterial", "wl:n,s", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { material = @value 3 } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])



Component:AddPreparedFunction( "egpMaterialFromScreen", "wl:n,e", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and $IsValid( @value 3 ) then
		if EGP:EditObject( @B, { material = @value 3 } ) then
			$EGP:DoAction( @value 1, Context, "SendObject", @B )
			Context.Data.EGP[@value 1] = true
		end
	end
end]])

----------------------------
-- Fidelity (number of corners for circles and wedges)
----------------------------
Component:AddPreparedFunction( "egpFidelity", "wl:n,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and EGP:EditObject( @B, { fidelity = math.Clamp(@value 3, 3, 180) } ) then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])

----------------------------
-- Parenting
----------------------------
Component:AddPreparedFunction( "egpParent", "wl:n,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, B = EGP:SetParent( @value 1, @value 2, @value 3 )
		
	if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])

-- Entity parenting (only for 3Dtracker - does nothing for any other object)
Component:AddPreparedFunction( "egpParent", "wl:n,e", "", [[
if $IsValid( @value 3 ) and $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
		
	if @Bool and @B.Is3DTracker then
		if @B.parententity ~= @value 3 then
			@B.parententity = @value 3
			$EGP:DoAction( @value 1, Context, "SendObject", @B )
			Context.Data.EGP[@value 1] = true
		end
	end
end]])

Component:AddPreparedFunction( "egpUnParent", "wl:n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, B = EGP:UnParent( @value 1, @value 2 )
		
	if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])

Component:AddPreparedFunction( "egpParentToCursor", "wl:n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, B = EGP:SetParent( @value 1, @value 2, -1 )

	if @Bool then
		$EGP:DoAction( @value 1, Context, "SendObject", @B )
		Context.Data.EGP[@value 1] = true
	end
end]])

/*==============================================================================================
	Section: Clear / Remove
==============================================================================================*/
Component:AddPreparedFunction( "egpClear", "wl:", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	$EGP:DoAction( @value 1, Context, "ClearScreen" )
	Context.Data.EGP[@value 1] = true
end]])

Component:AddPreparedFunction( "egpRemove", "wl:n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool = EGP:HasObject( @value 1, @value 2 )
	if @Bool then
		$EGP:DoAction( @value 1, Context, "RemoveObject", @value 2 )
		Context.Data.EGP[@value 1] = true
	end
end]])

-- Doesn't work
Component:AddPreparedFunction( "egpCopy", "wl:n,n", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 3 )
	if @Bool then
		@define copy = $table.Copy( @B )
		@copy.index = @value 2

		@define Bool2, Obj = EGP:CreateObject( @value 1, @B.ID, @copy, Context.player )
		if @Bool2 then
			$EGP:DoAction( @value 1, Context, "SendObject", @Obj )
			Context.Data.EGP[@value 1] = true
		end
	end
end]])

/*==============================================================================================
	Section: Screen Settings and Information
==============================================================================================*/

Component:AddPreparedFunction( "egpDrawTopLeft", "wl:b", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	$EGP:DoAction( @value 1, Context, "MoveTopLeft", @value 2 )
	Context.Data.EGP[@value 1] = true
end]])

Component:AddPreparedFunction( "egpResolution", "wl:v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define xScale = { @value 2.x, @value 3.x }
	@define yScale = { @value 2.y, @value 3.y }
	
	@define xMul = @xScale[2] - @xScale[1]
	@define yMul = @yScale[2] - @yScale[1]
	if @xMul == 0 or @yMul == 0 then error("Invalid EGP scale") end

	$EGP:DoAction( @value 1, Context, "SetScale", @xScale, @yScale )
	Context.Data.EGP[@value 1] = true
end]])

-- Might not be correct
Component:AddPreparedFunction( "egpScale", "wl:v2,v2", "", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define xScale = { @value 2.x, @value 2.y }
	@define yScale = { @value 3.x, @value 3.y }

	@define xMul = @xScale[2] - @xScale[1]
	@define yMul = @yScale[2] - @yScale[1]
	if @xMul == 0 or @yMul == 0 then error("Invalid EGP scale") end

	$EGP:DoAction( @value 1, Context, "SetScale", @xScale, @yScale)
	Context.Data.EGP[@value 1] = true
end]])

Component:AddPreparedFunction( "egpScrSize", "e", "v2", "( ($IsValid(@value 1) and @value 1:IsPlayer( )) and Vector2($EGP.ScrHW[@value 1][1], EGP.ScrHW[@value 1][2]) or Vector2(-1,-1))" )
Component:AddPreparedFunction( "egpScrH", "e", "n", "( ($IsValid(@value 1) and @value 1:IsPlayer( )) and $EGP.ScrHW[@value 1][2] or -1)" )
Component:AddPreparedFunction( "egpScrW", "e", "n", "( ($IsValid(@value 1) and @value 1:IsPlayer( )) and $EGP.ScrHW[@value 1][1] or -1)" )

/*==============================================================================================
	Section: Convars
==============================================================================================*/
Component:AddPreparedFunction( "egpCanSendUmsg", "", "b", "$EGP:CheckInterval( Context, true )" )
Component:AddPreparedFunction( "egpMaxUmsgPerSecond", "", "n", "$EGP.ConVars.MaxPerSec:GetInt()" )
Component:AddPreparedFunction( "egpMaxObjects", "", "n", "$EGP.ConVars.MaxObjects:GetInt()" )

Component:AddPreparedFunction( "egpNumObjects", "wl:", "n", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define result = #@value 1.RenderTable or 0
end]], "@result")

Component:AddPreparedFunction( "egpHasObject", "wl:n", "b", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define result = EGP:HasObject( @value 1, @value 2 )
end]], "@result")

/*==============================================================================================
	Section: Cursor
==============================================================================================*/
Component:AddPreparedFunction( "egpCursor", "wl:e", "v2", "@define V = $EGP:EGPCursor( @value 1, @value 2 )", "Vector2(@V[1],@V[2])" )

/*==============================================================================================
	Section: Get Functions
==============================================================================================*/
Component:AddPreparedFunction( "egpAngle", "wl:n", "n", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = $EGP:HasObject( @value 1, @value 2 )
	@define result = (@Bool and @B.angle) and @B.angle or -1
end]], "@result" )

Component:AddPreparedFunction( "egpFidelity", "wl:n", "n", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = EGP:HasObject( @value 1, @value 2 )
	@define result = (@Bool and @B.fidelity) and @B.fidelity or 0
end]], "@result" )

Component:AddPreparedFunction( "egpPos", "wl:n", "v2", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = $EGP:HasObject( @value 1, @value 2 )
	@define result = (@Bool and Vector2(@B.x, @B.y)) and Vector2(@B.x, @B.y) or Vector2(-1,-1)
end]], "@result" )

Component:AddPreparedFunction( "egpRadius", "wl:n", "n", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = $EGP:HasObject( @value 1, @value 2 )
	@define result = (@Bool and @B.radius) and @B.radius or -1
end]], "@result" )

Component:AddPreparedFunction( "egpSize", "wl:n", "v2", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = $EGP:HasObject( @value 1, @value 2 )
	@define result = (@Bool and Vector2(@B.w, @B.h)) and Vector2(@B.w, @B.h) or Vector2(-1,-1)
end]], "@result" )

Component:AddPreparedFunction( "egpSizeNum", "wl:n", "n", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = $EGP:HasObject( @value 1, @value 2 )
	@define result = (@Bool and @B.size) and @B.size or -1
end]], "@result" )

----------------------------
-- Color
----------------------------
Component:AddPreparedFunction( "egpColor", "wl:n", "c", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = $EGP:HasObject( @value 1, @value 2 )
	@define result = (@Bool and @B.r and @B.g and @B.b and @B.a) and { @B.r, @B.g, @B.b, @B.a } or {-1, -1, -1, -1}
end]], "@result" )

Component:AddPreparedFunction( "egpAlpha", "wl:n", "n", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = $EGP:HasObject( @value 1, @value 2 )
	@define result = (@Bool and @B.a) and @B.a or -1
end]], "@result" )

----------------------------
-- Material
----------------------------
Component:AddPreparedFunction( "egpMaterial", "wl:n", "s", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = $EGP:HasObject( @value 1, @value 2 )
	@define result = (@Bool and @B.material) and @B.material or ""
end]], "@result" )

----------------------------
-- Parent
----------------------------
Component:AddPreparedFunction( "egpParent", "wl:n", "n", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = $EGP:HasObject( @value 1, @value 2 )
	@define result = (@Bool and @B.parent) and @B.parent or 0
end]], "@result" )

Component:AddPreparedFunction( "egpTrackerParent", "wl:n", "e", [[
if $EGP:ValidEGP( @value 1 ) then  
	@define Bool, A, B = $EGP:HasObject( @value 1, @value 2 )
	if @Bool and @B.Is3DTracker then
		@define result = (@B.parententity and @B.parententity:IsValid()) and @B.parententity or nil
	end
end]], "@result" )


/* 
Still Need:

egpToWorld
egpHudToggle
*/