/* ---	--------------------------------------------------------------------------------
	@: Files
   ---	*/

file.CreateDir( "expadv/files" )
file.CreateDir( "expadv/userfiles" )

local Component = EXPADV.AddComponent( "file" , true )

Component.Author = "Rusketh"
Component.Description = "Read and write files."

/* --- --------------------------------------------------------------------------------
	@: Settings
   --- */

Component:CreateSetting( "max_filesize", 5120 )

/* --- --------------------------------------------------------------------------------
	@: functions
   --- */

EXPADV.SharedOperators()



local function GetValidPath( Context, Path, bCreate )
	if Path:find( "..", 1, true ) then return false end

	local FilePath, FileName

	if string.find(Path, "/") then
		FileName = string.GetFileFromFilename( Path )
		FilePath = string.GetPathFromFilename( Path )
		if FilePath[#FilePath] == "/" then FilePath = string.sub(FilePath, 1, #FilePath - 1) end
		if FilePath == "" or FilePath == "/" then FilePath = nil end
	else
		FileName = Path
	end
	

	local Root

	if CLIENT and Context.player == LocalPlayer() then
		Root = "expadv2/files"
	elseif SERVER or EXPADV.CanAccessFeature(Context.entity, "File access") then
		Root = "expadv2/userfiles/" .. string.gsub(Context.player:SteamID(), ":", "_")
	else
		return false
	end

	if bCreate then
		file.CreateDir(Root)

		if FilePath and !file.Exists(Root .. "/" .. FilePath, "DATA") then
			file.CreateDir(Root .. "/" .. FilePath)
		end
	end

	if FilePath  then
		return Root .. "/" .. FilePath .. "/" .. FileName
	end

	return Root .. "/" .. FileName
end

Component:AddVMFunction( "readFile", "s", "s",
	function( Context, Trace, Path )
		local ValidPath = GetValidPath( Context, Path, false )
		
		return ValidPath and file.Read( ValidPath ) or ""
	end )

Component:AddVMFunction( "writeFile", "s,s", "",
	function( Context, Trace, Path, File )
		if #File < Component:ReadSetting( "max_filesize", 300 ) then

			local ValidPath = GetValidPath( Context, Path, true )
			print( "Valid Path:", ValidPath)

			if ValidPath then
				file.Write( ValidPath, File, true )
			end
		end
	end )

Component:AddVMFunction( "fileExists", "s", "b",
	function( Context, Trace, Path )
		local ValidPath = GetValidPath( Context, Path, true )
		
		return ValidPath and file.Exists( ValidPath, "DATA" ) or false
	end )

Component:AddVMFunction( "deleteFile", "s", "",
	function( Context, Trace, Path )
		local ValidPath = GetValidPath( Context, Path, true )
		
		if ValidPath then
			file.Delete( ValidPath )
		end
	end )

Component:AddVMFunction( "isDir", "s", "b",
	function( Context, Trace, Path )
		local ValidPath = GetValidPath( Context, Path, true )
		
		return ValidPath and file.IsDir( ValidPath, "DATA" ) or false
	end )

Component:AddVMFunction( "fileSize", "s", "n",
	function( Context, Trace, Path )
		local ValidPath = GetValidPath( Context, Path, true )
		
		return ValidPath and file.Size( ValidPath, "DATA" ) or 0
	end )

Component:AddVMFunction( "findFiles", "s,s", "ar",
	function( Context, Trace, FileName, Path )
		local ValidPath = GetValidPath( Context, Path, true )
		if !ValidPath then return {__type = "s"} end

		local Files, Folders = file.Find( FileName, ValidPath )
		Files.__type = "s"
		return Files
	end )

Component:AddVMFunction( "findFolders", "s,s", "ar",
	function( Context, Trace, FileName, Path )
		local ValidPath = GetValidPath( Context, Path, true )
		if !ValidPath then return {__type = "s"} end

		local Files, Folders = file.Find( FileName, ValidPath )
		Folders.__type = "s"
		return Folders
	end )

EXPADV.ClientOperators()
Component:AddFunctionHelper( "readFile", "s", "Returns the containments of file by the given path." )
Component:AddFunctionHelper( "writeFile", "s,s", "Writes the containments of the 2nd string into file by the 1st string path." )
Component:AddFunctionHelper( "fileExists", "s", "Returns true if the file by the given path exists." )
Component:AddFunctionHelper( "deleteFile", "s", "Deletes the file by the given path." )
Component:AddFunctionHelper( "isDir", "s", "Returns true if the file by the given path is directory." )
Component:AddFunctionHelper( "fileSize", "s", "Returns the size of file by the given path." )
Component:AddFunctionHelper( "findFiles", "s,s", "Returns an array with containments of files in 1st string path with name containing the 2nd string." )
Component:AddFunctionHelper( "findFolders", "s,s", "Returns an array with containments of folders in 1st string path with name containing the 2nd string." )
Component:AddInlineFunction( "canAccessFiles", "", "b", [[EXPADV.CanAccessFeature(Context.entity, "File access")]] )
Component:AddFunctionHelper( "canAccessFiles", "", "Returns true if this entity can access files." )

/* -----------------------------------------------------------------------------------
	@: WIP Features.
   --- */

Component:AddFeature( "Files", "Read and save files.", "tek/icons/iconfileaccess.png" )

EXPADV.SharedEvents( )
Component:AddEvent( "disableFileAccess", "", "" )
Component:AddEvent( "enableFileAccess", "", "" )

if CLIENT then
	function Component:OnChangeFeatureAccess(Entity, Feature, Value)
		if Feature == "File access" then
			if Value then
				Entity:CallEvent( "enableFileAccess" )
			else
				Entity:CallEvent( "disableFileAccess" )
			end
		end
	end
end

