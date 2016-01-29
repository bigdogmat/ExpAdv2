/* --- --------------------------------------------------------------------------------
	@: Color Component
   --- */

local Component = EXPADV.AddComponent( "color", true )

Component.Author = "Nez"
Component.Description = "Adds color objects and color based functions."

/* --- --------------------------------------------------------------------------------
	@: Color Object
   --- */

local ColorObj = Component:AddClass( "color", "c" )

ColorObj:StringBuilder( function(Color)
	return string.format( "Color(%i, %i, %i, %i)", Color.r or 0, Color.g or 0, Color.b or 0, Color.a or 0)
end )

ColorObj:DefaultAsLua( Color(255, 255, 255) )
ColorObj:CanSerialize( true )

if WireLib then
	ColorObj:WireIO("VECTOR",
		function(Value, Context) -- To Wire
			return Vector(Value.r, Value.g, Value.b)
		end, function(Value, context) -- From Wire
			return Color( Value.x or 0, Value.y or 0, Value.z or 0 )
		end)
end

/* --- --------------------------------------------------------------------------------
  @: Sync
   --- */

ColorObj:NetWrite(net.WriteColor)
ColorObj:NetRead(net.ReadColor)

/* --- --------------------------------------------------------------------------------
	@: Logical and Comparison
   --- */

Component:AddInlineOperator( "==", "c,c", "b", "(@value 1.r == @value 2.r && @value 1.g == @value 2.g && @value 1.b == @value 2.b && @value 1.a == @value 2.a)" )

Component:AddInlineOperator( "!=", "c,c", "b", "(@value 1.r ~= @value 2.r || @value 1.g ~= @value 2.g || @value 1.b ~= @value 2.b || @value 1.a ~= @value 2.a)" )

/* --- --------------------------------------------------------------------------------
	@: Operators
   --- */

Component:AddInlineOperator( "is", "c", "b", "(@value 1 ~= Color(0, 0, 0, 0))" )

Component:AddInlineOperator( "not", "c", "b", "(@value 1 == Color(0, 0, 0, 0))" )

/* --- --------------------------------------------------------------------------------
	@: Arithmetic
   --- */

Component:AddInlineOperator( "+", "c,c", "c", "Color( @value 1.r + @value 2.r, @value 1.g + @value 2.g, @value 1.b + @value 2.b, @value 1.a + @value 2.a )" )
Component:AddInlineOperator( "-", "c,c", "c", "Color( @value 1.r - @value 2.r, @value 1.g - @value 2.g, @value 1.b - @value 2.b, @value 1.a - @value 2.a )" )
Component:AddInlineOperator( "*", "c,c", "c", "Color( @value 1.r * @value 2.r, @value 1.g * @value 2.g, @value 1.b * @value 2.b, @value 1.a * @value 2.a )" )
Component:AddInlineOperator( "/", "c,c", "c", "Color( @value 1.r / @value 2.r, @value 1.g / @value 2.g, @value 1.b / @value 2.b, @value 1.a / @value 2.a )" )

/* --- --------------------------------------------------------------------------------
	@: Number Arithmetic
   --- */

Component:AddInlineOperator( "+", "c,n", "c", "Color( @value 1.r + @value 2, @value 1.g + @value 2, @value 1.b + @value 2, @value 1.a + @value 2 )" )
Component:AddInlineOperator( "-", "c,n", "c", "Color( @value 1.r - @value 2, @value 1.g - @value 2, @value 1.b - @value 2, @value 1.a - @value 2 )" )
Component:AddInlineOperator( "*", "c,n", "c", "Color( @value 1.r * @value 2, @value 1.g * @value 2, @value 1.b * @value 2, @value 1.a * @value 2 )" )
Component:AddInlineOperator( "/", "c,n", "c", "Color( @value 1.r / @value 2, @value 1.g / @value 2, @value 1.b / @value 2, @value 1.a / @value 2 )" )

Component:AddInlineOperator( "+", "n,c", "c", "Color( @value 1 + @value 2.r, @value 1 + @value 2.g, @value 1 + @value 2.b, @value 1 + @value 2.a )" )
Component:AddInlineOperator( "-", "n,c", "c", "Color( @value 1 - @value 2.r, @value 1 - @value 2.g, @value 1 - @value 2.b, @value 1 - @value 2.a )" )
Component:AddInlineOperator( "*", "n,c", "c", "Color( @value 1 * @value 2.r, @value 1 * @value 2.g, @value 1 * @value 2.b, @value 1 * @value 2.a )" )
Component:AddInlineOperator( "/", "n,c", "c", "Color( @value 1 / @value 2.r, @value 1 / @value 2.g, @value 1 / @value 2.b, @value 1 / @value 2.a )" )

/* --- --------------------------------------------------------------------------------
	@: Casting
   --- */

Component:AddInlineOperator( "color", "s", "c", "string.ToColor(@value 1)" )
Component:AddInlineOperator( "string", "c", "s", "string.format( \"Color(%i, %i, %i, %i)\", @value 1.r or 0, @value 1.g or 0, @value 1.b or 0, @value 1.a or 0)" )

/* --- --------------------------------------------------------------------------------
	@: Assignment
   --- */

ColorObj:AddVMOperator( "=", "n,c", "", function( Context, Trace, MemRef, Value )
	local Prev = Context.Memory[MemRef] or Color( 0, 0, 0, 0 )

	Context.Memory[MemRef] = Value
	Context.Delta[MemRef] = Color( Prev.r - Value.r, Prev.g - Value.g, Prev.b - Value.b, Prev.a - Value.a )
	Context.Trigger[MemRef] = Context.Trigger[MemRef] or ( Prev ~= Value )
end )

ColorObj:AddInlineOperator( "$", "n", "c", "(Context.Delta[@value 1] or Color(0,0,0,0))" )

/* --- --------------------------------------------------------------------------------
	@: Constructor
   --- */

Component:AddInlineFunction( "color", "n,n,n,n", "c", "Color(@value 1, @value 2, @value 3, @value 4)" )
Component:AddFunctionHelper( "color", "n,n,n,n", "Creates a color object")
EXPADV.AddFunctionAlias( "color", "n,n,n" )
Component:AddInlineFunction( "color", "n,n", "c", "Color(@value 1, @value 1, @value 1, @value 2)" )
Component:AddFunctionHelper( "color", "n,n", "Creates a color object, alias for color(number N, number N, number N, number M)")
Component:AddInlineFunction( "color", "n", "c", "Color(@value 1, @value 1, @value 1)" )
Component:AddFunctionHelper( "color", "n", "Creates a color object, alias for color(number N, number N, number N)")

Component:AddPreparedFunction( "clone", "c:", "c", "Color(@value 1.r, @value 1.g, @value 1.b, @value 1.a)" )
Component:AddFunctionHelper( "clone", "c:", "Returns a clone of the color." )

/* --- --------------------------------------------------------------------------------
	@: Accessors
   --- */

--GETTERS
Component:AddInlineFunction( "getRed", "c:", "n", "@value 1.r")
Component:AddFunctionHelper( "getRed", "c:", "Gets the red value of a color object")

Component:AddInlineFunction( "getGreen", "c:", "n", "@value 1.g")
Component:AddFunctionHelper( "getGreen", "c:", "Gets the green value of a color object")

Component:AddInlineFunction( "getBlue", "c:", "n", "@value 1.b")
Component:AddFunctionHelper( "getBlue", "c:", "Gets the blue value of a color object")

Component:AddInlineFunction( "getAlpha", "c:", "n", "@value 1.a")
Component:AddFunctionHelper( "getAlpha", "c:", "Gets the alpha value of a color object")

--SETTERS
Component:AddPreparedFunction( "setRed", "c:n", "c", "@value 1.r = @value 2", "(@value 1)")
Component:AddFunctionHelper( "setRed", "c:n", "Sets the red value of a color object")

Component:AddPreparedFunction( "setGreen", "c:n", "c", "@value 1.g = @value 2", "(@value 1)")
Component:AddFunctionHelper( "setGreen", "c:n", "Sets the green value of a color object")

Component:AddPreparedFunction( "setBlue", "c:n", "c", "@value 1.b = @value 2", "(@value 1)")
Component:AddFunctionHelper( "setBlue", "c:n", "Sets the blue value of a color object")

Component:AddPreparedFunction( "setAlpha", "c:n", "c", "@value 1.a = @value 2", "(@value 1)")
Component:AddFunctionHelper( "setAlpha", "c:n", "Sets the alpha value of a color object")

/* --- --------------------------------------------------------------------------------
	@: HSV2RGB
   --- */

Component:AddInlineFunction( "hsv2rgb", "n,n,n", "c", "$HSVToColor(@value 1, @value 2, @value 3)")
Component:AddFunctionHelper( "hsv2rgb", "n,n,n", "Converts hsv color to regular color")

Component:AddInlineFunction( "rgb2hsv", "n,n,n", "c", "$ColorToHSV(@value 1, @value 2, @value 3)")
Component:AddFunctionHelper( "rgb2hsv", "n,n,n", "Converts regular color to hsv color")

/* --- --------------------------------------------------------------------------------
    @: Useful
   --- */

Component:AddInlineFunction( "mix", "c,c,n", "c", "Color(@value 1.r * @value 3 + @value 2.r * (1-@value 3), @value 1.g * @value 3 + @value 2.g * (1-@value 3), @value 1.b * @value 3 + @value 2.b * (1-@value 3), @value 1.a * @value 3 + @value 2.a * (1-@value 3))")
Component:AddFunctionHelper( "mix", "c,c,n", "Returns the mix of 2 colors")
