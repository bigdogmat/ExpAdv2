/* --- --------------------------------------------------------------------------------
@: KeyBoard functions
   --- */

local Component = EXPADV.AddComponent( "input", true )

local KeyMap = { }

local function AddKey(key, us, en, sw, nw, ge)
	KeyMap[key] = {us = us, en = en, sw = sw, nw = nw, ge = ge}
end

local function GetKey(layout, key, lshift, rshift)
	local Map = KeyMap[key]
	if !Map then return 0 end

	Map = Map[layout or "us"]
	if !Map then return 0 end

	if lshift then return Map.l or Map.n or 0 end
	
	if rshift then return Map.r or Map.n or 0 end

	return Map.n or 0
end

/* --- --------------------------------------------------------------------------------
@: Default Keys - Based on Wiremods Keybaord entity.
   --- */

//	   KEY						AMERICAN							ENGLISH 							SWEDISH								NORWEIGEN							GERMAN					
AddKey(KEY_0, 					{n = 48, 	l = 41, 	r = 41}, 	{n = 48,	 l = 41, 	r = 41}, 	{n = 48, 	l = 61, 	r = 61}, 	{n = 48, 	l = 61, 	r = 61}, 	{n = 48, 	l = 61, 	r = 61})
AddKey(KEY_1, 					{n = 49, 	l = 33, 	r = 33}, 	{n = 49,	 l = 33, 	r = 33}, 	{n = 49, 	l = 33, 	r = 33}, 	{n = 49, 	l = 33, 	r = 33}, 	{n = 49, 	l = 33, 	r = 33})
AddKey(KEY_2, 					{n = 50, 	l = 64, 	r = 64}, 	{n = 50,	 l = 34, 	r = 34}, 	{n = 50, 	l = 34, 	r = 34}, 	{n = 50, 	l = 34, 	r = 34}, 	{n = 50, 	l = 34, 	r = 34})
AddKey(KEY_3, 					{n = 51, 	l = 35, 	r = 35}, 	{n = 51,	 l = 163,	r = 163}, 	{n = 51, 	l = 35, 	r = 35}, 	{n = 51, 	l = 35, 	r = 35}, 	{n = 51, 	l = 167, 	r = 167})
AddKey(KEY_4, 					{n = 52, 	l = 36, 	r = 36}, 	{n = 52,	 l = 36, 	r = 36}, 	{n = 52, 	l = 164, 	r = 164}, 	{n = 52, 	l = 164, 	r = 164}, 	{n = 52, 	l = 36, 	r = 36})
AddKey(KEY_5, 					{n = 53, 	l = 37, 	r = 37}, 	{n = 53,	 l = 37, 	r = 37}, 	{n = 53, 	l = 37, 	r = 37}, 	{n = 53, 	l = 37, 	r = 37}, 	{n = 53, 	l = 37, 	r = 37})
AddKey(KEY_6, 					{n = 54, 	l = 94, 	r = 94}, 	{n = 54,	 l = 94, 	r = 94}, 	{n = 54, 	l = 38, 	r = 38}, 	{n = 54, 	l = 38, 	r = 38}, 	{n = 54, 	l = 38, 	r = 38})
AddKey(KEY_7, 					{n = 55, 	l = 38, 	r = 38}, 	{n = 55,	 l = 38, 	r = 38}, 	{n = 55, 	l = 47, 	r = 47}, 	{n = 55, 	l = 47, 	r = 47}, 	{n = 55, 	l = 47, 	r = 47})
AddKey(KEY_8, 					{n = 56, 	l = 42, 	r = 42}, 	{n = 56,	 l = 42, 	r = 42}, 	{n = 56, 	l = 40, 	r = 40}, 	{n = 56, 	l = 40, 	r = 40}, 	{n = 56, 	l = 40, 	r = 40})
AddKey(KEY_9, 					{n = 57, 	l = 40, 	r = 40}, 	{n = 57,	 l = 40, 	r = 40}, 	{n = 57, 	l = 41, 	r = 41}, 	{n = 57, 	l = 41, 	r = 41}, 	{n = 57, 	l = 41, 	r = 41})
AddKey(KEY_A, 					{n = 97, 	l = 65, 	r = 65}, 	{n = 97,	 l = 65, 	r = 65}, 	{n = 97, 	l = 65, 	r = 65}, 	{n = 97, 	l = 65, 	r = 65}, 	{n = 97, 	l = 65, 	r = 65})
AddKey(KEY_B, 					{n = 98, 	l = 66, 	r = 66}, 	{n = 98,	 l = 66, 	r = 66}, 	{n = 98, 	l = 66, 	r = 66}, 	{n = 98, 	l = 66, 	r = 66}, 	{n = 98, 	l = 66, 	r = 66})
AddKey(KEY_C, 					{n = 99, 	l = 67, 	r = 67}, 	{n = 99,	 l = 67, 	r = 67}, 	{n = 99, 	l = 67, 	r = 67}, 	{n = 99, 	l = 67, 	r = 67}, 	{n = 99, 	l = 67, 	r = 67})
AddKey(KEY_D, 					{n = 100, 	l = 68, 	r = 68}, 	{n = 100,	 l = 68, 	r = 68}, 	{n = 100, 	l = 68, 	r = 68}, 	{n = 100, 	l = 68, 	r = 68}, 	{n = 100, 	l = 68, 	r = 68})
AddKey(KEY_E, 					{n = 101, 	l = 69, 	r = 69}, 	{n = 101,	 l = 69, 	r = 69}, 	{n = 101, 	l = 69, 	r = 69}, 	{n = 101, 	l = 69, 	r = 69}, 	{n = 101, 	l = 69, 	r = 69})
AddKey(KEY_F, 					{n = 102, 	l = 70, 	r = 70}, 	{n = 102,	 l = 70, 	r = 70}, 	{n = 102, 	l = 70, 	r = 70}, 	{n = 102, 	l = 70, 	r = 70}, 	{n = 102, 	l = 70, 	r = 70})
AddKey(KEY_G, 					{n = 103, 	l = 71, 	r = 71}, 	{n = 103,	 l = 71, 	r = 71}, 	{n = 103, 	l = 71, 	r = 71}, 	{n = 103, 	l = 71, 	r = 71}, 	{n = 103, 	l = 71, 	r = 71})
AddKey(KEY_H, 					{n = 104, 	l = 72, 	r = 72}, 	{n = 104,	 l = 72, 	r = 72}, 	{n = 104, 	l = 72, 	r = 72}, 	{n = 104, 	l = 72, 	r = 72}, 	{n = 104, 	l = 72, 	r = 72})
AddKey(KEY_I, 					{n = 105, 	l = 73, 	r = 73}, 	{n = 105,	 l = 73, 	r = 73}, 	{n = 105, 	l = 73, 	r = 73}, 	{n = 105, 	l = 73, 	r = 73}, 	{n = 105, 	l = 73, 	r = 73})
AddKey(KEY_J, 					{n = 106, 	l = 74, 	r = 74}, 	{n = 106,	 l = 74, 	r = 74}, 	{n = 106, 	l = 74, 	r = 74}, 	{n = 106, 	l = 74, 	r = 74}, 	{n = 106, 	l = 74, 	r = 74})
AddKey(KEY_K, 					{n = 107, 	l = 75, 	r = 75}, 	{n = 107,	 l = 75, 	r = 75}, 	{n = 107, 	l = 75, 	r = 75}, 	{n = 107, 	l = 75, 	r = 75}, 	{n = 107, 	l = 75, 	r = 75})
AddKey(KEY_L, 					{n = 108, 	l = 76, 	r = 76}, 	{n = 108,	 l = 76, 	r = 76}, 	{n = 108, 	l = 76, 	r = 76}, 	{n = 108, 	l = 76, 	r = 76}, 	{n = 108, 	l = 76, 	r = 76})
AddKey(KEY_M, 					{n = 109, 	l = 77, 	r = 77}, 	{n = 109,	 l = 77, 	r = 77}, 	{n = 109, 	l = 77, 	r = 77}, 	{n = 109, 	l = 77, 	r = 77}, 	{n = 109, 	l = 77, 	r = 77})
AddKey(KEY_N, 					{n = 110, 	l = 78, 	r = 78}, 	{n = 110,	 l = 78, 	r = 78}, 	{n = 110, 	l = 78, 	r = 78}, 	{n = 110, 	l = 78, 	r = 78}, 	{n = 110, 	l = 78, 	r = 78})
AddKey(KEY_O, 					{n = 111, 	l = 79, 	r = 79}, 	{n = 111,	 l = 79, 	r = 79}, 	{n = 111, 	l = 79, 	r = 79}, 	{n = 111, 	l = 79, 	r = 79}, 	{n = 111, 	l = 79, 	r = 79})
AddKey(KEY_P, 					{n = 112, 	l = 80, 	r = 80}, 	{n = 112,	 l = 80, 	r = 80}, 	{n = 112, 	l = 80, 	r = 80}, 	{n = 112, 	l = 80, 	r = 80}, 	{n = 112, 	l = 80, 	r = 80})
AddKey(KEY_Q, 					{n = 113, 	l = 81, 	r = 81}, 	{n = 113,	 l = 81, 	r = 81}, 	{n = 113, 	l = 81, 	r = 81}, 	{n = 113, 	l = 81, 	r = 81}, 	{n = 113, 	l = 81, 	r = 81})
AddKey(KEY_R, 					{n = 114, 	l = 82, 	r = 82}, 	{n = 114,	 l = 82, 	r = 82}, 	{n = 114, 	l = 82, 	r = 82}, 	{n = 114, 	l = 82, 	r = 82}, 	{n = 114, 	l = 82, 	r = 82})
AddKey(KEY_S, 					{n = 115, 	l = 83, 	r = 83}, 	{n = 115,	 l = 83, 	r = 83}, 	{n = 115, 	l = 83, 	r = 83}, 	{n = 115, 	l = 83, 	r = 83}, 	{n = 115, 	l = 83, 	r = 83})
AddKey(KEY_T, 					{n = 116, 	l = 84, 	r = 84}, 	{n = 116,	 l = 84, 	r = 84}, 	{n = 116, 	l = 84, 	r = 84}, 	{n = 116, 	l = 84, 	r = 84}, 	{n = 116, 	l = 84, 	r = 84})
AddKey(KEY_U, 					{n = 117, 	l = 85, 	r = 85}, 	{n = 117,	 l = 85, 	r = 85}, 	{n = 117, 	l = 85, 	r = 85}, 	{n = 117, 	l = 85, 	r = 85}, 	{n = 117, 	l = 85, 	r = 85})
AddKey(KEY_V, 					{n = 118, 	l = 86, 	r = 86}, 	{n = 118,	 l = 86, 	r = 86}, 	{n = 118, 	l = 86, 	r = 86}, 	{n = 118, 	l = 86, 	r = 86}, 	{n = 118, 	l = 86, 	r = 86})
AddKey(KEY_W, 					{n = 119, 	l = 87, 	r = 87}, 	{n = 119,	 l = 87, 	r = 87}, 	{n = 119, 	l = 87, 	r = 87}, 	{n = 119, 	l = 87, 	r = 87}, 	{n = 119, 	l = 87, 	r = 87})
AddKey(KEY_X, 					{n = 120, 	l = 88, 	r = 88}, 	{n = 120,	 l = 88, 	r = 88}, 	{n = 120, 	l = 88, 	r = 88}, 	{n = 120, 	l = 88, 	r = 88}, 	{n = 120, 	l = 88, 	r = 88})
AddKey(KEY_Y, 					{n = 121, 	l = 89, 	r = 89}, 	{n = 121,	 l = 89, 	r = 89}, 	{n = 121, 	l = 89, 	r = 89}, 	{n = 121, 	l = 89, 	r = 89}, 	{n = 121, 	l = 89, 	r = 89})
AddKey(KEY_Z, 					{n = 122, 	l = 90, 	r = 90}, 	{n = 122,	 l = 90, 	r = 90}, 	{n = 122, 	l = 90, 	r = 90}, 	{n = 122, 	l = 90, 	r = 90}, 	{n = 122, 	l = 90, 	r = 90})
AddKey(KEY_PAD_0, 				{n = 128, 	l = nil, 	r = nil}, 	{n = 128,	 l = nil, 	r = nil},	{n = 128, 	l = nil, 	r = nil}, 	{n = 128, 	l = nil, 	r = nil}, 	{n = 128, 	l = nil, 	r = nil})
AddKey(KEY_PAD_1, 				{n = 129, 	l = nil, 	r = nil}, 	{n = 129,	 l = nil, 	r = nil},	{n = 129, 	l = nil, 	r = nil}, 	{n = 129, 	l = nil, 	r = nil}, 	{n = 129, 	l = nil, 	r = nil})
AddKey(KEY_PAD_2, 				{n = 130, 	l = nil, 	r = nil}, 	{n = 130,	 l = nil, 	r = nil},	{n = 130, 	l = nil, 	r = nil}, 	{n = 130, 	l = nil, 	r = nil}, 	{n = 130, 	l = nil, 	r = nil})
AddKey(KEY_PAD_3, 				{n = 131, 	l = nil, 	r = nil}, 	{n = 131,	 l = nil, 	r = nil},	{n = 131, 	l = nil, 	r = nil}, 	{n = 131, 	l = nil, 	r = nil}, 	{n = 131, 	l = nil, 	r = nil})
AddKey(KEY_PAD_4, 				{n = 132, 	l = nil, 	r = nil}, 	{n = 132,	 l = nil, 	r = nil},	{n = 132, 	l = nil, 	r = nil}, 	{n = 132, 	l = nil, 	r = nil}, 	{n = 132, 	l = nil, 	r = nil})
AddKey(KEY_PAD_5, 				{n = 133, 	l = nil, 	r = nil}, 	{n = 133,	 l = nil, 	r = nil},	{n = 133, 	l = nil, 	r = nil}, 	{n = 133, 	l = nil, 	r = nil}, 	{n = 133, 	l = nil, 	r = nil})
AddKey(KEY_PAD_6, 				{n = 134, 	l = nil, 	r = nil}, 	{n = 134,	 l = nil, 	r = nil},	{n = 134, 	l = nil, 	r = nil}, 	{n = 134, 	l = nil, 	r = nil}, 	{n = 134, 	l = nil, 	r = nil})
AddKey(KEY_PAD_7, 				{n = 135, 	l = nil, 	r = nil}, 	{n = 135,	 l = nil, 	r = nil},	{n = 135, 	l = nil, 	r = nil}, 	{n = 135, 	l = nil, 	r = nil}, 	{n = 135, 	l = nil, 	r = nil})
AddKey(KEY_PAD_8, 				{n = 136, 	l = nil, 	r = nil}, 	{n = 136,	 l = nil, 	r = nil},	{n = 136, 	l = nil, 	r = nil}, 	{n = 136, 	l = nil, 	r = nil}, 	{n = 136, 	l = nil, 	r = nil})
AddKey(KEY_PAD_9, 				{n = 137, 	l = nil, 	r = nil}, 	{n = 137,	 l = nil, 	r = nil},	{n = 137, 	l = nil, 	r = nil}, 	{n = 137, 	l = nil, 	r = nil}, 	{n = 137, 	l = nil, 	r = nil})
AddKey(KEY_PAD_DIVIDE, 			{n = 138, 	l = nil, 	r = nil}, 	{n = 138,	 l = nil, 	r = nil},	{n = 138, 	l = nil, 	r = nil}, 	{n = 138, 	l = nil, 	r = nil}, 	{n = 138, 	l = nil, 	r = nil})
AddKey(KEY_PAD_MULTIPLY, 		{n = 139, 	l = nil, 	r = nil}, 	{n = 139,	 l = nil, 	r = nil},	{n = 139, 	l = nil, 	r = nil}, 	{n = 139, 	l = nil, 	r = nil}, 	{n = 139, 	l = nil, 	r = nil})
AddKey(KEY_PAD_MINUS, 			{n = 140, 	l = nil, 	r = nil}, 	{n = 140,	 l = nil, 	r = nil},	{n = 140, 	l = nil, 	r = nil}, 	{n = 140, 	l = nil, 	r = nil}, 	{n = 140, 	l = nil, 	r = nil})
AddKey(KEY_PAD_PLUS, 			{n = 141, 	l = nil, 	r = nil}, 	{n = 141,	 l = nil, 	r = nil},	{n = 141, 	l = nil, 	r = nil}, 	{n = 141, 	l = nil, 	r = nil}, 	{n = 141, 	l = nil, 	r = nil})
AddKey(KEY_PAD_ENTER, 			{n = 142, 	l = nil, 	r = nil}, 	{n = 142,	 l = nil, 	r = nil},	{n = 142, 	l = nil, 	r = nil}, 	{n = 142, 	l = nil, 	r = nil}, 	{n = 142, 	l = nil, 	r = nil})
AddKey(KEY_PAD_DECIMAL, 		{n = 143, 	l = nil, 	r = nil}, 	{n = 143,	 l = nil, 	r = nil},	{n = 143, 	l = nil, 	r = nil}, 	{n = 143, 	l = nil, 	r = nil}, 	{n = 143, 	l = nil, 	r = nil})
AddKey(KEY_ENTER, 				{n = 13, 	l = nil, 	r = nil}, 	{n = 13,	 l = nil, 	r = nil},	{n = 13, 	l = nil, 	r = nil}, 	{n = 13, 	l = nil, 	r = nil}, 	{n = 13, 	l = nil, 	r = nil})
AddKey(KEY_SPACE, 				{n = 32, 	l = nil, 	r = nil}, 	{n = 32,	 l = nil, 	r = nil},	{n = 32, 	l = nil, 	r = nil}, 	{n = 32, 	l = nil, 	r = nil}, 	{n = 32, 	l = nil, 	r = nil})
AddKey(KEY_BACKSPACE, 			{n = 127, 	l = nil, 	r = nil}, 	{n = 127,	 l = nil, 	r = nil},	{n = 127, 	l = nil, 	r = nil}, 	{n = 127, 	l = nil, 	r = nil}, 	{n = 127, 	l = nil, 	r = nil})
AddKey(KEY_TAB, 				{n = 9, 	l = nil, 	r = nil}, 	{n = 9,	 	 l = nil, 	r = nil},	{n = 9, 	l = nil, 	r = nil}, 	{n = 9, 	l = nil, 	r = nil}, 	{n = 9, 	l = nil, 	r = nil})
AddKey(KEY_CAPSLOCK, 			{n = 144, 	l = nil, 	r = nil}, 	{n = 144,	 l = nil, 	r = nil},	{n = 144, 	l = nil, 	r = nil}, 	{n = 144, 	l = nil, 	r = nil}, 	{n = 144, 	l = nil, 	r = nil})
AddKey(KEY_NUMLOCK, 			{n = 145, 	l = nil, 	r = nil}, 	{n = 145,	 l = nil, 	r = nil},	{n = 145, 	l = nil, 	r = nil}, 	{n = 145, 	l = nil, 	r = nil}, 	{n = 145, 	l = nil, 	r = nil})
AddKey(KEY_ESCAPE, 				{n = 18, 	l = nil, 	r = nil}, 	{n = 18,	 l = nil, 	r = nil},	{n = 18, 	l = nil, 	r = nil}, 	{n = 18, 	l = nil, 	r = nil}, 	{n = 18, 	l = nil, 	r = nil})
AddKey(KEY_SCROLLLOCK, 			{n = 146, 	l = nil, 	r = nil}, 	{n = 146,	 l = nil, 	r = nil},	{n = 146, 	l = nil, 	r = nil}, 	{n = 146, 	l = nil, 	r = nil}, 	{n = 146, 	l = nil, 	r = nil})
AddKey(KEY_INSERT, 				{n = 147, 	l = nil, 	r = nil}, 	{n = 147,	 l = nil, 	r = nil},	{n = 147, 	l = nil, 	r = nil}, 	{n = 147, 	l = nil, 	r = nil}, 	{n = 147, 	l = nil, 	r = nil})
AddKey(KEY_DELETE, 				{n = 148, 	l = nil, 	r = nil}, 	{n = 148,	 l = nil, 	r = nil},	{n = 148, 	l = nil, 	r = nil}, 	{n = 148, 	l = nil, 	r = nil}, 	{n = 148, 	l = nil, 	r = nil})
AddKey(KEY_HOME, 				{n = 149, 	l = nil, 	r = nil}, 	{n = 149,	 l = nil, 	r = nil},	{n = 149, 	l = nil, 	r = nil}, 	{n = 149, 	l = nil, 	r = nil}, 	{n = 149, 	l = nil, 	r = nil})
AddKey(KEY_END, 				{n = 150, 	l = nil, 	r = nil}, 	{n = 150,	 l = nil, 	r = nil},	{n = 150, 	l = nil, 	r = nil}, 	{n = 150, 	l = nil, 	r = nil}, 	{n = 150, 	l = nil, 	r = nil})
AddKey(KEY_PAGEUP, 				{n = 151, 	l = nil, 	r = nil}, 	{n = 151,	 l = nil, 	r = nil},	{n = 151, 	l = nil, 	r = nil}, 	{n = 151, 	l = nil, 	r = nil}, 	{n = 151, 	l = nil, 	r = nil})
AddKey(KEY_PAGEDOWN, 			{n = 152, 	l = nil, 	r = nil}, 	{n = 152,	 l = nil, 	r = nil},	{n = 152, 	l = nil, 	r = nil}, 	{n = 152, 	l = nil, 	r = nil}, 	{n = 152, 	l = nil, 	r = nil})
AddKey(KEY_BREAK, 				{n = 153, 	l = nil, 	r = nil}, 	{n = 153,	 l = nil, 	r = nil},	{n = 153, 	l = nil, 	r = nil}, 	{n = 153, 	l = nil, 	r = nil}, 	{n = 153, 	l = nil, 	r = nil})
AddKey(KEY_LSHIFT, 				{n = 154, 	l = nil, 	r = nil}, 	{n = 154,	 l = nil, 	r = nil},	{n = 154, 	l = nil, 	r = nil}, 	{n = 154, 	l = nil, 	r = nil}, 	{n = 154, 	l = nil, 	r = nil})
AddKey(KEY_RSHIFT, 				{n = 155, 	l = nil, 	r = nil}, 	{n = 155,	 l = nil, 	r = nil},	{n = 155, 	l = nil, 	r = nil}, 	{n = 155, 	l = nil, 	r = nil}, 	{n = 155, 	l = nil, 	r = nil})
AddKey(KEY_LALT, 				{n = 156, 	l = nil, 	r = nil}, 	{n = 156,	 l = nil, 	r = nil},	{n = 156, 	l = nil, 	r = nil}, 	{n = 156, 	l = nil, 	r = nil}, 	{n = 156, 	l = nil, 	r = nil})
AddKey(KEY_RALT, 				{n = 157, 	l = nil, 	r = nil}, 	{n = 157,	 l = nil, 	r = nil},	{n = 157, 	l = nil, 	r = nil}, 	{n = 157, 	l = nil, 	r = nil}, 	{n = 157, 	l = nil, 	r = nil})
AddKey(KEY_LCONTROL, 			{n = 158, 	l = nil, 	r = nil}, 	{n = 158,	 l = nil, 	r = nil},	{n = 158, 	l = nil, 	r = nil}, 	{n = 158, 	l = nil, 	r = nil}, 	{n = 158, 	l = nil, 	r = nil})
AddKey(KEY_RCONTROL, 			{n = 159, 	l = nil, 	r = nil}, 	{n = 159,	 l = nil, 	r = nil},	{n = 159, 	l = nil, 	r = nil}, 	{n = 159, 	l = nil, 	r = nil}, 	{n = 159, 	l = nil, 	r = nil})
AddKey(KEY_LWIN, 				{n = 160, 	l = nil, 	r = nil}, 	{n = 160,	 l = nil, 	r = nil},	{n = 160, 	l = nil, 	r = nil}, 	{n = 160, 	l = nil, 	r = nil}, 	{n = 160, 	l = nil, 	r = nil})
AddKey(KEY_RWIN, 				{n = 161, 	l = nil, 	r = nil}, 	{n = 161,	 l = nil, 	r = nil},	{n = 161, 	l = nil, 	r = nil}, 	{n = 161, 	l = nil, 	r = nil}, 	{n = 161, 	l = nil, 	r = nil})
AddKey(KEY_APP, 				{n = 162, 	l = nil, 	r = nil}, 	{n = 162,	 l = nil, 	r = nil},	{n = 162, 	l = nil, 	r = nil}, 	{n = 162, 	l = nil, 	r = nil}, 	{n = 162, 	l = nil, 	r = nil})
AddKey(KEY_UP, 					{n = 17, 	l = nil, 	r = nil}, 	{n = 17,	 l = nil, 	r = nil},	{n = 17, 	l = nil, 	r = nil}, 	{n = 17, 	l = nil, 	r = nil}, 	{n = 17, 	l = nil, 	r = nil})
AddKey(KEY_LEFT, 				{n = 19, 	l = nil, 	r = nil}, 	{n = 19,	 l = nil, 	r = nil},	{n = 19, 	l = nil, 	r = nil}, 	{n = 19, 	l = nil, 	r = nil}, 	{n = 19, 	l = nil, 	r = nil})
AddKey(KEY_DOWN, 				{n = 18, 	l = nil, 	r = nil}, 	{n = 18,	 l = nil, 	r = nil},	{n = 18, 	l = nil, 	r = nil}, 	{n = 18, 	l = nil, 	r = nil}, 	{n = 18, 	l = nil, 	r = nil})
AddKey(KEY_RIGHT, 				{n = 20, 	l = nil, 	r = nil}, 	{n = 20,	 l = nil, 	r = nil},	{n = 20, 	l = nil, 	r = nil}, 	{n = 20, 	l = nil, 	r = nil}, 	{n = 20, 	l = nil, 	r = nil})
AddKey(KEY_F1, 					{n = 163, 	l = nil, 	r = nil}, 	{n = 163,	 l = nil, 	r = nil},	{n = 163, 	l = nil, 	r = nil}, 	{n = 163, 	l = nil, 	r = nil}, 	{n = 163, 	l = nil, 	r = nil})
AddKey(KEY_F2, 					{n = 164, 	l = nil, 	r = nil}, 	{n = 164,	 l = nil, 	r = nil},	{n = 164, 	l = nil, 	r = nil}, 	{n = 164, 	l = nil, 	r = nil}, 	{n = 164, 	l = nil, 	r = nil})
AddKey(KEY_F3, 					{n = 165, 	l = nil, 	r = nil}, 	{n = 165,	 l = nil, 	r = nil},	{n = 165, 	l = nil, 	r = nil}, 	{n = 165, 	l = nil, 	r = nil}, 	{n = 165, 	l = nil, 	r = nil})
AddKey(KEY_F4, 					{n = 166, 	l = nil, 	r = nil}, 	{n = 166,	 l = nil, 	r = nil},	{n = 166, 	l = nil, 	r = nil}, 	{n = 166, 	l = nil, 	r = nil}, 	{n = 166, 	l = nil, 	r = nil})
AddKey(KEY_F5, 					{n = 167, 	l = nil, 	r = nil}, 	{n = 167,	 l = nil, 	r = nil},	{n = 167, 	l = nil, 	r = nil}, 	{n = 167, 	l = nil, 	r = nil}, 	{n = 167, 	l = nil, 	r = nil})
AddKey(KEY_F6, 					{n = 168, 	l = nil, 	r = nil}, 	{n = 168,	 l = nil, 	r = nil},	{n = 168, 	l = nil, 	r = nil}, 	{n = 168, 	l = nil, 	r = nil}, 	{n = 168, 	l = nil, 	r = nil})
AddKey(KEY_F7, 					{n = 169, 	l = nil, 	r = nil}, 	{n = 169,	 l = nil, 	r = nil},	{n = 169, 	l = nil, 	r = nil}, 	{n = 169, 	l = nil, 	r = nil}, 	{n = 169, 	l = nil, 	r = nil})
AddKey(KEY_F8, 					{n = 170, 	l = nil, 	r = nil}, 	{n = 170,	 l = nil, 	r = nil},	{n = 170, 	l = nil, 	r = nil}, 	{n = 170, 	l = nil, 	r = nil}, 	{n = 170, 	l = nil, 	r = nil})
AddKey(KEY_F9, 					{n = 171, 	l = nil, 	r = nil}, 	{n = 171,	 l = nil, 	r = nil},	{n = 171, 	l = nil, 	r = nil}, 	{n = 171, 	l = nil, 	r = nil}, 	{n = 171, 	l = nil, 	r = nil})
AddKey(KEY_F10, 				{n = 172, 	l = nil, 	r = nil}, 	{n = 172,	 l = nil, 	r = nil},	{n = 172, 	l = nil, 	r = nil}, 	{n = 172, 	l = nil, 	r = nil}, 	{n = 172, 	l = nil, 	r = nil})
AddKey(KEY_F11, 				{n = 173, 	l = nil, 	r = nil}, 	{n = 173,	 l = nil, 	r = nil},	{n = 173, 	l = nil, 	r = nil}, 	{n = 173, 	l = nil, 	r = nil}, 	{n = 173, 	l = nil, 	r = nil})
AddKey(KEY_F12, 				{n = 174, 	l = nil, 	r = nil}, 	{n = 174,	 l = nil, 	r = nil},	{n = 174, 	l = nil, 	r = nil}, 	{n = 174, 	l = nil, 	r = nil}, 	{n = 174, 	l = nil, 	r = nil})
AddKey(KEY_CAPSLOCKTOGGLE, 		{n = 175, 	l = nil, 	r = nil}, 	{n = 175,	 l = nil, 	r = nil},	{n = 175, 	l = nil, 	r = nil}, 	{n = 175, 	l = nil, 	r = nil}, 	{n = 175, 	l = nil, 	r = nil})
AddKey(KEY_NUMLOCKTOGGLE, 		{n = 176, 	l = nil, 	r = nil}, 	{n = 176,	 l = nil, 	r = nil},	{n = 176, 	l = nil, 	r = nil}, 	{n = 176, 	l = nil, 	r = nil}, 	{n = 176, 	l = nil, 	r = nil})
AddKey(KEY_SCROLLLOCKTOGGLE, 	{n = 177, 	l = nil, 	r = nil}, 	{n = 177,	 l = nil, 	r = nil},	{n = 177, 	l = nil, 	r = nil}, 	{n = 177, 	l = nil, 	r = nil}, 	{n = 177, 	l = nil, 	r = nil})
AddKey(KEY_LBRACKET, 			{n = 91, 	l = 123, 	r = 123}, 	{n = 91,	 l = 123, 	r = 123},	{n = 180, 	l = 96, 	r = 96}, 	{n = 92, 	l = 96, 	r = 96}, 	{n = 223, 	l = 63, 	r = 63})
AddKey(KEY_RBRACKET, 			{n = 93, 	l = 125, 	r = 125}, 	{n = 93,	 l = 125, 	r = 125},	{n = 229, 	l = 197, 	r = 197}, 	{n = 229, 	l = 197, 	r = 197}, 	{n = 180, 	l = 96, 	r = 96})
AddKey(KEY_SEMICOLON, 			{n = 59, 	l = 58, 	r = 58}, 	{n = 59,	 l = 58, 	r = 58}, 	{n = 168, 	l = 94, 	r = 94}, 	{n = 168, 	l = 94, 	r = 94}, 	{n = 252, 	l = 220, 	r = 220})
AddKey(KEY_APOSTROPHE, 			{n = 39, 	l = 34, 	r = 34}, 	{n = 35,	 l = 126, 	r = 126},	{n = 228, 	l = 196, 	r = 196}, 	{n = 230, 	l = 198, 	r = 198},	{n = 228, 	l = 196, 	r = 196})
AddKey(KEY_BACKQUOTE, 			{n = 96, 	l = nil, 	r = nil}, 	{n = 39,	 l = 64, 	r = 64}, 	{n = 246, 	l = 214, 	r = 214}, 	{n = 248, 	l = 216, 	r = 216}, 	{n = 246, 	l = 214, 	r = 214})
AddKey(KEY_COMMA, 				{n = 44, 	l = 60, 	r = 60}, 	{n = 44,	 l = 60, 	r = 60}, 	{n = 44, 	l = 59, 	r = 59}, 	{n = 44, 	l = 59, 	r = 59}, 	{n = 44, 	l = 59, 	r = 59})
AddKey(KEY_PERIOD, 				{n = 46, 	l = 62, 	r = 62}, 	{n = 46,	 l = 62, 	r = 62}, 	{n = 46, 	l = 58, 	r = 58}, 	{n = 46, 	l = 58, 	r = 58}, 	{n = 46, 	l = 58, 	r = 58})
AddKey(KEY_SLASH, 				{n = 47, 	l = 63, 	r = 63}, 	{n = 47,	 l = 63, 	r = 63}, 	{n = 39, 	l = 42, 	r = 42}, 	{n = 39, 	l = 42, 	r = 42}, 	{n = 35, 	l = 39, 	r = 39})
AddKey(KEY_BACKSLASH, 			{n = 92, 	l = 124, 	r = 124}, 	{n = 92,	 l = 124, 	r = 124},	{n = 167, 	l = 189, 	r = 189}, 	{n = 124, 	l = 167, 	r = 167}, 	{n = 94, 	l = 176, 	r = 176})
AddKey(KEY_MINUS, 				{n = 45, 	l = 95, 	r = 95}, 	{n = 45,	 l = 95, 	r = 95}, 	{n = 45, 	l = 95, 	r = 95}, 	{n = 45, 	l = 95, 	r = 95}, 	{n = 45, 	l = 95, 	r = 95})
AddKey(KEY_EQUAL, 				{n = 61, 	l = 43, 	r = 43}, 	{n = 61,	 l = 43, 	r = 43}, 	{n = 43, 	l = 63, 	r = 63}, 	{n = 43, 	l = 63, 	r = 63}, 	{n = 43, 	l = 42, 	r = 42})

/* --- --------------------------------------------------------------------------------
@: Numpad.
   --- */

local NumpadKeys = {
	[KEY_PAD_0] = "Zero",
	[KEY_PAD_1] = "One",
	[KEY_PAD_2] = "Two", 		
	[KEY_PAD_3] = "Three", 		
	[KEY_PAD_4] = "Four", 		
	[KEY_PAD_5] = "Five", 		
	[KEY_PAD_6] = "Six", 		
	[KEY_PAD_7] = "Seven", 		
	[KEY_PAD_8] = "Eight", 		
	[KEY_PAD_9] = "Nine", 		
	[KEY_PAD_DIVIDE] = "Divide", 	
	[KEY_PAD_MULTIPLY] = "Multiply",
	[KEY_PAD_MINUS] = "Minus", 	
	[KEY_PAD_PLUS] = "Plus", 	
	[KEY_PAD_ENTER] = "Enter", 	
	[KEY_PAD_DECIMAL] = "Decimal"
}

for Key, Name in pairs(NumpadKeys) do

	Component:AddVMFunction( "onNumpad" .. Name, "d", "",
		function(Context, Trace, Delegate)
			if !Context.Data.NumPad then Context.Data.NumPad = { } end
			Context.Data.NumPad[Key] = Delegate
		end )

	EXPADV.AddFunctionAlias("onNumpad" .. Name, "")

	Component:AddFunctionHelper("onNumpad" .. Name, "d", "Calls a delegate when a player presses the " .. Name .. " key on there numpad (first arg to delegate is player).")
end

/* --- --------------------------------------------------------------------------------
@: Layout Functions.
   --- */

Component:AddPreparedFunction( "setKeyboardUk", "", "", "Context.Data.KB_Layout = \"en\"" )
Component:AddPreparedFunction( "setKeyboardUS", "", "", "Context.Data.KB_Layout = \"us\"" )
Component:AddPreparedFunction( "setKeyboardSW", "", "", "Context.Data.KB_Layout = \"sw\"" )
Component:AddPreparedFunction( "setKeyboardNW", "", "", "Context.Data.KB_Layout = \"nw\"" )
Component:AddPreparedFunction( "setKeyboardGE", "", "", "Context.Data.KB_Layout = \"ge\"" )

Component:AddFunctionHelper("setKeyboardUk", "", "Sets the default keyboard layout for keypress events.")
Component:AddFunctionHelper("setKeyboardUS", "", "Sets the default keyboard layout for keypress events.")
Component:AddFunctionHelper("setKeyboardSW", "", "Sets the default keyboard layout for keypress events.")
Component:AddFunctionHelper("setKeyboardNW", "", "Sets the default keyboard layout for keypress events.")
Component:AddFunctionHelper("setKeyboardGE", "", "Sets the default keyboard layout for keypress events.")

function Component:OnRegisterContext(Context) Context.Data.KB_Users = {} end

Component:AddPreparedFunction( "setKeyboardUk", "ply:", "", "Context.Data.KB_Users[@value 1] = \"en\"" )
Component:AddPreparedFunction( "setKeyboardUS", "ply:", "", "Context.Data.KB_Users[@value 1] = \"us\"" )
Component:AddPreparedFunction( "setKeyboardSW", "ply:", "", "Context.Data.KB_Users[@value 1] = \"sw\"" )
Component:AddPreparedFunction( "setKeyboardNW", "ply:", "", "Context.Data.KB_Users[@value 1] = \"nw\"" )
Component:AddPreparedFunction( "setKeyboardGE", "ply:", "", "Context.Data.KB_Users[@value 1] = \"ge\"" )

Component:AddFunctionHelper("setKeyboardUk", "ply:", "Sets the keyboard layout for a players keypress events.")
Component:AddFunctionHelper("setKeyboardUS", "ply:", "Sets the keyboard layout for a players keypress events.")
Component:AddFunctionHelper("setKeyboardSW", "ply:", "Sets the keyboard layout for a players keypress events.")
Component:AddFunctionHelper("setKeyboardNW", "ply:", "Sets the keyboard layout for a players keypress events.")
Component:AddFunctionHelper("setKeyboardGE", "ply:", "Sets the keyboard layout for a players keypress events.")

/* --- --------------------------------------------------------------------------------
@: Events.
   --- */

EXPADV.SharedEvents( )
Component:AddEvent( "keypress", "ply,n", "" )
EXPADV.AddEventHelper("keypress", "Called when a player presses a key, gives both the player and the ascii char pressed.")

Component:AddEvent( "keyrelease", "ply,n", "" )
EXPADV.AddEventHelper("keyrelease", "Called when a player releases a key, gives both the player and the ascii char released.")

local LShift, RShift, DownKeys = { }, { }, { }

hook.Add( "PlayerButtonDown", "expadv.keys", function( Ply, Key )
	if Key == KEY_LSHIFT then LShift[Ply] = true end
	if Key == KEY_RSHIFT then RShift[Ply] = true end
	
	local Held = DownKeys[Ply]
	if !Held then Held = {}; DownKeys[Ply] = Held end
	
	if Held[Key] then return end
	Held[Key] = true;
	
	if !EXPADV.IsLoaded then return end

	for _, Context in pairs( EXPADV.CONTEXT_REGISTERY ) do

		if !Context.Online then continue end
		
		if NumpadKeys[Key] and Context.Data.NumPad then
			local Delegate = Context.Data.NumPad[Key]

			if Delegate then
				Context:Execute( "numpad " .. NumpadKeys[Key], Delegate, {Ply, "_ply"} )
			end
		end
		
		local Event = Context["event_keypress"]
		
		if Event then
			local Layout = Context.Data.KB_Users[Ply] or Context.Data.KB_Layout
			local Ascii = GetKey(Layout, Key, LShift[Ply], RShift[Ply])
			Context:Execute( "Event keypress", Event, Ply, Ascii )
		end
	end
end )

hook.Add( "PlayerButtonUp", "expadv.keys", function( Ply, Key )
	if Key == KEY_LSHIFT then LShift[Ply] = nil end
	if Key == KEY_RSHIFT then RShift[Ply] = nil end
	
	local Held = DownKeys[Ply]
	if !Held then Held = {}; DownKeys[Ply] = Held end
	
	Held[Key] = nil;
	
	if !EXPADV.IsLoaded then return end
	
	for _, Context in pairs( EXPADV.CONTEXT_REGISTERY ) do

		if !Context.Online then continue end
		
		local Event = Context["event_keyrelease"]
		
		if Event then
			local Key = GetKey(Context.Data.KB_Layout, Key, LShift[Ply], RShift[Ply])
			Context:Execute( "Event keyrelease", Event, Ply, Key )
		end
	end
end )

/* --- --------------------------------------------------------------------------------
@: Keyboard Mode.
   --- */

EXPADV.ClientOperators()

local PNL

local func = function(ply, bind, pressed)
	if bind == "+attack" or bind ==  "+attack2" then return nil end
	return true
end

Component:AddFeature( "LockInput", "Blocks user input, Useful for virtual keyboards.", "tek/iconexclamation.png" )

Component:AddVMFunction( "lockInput", "b", "", 
	function( Context, Trace, bool )
		if CLIENT and !IsValid(Context.entity) or !EXPADV.CanAccessFeature(Context.entity, "LockInput") then return end
		
		if bool and !IsValid(PNL) then
			-- Just jacked this from the wire keyboard :D
			PNL = vgui.Create("DShape")
			PNL:SetColor(Color(0, 0, 0, 192))
			PNL:SetType("Rect")

			local label = vgui.Create("DLabel", PNL)
			label:SetText("An EXPADV2 gate has locked your keyboard, press Left-Alt to exit.")
			label:SizeToContents()
			label:SetPos(6, 6)
			PNL:SizeToChildren(true, true)
			label:SetPos(2, 2)

			PNL:CenterHorizontal()
			PNL:CenterVertical(0.95)

			hook.Add("PlayerBindPress", "expadv.keys", func)
		elseif !bool and IsValid(PNL) then
			hook.Remove("PlayerBindPress", "expadv.keys")
			PNL:Remove()
		end
	end )

if CLIENT then
	hook.Add( "Think", "expadv.keys", function()
		if IsValid(PNL) and input.IsKeyDown(KEY_LALT) then 
			hook.Remove("PlayerBindPress", "expadv.keys")
			PNL:Remove()
		end
	end)
end
