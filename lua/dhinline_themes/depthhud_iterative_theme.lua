////////////////////////////////////////////////
// -- DepthHUD Inline                         //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Iterative Theme                            //
////////////////////////////////////////////////

THEME.Name = "DepthHUD Iterative"

-- Internal tweaking
THEME.PARAM_GLOWTEXTURE   = surface.GetTextureID("sprites/light_glow02_add")
THEME.PARAM_INNERSQUARE_PROPORTIONS = 0.7
THEME.PARAM_HUDLAG_BOX    = 1
THEME.PARAM_HUDLAG_INBOX  = 1.5
THEME.PARAM_HUDLAG_TEXT   = 1.25
THEME.PARAM_BLINK_PERIOD  = 0.5

-- Do not modify this, they are modified in real time
THEME._genericboxheight = 44
THEME._genericboxwidth  = math.floor(THEME._genericboxheight * 2.2)
THEME._hudlag = {}
THEME._hudlag.la = EyeAngles()
THEME._hudlag.wasInVeh = false
THEME._hudlag.x = 0
THEME._hudlag.y = 0
THEME._hudlag.mul = 2
THEME._hudlag.retab = 0.2

THEME._basecolor	 = Color(0,0,0,0)
THEME._basecolor_a	 = 255
THEME._backcolor	 = Color(0,0,0,0)
THEME._backcolor_a	 = 255
THEME._badcolor		 = Color(0,0,0,0)
THEME._backcolor_a	 = 255
THEME._errorcolor	 = Color(255,0,0,0)

THEME._mcolneedsupdate	 = false
THEME._mfonneedsupdate	 = false
THEME._mprevfonstat 	 = false

THEME._mac = Color(0,0,0,0)
THEME._mkc = Color(0,0,0,0)
THEME._mdc = Color(0,0,0,0)
THEME._malpha = -1

THEME.STOR_HUDPATCH_Volatile = {}

function THEME:Load()
	self:AddParameter("hudlag_mul", { Type = "slider", Defaults = "2", Min = "0", Max = "4", Decimals = "2", Text = "HUD Lag : Dispersion" } )
	self:AddParameter("hudlag_retab", { Type = "slider", Defaults = "0.2", Min = "0.1", Max = "0.4", Decimals = "2", Text = "HUD Lag : Repel (0.2 Recommended)" } )

	self:AddParameter("blendfonts", { Type = "checkbox", Defaults = "1", Text = "Fonts use Additive Mode" } )
	--self:AddParameter("dynamicbackground", { Type = "checkbox", Defaults = "0", Text = "Enable Dynamic Background" } )
	self:AddParameter("glow", { Type = "checkbox", Defaults = "1", Text = "Enable HUD Glow" } )
	
	self:AddParameter("glowintensity", { Type = "slider", Defaults = "0.4", Min = "0", Max = "1", Decimals = "2", Text = "Glow Intensity" } )
	self:AddParameter("glowsize", { Type = "slider", Defaults = "5", Min = "2", Max = "10", Decimals = "1", Text = "Glow Size" } )
	
	self:AddParameter("textopacity", { Type = "slider", Defaults = "192", Min = "0", Max = "255", Decimals = "0", Text = "Text Opacity" } )
	
	self:AddParameter("basecolor_label", { Type = "label", Defaults = "", Text = "Base Color" } )
	self:AddParameter("basecolor", { Type = "color", Defaults = {"255","220","0"} } )
	self:AddParameter("backcolor_label", { Type = "label", Defaults = "", Text = "Back Color" } )
	self:AddParameter("backcolor", { Type = "color", Defaults = {"0","0","0","92"} } )
	self:AddParameter("badcolor_label", { Type = "label", Defaults = "", Text = "Bad Color" } )
	self:AddParameter("badcolor", { Type = "color", Defaults = {"255","0","0",} } )
	
	self:AddParameter("box_scale", { Type = "slider", Defaults = "44", Min = "34", Max = "54", Decimals = "0", Text = "Base Scale" } )
	self:AddParameter("box_width", { Type = "slider", Defaults = "2.2", Min = "2.2", Max = "5", Decimals = "1", Text = "Width Scale" } )
	
	surface.CreateFont("halflife2" , 36, 0   , 0, 0, "dhfont_num3" )
	surface.CreateFont("halflife2" , 26, 2   , 0, 0, "dhfont_num2" )
	surface.CreateFont("halflife2" , 26, 2   , 0, 0, "dhfont_num1" )
	surface.CreateFont("halflife2" , 20, 0   , 0, 0, "dhfont_num0" )
	surface.CreateFont("DIN Light" , 36, 0   , 0, 0, "dhfont_txt3" )
	surface.CreateFont("DIN Medium", 24, 2   , 0, 0, "dhfont_txt2" )
	surface.CreateFont("DIN Light" , 24, 2   , 0, 0, "dhfont_txt1" )
	surface.CreateFont("DIN Medium", 16, 400 , 0, 0, "dhfont_txt0" )

	surface.CreateFont("halflife2" , 36, 0   , 0, false, "dhfont_num3_nob" )
	surface.CreateFont("halflife2" , 26, 2   , 0, false, "dhfont_num2_nob" )
	surface.CreateFont("halflife2" , 26, 2   , 0, false, "dhfont_num1_nob" )
	surface.CreateFont("halflife2" , 20, 0   , 0, false, "dhfont_num0_nob" )
	surface.CreateFont("DIN Light" , 36, 0   , 0, false, "dhfont_txt3_nob" )
	surface.CreateFont("DIN Medium", 24, 2   , 0, false, "dhfont_txt2_nob" )
	surface.CreateFont("DIN Light" , 24, 2   , 0, false, "dhfont_txt1_nob" )
	surface.CreateFont("DIN Medium", 16, 400 , 0, false, "dhfont_txt0_nob" )
end

function THEME:Unload()
	self:DeleteAllVolatiles()
end

function THEME:GetGenericBoxSizes()
	return self._genericboxwidth, self._genericboxheight
end

function THEME:ToStyleNum(desiredChoice)
	desiredChoice = desiredChoice or 3
	desiredChoice = math.Clamp(math.floor(desiredChoice), 0, 3)
	
	return desiredChoice
end

function THEME:GetAppropriateFont(text, desiredChoice)
	
	--local SPIT = "dhfont_" .. ((type(text or "") == "number") and "num" or "txt") .. tostring(desiredChoice) .. ((self:GetNumber("blendfonts") <= 0) and "_noblend" or "")
	--print( desiredChoice, type(text), SPIT)
	
	return "dhfont_" .. ((type(text or "") == "number") and "num" or "txt") .. tostring(desiredChoice) .. ((self:GetNumber("blendfonts") <= 0) and "_nob" or "")
end

function THEME:GetBackgroundColor( optfSetAlphaMod )
	if ( optfSetAlphaMod ) then
		self._backcolor.a = self._backcolor_a * self:ToRate( optfSetAlphaMod )
		
	else
		self._backcolor.a  = self._backcolor_a
		
	end
	
	return self._backcolor
end

function THEME:GetAlpha()
	return self:GetNumber("textopacity")
end

function THEME:IsUsingGlow()
	return (self:GetNumber("glow") > 0)
end

function THEME:GetGlowIntensity()
	return self:GetNumber("glowintensity")
end

function THEME:GetGlowSize()
	return self:GetNumber("glowsize")
end

////////////////////////////////////////////////

function THEME:ToRate( fRate, optbUnbound )
	return (fRate and ( optbUnbound and fRate or math.Clamp(fRate, 0, 1) ) or 1)
end



////////////////////////////////////////////////

function THEME:RAW_DrawRoundedBox( xPos, yPos, width, height, cColor, opt_ForceRound )
	local boxSizeCalc = math.Min(width, height) / 44
	local boxRound = 8
	if opt_ForceRound then
		boxRound = opt_ForceRound
	elseif boxSizeCalc <= 0.25 then
		boxRound = 0
	elseif boxSizeCalc > 0.25 and boxSizeCalc <= 0.5 then
		boxRound = 4
	elseif boxSizeCalc > 0.5 and boxSizeCalc <= 0.75 then
		boxRound = 6
	else
		boxRound = 8
	end
	
	draw.RoundedBox( boxRound, xPos, yPos, width, height, cColor )
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:CalcHudLag()
	if (self._hudlag.wasInVeh == LocalPlayer():InVehicle()) then
		
		self._hudlag.ca = EyeAngles()
	
		local targetX = math.AngleDifference(self._hudlag.ca.y , self._hudlag.la.y)*self._hudlag.mul
		local targetY = -math.AngleDifference(self._hudlag.ca.p , self._hudlag.la.p)*self._hudlag.mul
		
		self._hudlag.x = self._hudlag.x + (targetX - self._hudlag.x) * math.Clamp(self._hudlag.retab * 0.5 * FrameTime() * 50 , 0 , 1 )
		self._hudlag.y = self._hudlag.y + (targetY - self._hudlag.y) * math.Clamp(self._hudlag.retab * 0.5 * FrameTime() * 50 , 0 , 1 )
	
	end
	
	self._hudlag.wasInVeh = LocalPlayer():InVehicle()
	self._hudlag.la = EyeAngles()
end

function THEME:HudLagX()
	return self._hudlag.x
end

function THEME:HudLagY()
	return self._hudlag.y
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:DrawVolatile( xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice)
	local xCalc, yCalc = dhinline.CalcCenter( xRel , yRel , width , height )
	local xCalcOffset, yCalcOffset = xRelOffset*0.5*width, yRelOffset*0.5*height
	
	xCalc, yCalc = xCalc + xCalcOffset + self._hudlag.x*lagMultiplier , yCalc + yCalcOffset + self._hudlag.y*lagMultiplier
	
	local font = self:GetAppropriateFont(text, self:ToStyleNum(fontChoice))
	draw.SimpleText(text, font, xCalc, yCalc, textColor, 1, 1 )
end

function THEME:GetVolatileStorage(name)
	if (self.STOR_HUDPATCH_Volatile[name] == nil) then
		return nil
	end
	return self.STOR_HUDPATCH_Volatile[name][10] or nil
end

function THEME:UpdateVolatile(name, xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice, duration, fadePower, storage)
	self.STOR_HUDPATCH_Volatile[name] = {}
	self.STOR_HUDPATCH_Volatile[name][1] = xRel
	self.STOR_HUDPATCH_Volatile[name][2] = yRel
	self.STOR_HUDPATCH_Volatile[name][3] = text
	self.STOR_HUDPATCH_Volatile[name][4] = textColor
	self.STOR_HUDPATCH_Volatile[name][5] = lagMultiplier
	self.STOR_HUDPATCH_Volatile[name][6] = duration
	self.STOR_HUDPATCH_Volatile[name][7] = fadePower
	self.STOR_HUDPATCH_Volatile[name][8] = fontChoice
	self.STOR_HUDPATCH_Volatile[name][9] = RealTime()
	self.STOR_HUDPATCH_Volatile[name][10] = storage
	self.STOR_HUDPATCH_Volatile[name][11] = width
	self.STOR_HUDPATCH_Volatile[name][12] = height
	self.STOR_HUDPATCH_Volatile[name][13] = xRelOffset
	self.STOR_HUDPATCH_Volatile[name][14] = yRelOffset
end

function THEME:DrawVolatiles()
	for name,subtable in pairs(self.STOR_HUDPATCH_Volatile) do	
		if (subtable[1] ~= nil) then
			local timeSpawned = self.STOR_HUDPATCH_Volatile[name][9]
			local duration    = self.STOR_HUDPATCH_Volatile[name][6]
			
			if ((RealTime() - timeSpawned) > duration) then
				self.STOR_HUDPATCH_Volatile[name] = {nil}
			else
				local stayedUpRel = (RealTime() - timeSpawned) / duration
				
				local xRel = self.STOR_HUDPATCH_Volatile[name][1]
				local yRel = self.STOR_HUDPATCH_Volatile[name][2]
				local text = self.STOR_HUDPATCH_Volatile[name][3]
				local lagMultiplier = self.STOR_HUDPATCH_Volatile[name][5]
				local fadePower = self.STOR_HUDPATCH_Volatile[name][7]
				local fontChoice = self.STOR_HUDPATCH_Volatile[name][8]
				local width = self.STOR_HUDPATCH_Volatile[name][11]
				local height = self.STOR_HUDPATCH_Volatile[name][12]
				local xRelOffset = self.STOR_HUDPATCH_Volatile[name][13]
				local yRelOffset = self.STOR_HUDPATCH_Volatile[name][14]
				
				local textColor = Color(self.STOR_HUDPATCH_Volatile[name][4].r, self.STOR_HUDPATCH_Volatile[name][4].g, self.STOR_HUDPATCH_Volatile[name][4].b, self.STOR_HUDPATCH_Volatile[name][4].a)
				textColor.a = textColor.a * (1 - (stayedUpRel^fadePower))
				
				self:DrawVolatile(xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice)
			end
		end
		
	end
end

function THEME:DeleteAllVolatiles()
	self.STOR_HUDPATCH_Volatile = {}
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:GetColorReference( sColorLitteral )
	if     sColorLitteral == "basecolor" then return self._basecolor
	elseif sColorLitteral == "backcolor" then return self._backcolor
	elseif sColorLitteral == "badcolor"  then return self._badcolor end
	
	print(">-- Classic Theme ERROR : Requested color ".. sColorLitteral .. " that doesn't exist !")
	
	return self._errorcolor
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:Think()
	self._hudlag.mul   = self:GetParameterSettings("hudlag_mul")
	self._hudlag.retab = self:GetParameterSettings("hudlag_retab")
	
	self._mcolneedsupdate = false
	self._mfonneedsupdate = false
	
	if self._mprevfonstat ~= (self:GetNumber("blendfonts") <= 0) then
		self._mprevfonstat = not self._mprevfonstat
		self._mfonneedsupdate = true
	end
	
	dhinline.PrimeColorFromTable( self._basecolor, self:GetParameterSettings("basecolor") )
	dhinline.PrimeColorFromTable( self._backcolor, self:GetParameterSettings("backcolor") )
	dhinline.PrimeColorFromTable( self._badcolor , self:GetParameterSettings("badcolor")  )
	self._basecolor_a = self._basecolor.a
	self._backcolor_a = self._backcolor.a
	self._badcolor_a  = self._badcolor.a
	
	if (self._mac.r ~= self._basecolor.r)
		or (self._mac.g ~= self._basecolor.g)
		or (self._mac.b ~= self._basecolor.b) then
		
		self._mcolneedsupdate = true
		GC_ColorCopy(self._mac, self._basecolor)
	end
	if (self._mkc.r ~= self._backcolor.r)
		or (self._mkc.g ~= self._backcolor.g)
		or (self._mkc.b ~= self._backcolor.b) then
		
		self._mcolneedsupdate = true
		GC_ColorCopy(self._mkc, self._backcolor)
	end
	if (self._mdc.r ~= self._badcolor.r)
		or (self._mdc.g ~= self._badcolor.g)
		or (self._mdc.b ~= self._badcolor.b) then
		
		self._mcolneedsupdate = true
		GC_ColorCopy(self._mdc, self._badcolor)
	end
	if (self._malpha ~= self:GetAlpha()) then
	
		self._mcolneedsupdate = true
		self._malpha = self:GetAlpha()
	end
	
	self._genericboxheight = self:GetParameterSettings("box_scale")
	self._genericboxwidth = math.floor(self._genericboxheight * self:GetParameterSettings("box_width"))
	
	self:CalcHudLag()
end

function THEME:ColorsNeedUpdate()
	return self._mcolneedsupdate
end

function THEME:FontsNeedUpdate()
	return self._mfonneedsupdate
end

function THEME:PaintMisc()
	self:DrawVolatiles()
end
