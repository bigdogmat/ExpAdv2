/* --- --------------------------------------------------------------------------------
	@: String Component
   --- */

local Component = EXPADV.AddComponent( "string" , true )

Component.Author = "Rusketh"
Component.Description = "Added basic and advanced functions to do with strings."

/* --- --------------------------------------------------------------------------------
	@: String Object
   --- */

local String = Component:AddClass( "string" , "s" )

String:StringBuilder( function( Obj ) return Obj end )
String:CanSerialize( true )
String:DefaultAsLua( "" )
String:AddAlias( "str" )

/* --- --------------------------------------------------------------------------------
	@: Wire Support
   --- */

if WireLib then String:WireIO( "STRING" ) end

/* --- --------------------------------------------------------------------------------
	@: Sync
   --- */

String:NetWrite(function(Str)
	local len = #Str
	if len > 32767 then Str = Str.sub(1, 32767) end

	net.WriteUInt(len, 15)
	net.WriteData(Str, len)
end)

String:NetRead(function()
	return net.ReadData(net.ReadUInt(15))
end)

/* --- --------------------------------------------------------------------------------
	@: Logical and Comparison
   --- */

Component:AddInlineOperator("==", "s,s", "b", "(@value 1 == @value 2)" )

Component:AddInlineOperator("!=", "s,s", "b", "(@value 1 ~= @value 2)" )

Component:AddInlineOperator(">", "s,s", "b", "(@value 1 > @value 2)" )

Component:AddInlineOperator("<", "s,s", "b", "(@value 1 < @value 2)" )

Component:AddInlineOperator(">=","s,s", "b", "(@value 1 >= @value 2)" )

Component:AddInlineOperator("<=","s,s", "b", "(@value 1 <= @value 2)" )

/* --- --------------------------------------------------------------------------------
	@: Assignment
   --- */

String:AddVMOperator( "=", "n,s", "", function( Context, Trace, MemRef, Value )
   local Prev = Context.Memory[MemRef]
   Context.Memory[MemRef] = Value
   Context.Trigger[MemRef] = Context.Trigger[MemRef] or ( Prev ~= Value )
end )

 Component:AddPreparedOperator( "~", "s", "b", [[
 	@define value = Context.Memory[@value 1]
 	@define changed = Context.Changed[@value 1] ~= @value
 	Context.Changed[@value 1] = @value
 ]], "@changed" )


/* --- --------------------------------------------------------------------------------
	@: Arithmetic
   --- */

Component:AddInlineOperator("+","s,s", "s", "(@value 1 .. @value 2)" )

Component:AddInlineOperator("+","s,n", "s", "(@value 1 .. @value 2)" )

Component:AddInlineOperator("+","n,s", "s", "(@value 1 .. @value 2)" )

Component:AddInlineOperator( "#","s","n", "(string.len(@value 1))" )

/* --- --------------------------------------------------------------------------------
	@: Operators
   --- */

Component:AddInlineOperator( "is", "s", "b", "(@value 1 ~= \"\")" )

Component:AddInlineOperator( "not", "s", "b", "(@value 1 == \"\")" )

/* --- --------------------------------------------------------------------------------
	@: Indexing
   --- */

String:AddInlineOperator( "get", "s,n", "s", "@value 1[@value 2]" )

/* --- --------------------------------------------------------------------------------
	@: Casting
   --- */

Component:AddInlineOperator( "number", "s", "n", "tonumber(@value 1)" )

/* --- --------------------------------------------------------------------------------
	@: basic
   --- */

Component:AddInlineFunction( "sub", "s:n", "s", "string.sub(@value 1, @value 2)" )
Component:AddInlineFunction( "sub", "s:n,n", "s", "string.sub(@value 1, @value 2, @value 3)" )
Component:AddFunctionHelper( "sub", "s:n", "Returns a substring starting at location (number1 start) and ending at the end of the string." )
Component:AddFunctionHelper( "sub", "s:n,n", "Returns a substring starting at location (number1 start) and ending at (number2 end)." )

Component:AddInlineFunction( "lower", "s:", "s", "string.lower(@value 1)" )
Component:AddFunctionHelper( "lower", "s:", "Returns a lower-cased (string)." )

Component:AddInlineFunction( "upper", "s:", "s", "string.upper(@value 1)" )
Component:AddFunctionHelper( "upper", "s:", "Returns an uppercased string." )

Component:AddInlineFunction( "trim", "s:", "s", "string.Trim(@value 1)" )
Component:AddInlineFunction( "trim", "s:s", "s", "string.Trim(@value 1, @value 2)" )
Component:AddFunctionHelper( "trim", "s:", "Removes leading matches from a string." )
Component:AddFunctionHelper( "trim", "s:s", "Removes leading and trailing matches of a string." )

Component:AddInlineFunction( "triml", "s:", "s", "string.TrimLeft(@value 1)" )
Component:AddInlineFunction( "triml", "s:s", "s", "string.TrimLeft(@value 1, @value 2)" )
Component:AddFunctionHelper( "triml", "s:", "Removes leading matches from a string." )
Component:AddFunctionHelper( "triml", "s:s", "Removes leading and trailing matches of a string." )

Component:AddInlineFunction( "trimr", "s:", "s", "string.TrimRight(@value 1)" )
Component:AddInlineFunction( "trimr", "s:s", "s", "string.TrimRight(@value 1, @value 2)" )
Component:AddFunctionHelper( "trimr", "s:", "Removes leading matches from a string." )
Component:AddFunctionHelper( "trimr", "s:s", "Removes leading and trailing matches of a string." )

/* --- --------------------------------------------------------------------------------
	@: Find and replace
   --- */

Component:AddInlineFunction( "find", "s:s", "n", "(string.find(@value 1, @value 2, 1 , true) or 0)" )
Component:AddFunctionHelper( "find", "s:s", "Returns the location of first instance of (string) in a string." )

Component:AddInlineFunction( "find", "s:s,n", "n", "(string.find(@value 1, @value 2, @value 3, true) or 0)" )
Component:AddFunctionHelper( "find", "s:s,n", "Returns he location of first instance of (string) in a string, starting at location (number)." )

Component:AddInlineFunction( "replace", "s:s,s", "s", "(string.Replace(@value 1, @value 2, @value 3) or \"\")" )
Component:AddFunctionHelper( "replace", "s:s,s", "Finds and replaces every occurrence of the first argument with the second argument." )

/* --- --------------------------------------------------------------------------------
	@: Explodes and matches
   --- */

Component:AddPreparedFunction( "explode", "s:s", "ar", "@define Array = string.Explode(@value 2, @value 1)\n@Array.__type = 's'", "@Array" )
Component:AddFunctionHelper( "explode", "s:s", "Splits the string into an array using a defined seperator." )

Component:AddInlineFunction( "matchPattern", "s:s", "ar", "{__type = 's',string.match(@value 1, @value 2)}" )

Component:AddInlineFunction( "matchPattern", "s:s,n", "ar", "{__type = 's',string.match(@value 1, @value 2, @value 3)}" )

Component:AddInlineFunction( "matchFirst", "s:s", "s", "string.match(@value 1, @value 2)" )
Component:AddFunctionHelper( "matchFirst", "s:s", "Returns a string match to (string) starting at the leftmost character." )

Component:AddInlineFunction( "match", "s:s,n", "ar", "{__type = s',string.match(@value 1, @value 2, @value 3)}" )
Component:AddFunctionHelper( "match", "s:s,n", "Returns a string match to (string) starting at the leftmost character starting at location (number)." )

Component:CreateSetting( "gmatch_limit", 50 )

Component:AddPreparedFunction( "gmatch", "s:s", "ar", [[
	@define array, iter, values = {__type = 's'}, string.gmatch( @value 1, @value 2 )

	for i = 1, @setting gmatch_limit do
		@values = {@iter( )}
		if table.getn(@values) == 0 then break end
		@array[i] = @values
	end
]], "@array" )

Component:AddPreparedFunction( "gmatch", "s:s,n", "ar", [[
	@define array, iter, values = {__type = 's'}, string.gmatch( @value 1, @value 2 )

	for i = 1, math.Clamp( @value 3 or @setting gmatch_limit, 0, @setting gmatch_limit) do
		@values = {@iter( )}
		if table.getn(@values) == 0 then break end
		@array[i] = @values
	end
]], "@array" )


/* --- --------------------------------------------------------------------------------
	@: Regular Expressions
   --- */

Component:AddException( "string" )

Component:AddPreparedFunction( "findRE", "s:s,n", "n", [[
	@define Ok, Result = $pcall(string.find, @value 1, @value 2, @value 3 or 0)
	if !@Ok then Context:Throw( @trace, "string", @Result ) end
]], "(@Result or 0)" )
EXPADV.AddFunctionAlias( "findRE", "s:s" )
Component:AddFunctionHelper( "findRE", "s:s", "Returns he location of first instance of (string) in a string, starting at location (number), using regular expressions." )

Component:AddPreparedFunction( "replaceRE", "s:s,s", "s", [[
	@define Ok, Result = $pcall(string.gsub, @value 1, @value 2, @value 3)
	if !@Ok then Context:Throw( @trace, "string", @Result ) end
]], "(@Result or '')" )
Component:AddFunctionHelper( "replaceRE", "s:s,s", "Finds and replaces every occurrence of the first argument with the second argument using regular expressions." )

Component:AddPreparedFunction( "explodeRE", "s:s", "ar", [[
	@define Array = string.Explode(@value 2, @value 1, true)
	@Array.__type = 's']], "@Array" )
Component:AddFunctionHelper( "explodeRE", "s:s", "Splits the string into an array using a defined seperator using regular expressions." )

Component:AddPreparedFunction( "explodeRE", "s:s", "ar", [[
	@define Array = string.Explode(@value 2, @value 1, true)
	@Array.__type = 's']], "@Array" )
Component:AddFunctionHelper( "explodeRE", "s:s", "Splits the string into an array using a defined seperator using regular expressions." )


/* --- --------------------------------------------------------------------------------
	@: Format
   --- */

Component:AddPreparedFunction( "format", "s:...", "s", [[
	@define values, result = {}
	
	for i, variant in pairs( { @... } ) do
		@values[i] = tostring( variant[1] )
	end
	
	@result = string.format( @value 1, $unpack(@values) )
]], "@result" )

/* --- --------------------------------------------------------------------------------
	@: Insert / Remove
   --- */
   
Component:AddInlineFunction( "remove", "s:n,n", "s", "(string.sub( @value 1, 1, @value 2 - 1 ) .. string.sub( @value 1, @value 3 or (@value 2 + 1) ))" )
Component:AddFunctionHelper( "remove", "s:n,n", "Removes nth Char from string." )
		  EXPADV.AddFunctionAlias( "remove", "s:n" )

Component:AddInlineFunction( "insert", "s:s,n,n", "s", "(string.sub( @value 1, 1, @value 3 ) .. @value 2 .. string.sub( @value 1, @value 4 or (@value 3 + 1) ))" )
Component:AddFunctionHelper( "insert", "s:s,n,n", "Inserts into string after nth char." )
		  EXPADV.AddFunctionAlias( "insert", "s:s,n" )

/* --- --------------------------------------------------------------------------------
	@: Char and byte
   --- */

Component:AddInlineFunction( "toByte", "s:", "n", [[(@value 1 ~= "" and string.byte(@value 1) or -1)]] )
Component:AddFunctionHelper( "toByte", "s:", "Returns the ASCII code for a given character." )

Component:AddInlineFunction( "toChar", "n:", "s", [[(@value 1 ~= -1 and string.char(@value 1) or "")]] )
Component:AddFunctionHelper( "toChar", "n:", "Returns the character for a given ASCII code." )

/* --- --------------------------------------------------------------------------------
	@: Index
   --- */

String:AddInlineOperator( "get", "t,n,vr", "s", "@value 1[@value 2]" )
String:AddInlineOperator( "get", "t,n,s", "s", "@value 1[@value 2]" )
