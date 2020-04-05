////////////////////////////////////////////////
// -- DepthHUD Inline                         //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Iterative Element                          //
////////////////////////////////////////////////

do -- GLOBAL

function ELEMENT:CoreInitialize()
	self:CreateSmoother("_dispell", 1.0, 0.32)
	self._visible 		= false
	self._type    		= "NULL"
	self._usestaticcolor	= false
	
	self._maincolor 	= nil
	self._mainalphamod 	= nil
	
	self._altcolor 		= nil
	self._altalphamod 	= nil
	
	self._falsecolor 	= nil
	self._truecolor 	= nil
	
	self._rate			= 1
	
	self._blendcolor 	= Color(0,0,0,0)
	
	self._greattext		= ""
	self._greatstyle 	= 3
	self._greatfont 	= self.Theme:GetAppropriateFont( self._greattext, self._greatstyle )
	self._greatwasnum   = false
	
	self._smalltext		= ""
	self._smallfont 	= self.Theme:GetAppropriateFont( self._smalltext, 0 )
	self._smallwasnum   = false
	
	self:InitializeBaseColors()
	--self:UpdateColors()
end

function ELEMENT:Think()
	if self.Theme:ColorsNeedUpdate() then self:UpdateColors() end
	if self.Theme:FontsNeedUpdate()  then
		self._greatfont = self.Theme:GetAppropriateFont( self._greattext, self._greatstyle )
		self._smallfont = self.Theme:GetAppropriateFont( self._smalltext, 0 )
	end
end

function ELEMENT:SetType( sType )
	if (self._type ~= "NULL") then return false end

	if sType == "TextBox" then
		self._type = "TextBox"
	end
	if sType == "BlankBox" then
		self._type = "BlankBox"
	end
	if sType == "InfoBox" then
		self._type = "InfoBox"
		self._blinkbelow   = -1
		self._blinksize    = 1
		self._boxisatright = false
		self._minsize = 0
		self._maxsize = 1
		
	end
	
	return (self._type ~= "NULL")
end

end

do -- Dispell Values

function ELEMENT:IsVisible()
	return self._visible
end

function ELEMENT:ShouldDraw()
	return self:GetSmootherCurrent("_dispell") < 0.95
end

function ELEMENT:FadeIn()
	if self:IsVisible() then return end
	
	self._visible = true
	self:ChangeSmootherTarget("_dispell", 0.0)
end

function ELEMENT:FadeOut()
	if not self:IsVisible() then return end
	
	self._visible = false
	self:ChangeSmootherTarget("_dispell", 1.0)
end

function ELEMENT:GetDispellRate()
	return self:GetSmootherCurrent("_dispell")
end

function ELEMENT:CalcDispellModifiers()
	local xCenter, yCenter = dhinline.CalcCenter( self._t_xRel, self._t_yRel, self._t_width, self._t_height )
	
	local width, height = (1.0 + self._t_dispell * 0.5) * self._t_width, (1.0 + self._t_dispell * 0.5) * self._t_height

	return xCenter, yCenter, width, height
end

end

do -- Rate values

function ELEMENT:SetRate( fRate, optbUnbound )
	local prevRate = self._rate
	self._rate = self.Theme:ToRate( fRate, optbUnbound )
	
	if (prevRate ~= fRate) then
		self:UpdateColors()
		
	end
	
end

function ELEMENT:GetRate()
	return self._rate
end

end

do -- Color Mod

function ELEMENT:SetUsingStaticColor( bUseStatic )
	self._usestaticcolor = bUseStatic
end

function ELEMENT:IsUsingStaticColor()
	return self._usestaticcolor
end

function ELEMENT:UpdateColors()
	if self:IsUsingStaticColor() then return end
	
	--print("Called for update.")
	
	GC_ColorBlend( self._blendcolor, self._falsecolor, self._truecolor, self:GetRate() )
	
end

function ELEMENT:SetMainColor( scStringOrColor )
	if not scStringOrColor then scStringOrColor = "basecolor" end
	
	if (type(scStringOrColor) == "string") then
		self._maincolor = self.Theme:GetColorReference( scStringOrColor )
		
	else
		self._maincolor = scStringOrColor
		
	end
	
end

function ELEMENT:SetAlternateColor( scStringOrColor )
	if not scStringOrColor then scStringOrColor = "basecolor" end
	
	if (type(scStringOrColor) == "string") then
		self._altcolor = self.Theme:GetColorReference( scStringOrColor )
		
	else
		self._altcolor = scStringOrColor
		
	end
	
end

function ELEMENT:SetColorPair( scStringOrColorMain , scStringOrColorAlt )
	self:SetMainColor( scStringOrColorMain )
	self:SetAlternateColor( scStringOrColorAlt )
end

function ELEMENT:SetTrueColor( scStringOrColorn, optbDontUpdate )
	if not scStringOrColor then scStringOrColor = "basecolor" end
	
	if (type(scStringOrColor) == "string") then
		self._truecolor = self.Theme:GetColorReference( scStringOrColor )
		
	else
		self._truecolor = scStringOrColor
		
	end
	
	if not optbDontUpdate then self:UpdateColors() end
	
end

function ELEMENT:SetFalseColor( scStringOrColor )
	if not scStringOrColor then scStringOrColor = "badcolor" end
	
	if (type(scStringOrColor) == "string") then
		self._falsecolor = self.Theme:GetColorReference( scStringOrColor )
		
	else
		self._falsecolor = scStringOrColor
		
	end
	
	if not optbDontUpdate then self:UpdateColors() end
	
end

function ELEMENT:GetMainColor( optfSetAlphaMod )
	self._maincolor.a = self:ScaleAlpha( optfSetAlphaMod or 1 )
	
	return self._maincolor
end

function ELEMENT:GetAlternateColor( optfSetAlphaMod )
	self._altcolor.a = self:ScaleAlpha( optfSetAlphaMod or 1 )
	
	return self._altcolor
end

function ELEMENT:GetTrueColor( optfSetAlphaMod )
	self._truecolor.a = self:ScaleAlpha( optfSetAlphaMod or 1 )
	
	return self._truecolor
end

function ELEMENT:GetFalseColor( optfSetAlphaMod )
	self._falsecolor.a = self:ScaleAlpha( optfSetAlphaMod or 1 )
	
	return self._falsecolor
end

function ELEMENT:GetBlendedColor( optfSetAlphaMod )
	self._blendcolor.a = self:ScaleAlpha( optfSetAlphaMod or 1 )

	return self._blendcolor
end

function ELEMENT:GetBiaisedColor( optfSetAlphaMod )
	if self:IsUsingStaticColor() then
		return self:GetTrueColor( optfSetAlphaMod )
		
	else
		return self:GetBlendedColor( optfSetAlphaMod )
		
	end
		
end

function ELEMENT:ScaleAlpha( optfScale )
	return self.Theme:GetAlpha() * (1.0 - self:GetDispellRate()) * self.Theme:ToRate( optfScale or 1 )
end

function ELEMENT:InitializeBaseColors()
	self:SetTrueColor( nil, true )
	self:SetFalseColor( nil, true )
	self:SetMainColor( nil )
	self:SetAlternateColor( nil )
	
	self:UpdateColors()
end

end

do -- Common

function ELEMENT:DoDraw()
	if not self:ShouldDraw() then return end
	
	-- Recalc useable sizes for Dispell
	self._t_xRel, self._t_yRel, self._t_width, self._t_height = self:ConvertGridData()
	self._t_dispell = self:GetDispellRate()
	self._t_xCenter, self._t_yCenter, self._t_width, self._t_height = self:CalcDispellModifiers()
	
	
	if self._type == "InfoBox" then self:DrawInfobox() end
	if self._type == "TextBox" then self:DrawTextbox() end
	if self._type == "BlankBox" then self:DrawBackground() end
end

function ELEMENT:DrawBackground()

	local lagxCenter = self._t_xCenter + self.Theme:HudLagX() * self.Theme.PARAM_HUDLAG_BOX
	local lagyCenter = self._t_yCenter + self.Theme:HudLagY() * self.Theme.PARAM_HUDLAG_BOX
	
	local bgColor = nil
	if self._t_dispell > 0 then
		bgColor = self.Theme:GetBackgroundColor( 1.0 - self._t_dispell )
		
	else
		bgColor = self.Theme:GetBackgroundColor()
		
	end
	
	self.Theme:RAW_DrawRoundedBox(lagxCenter - self._t_width * 0.5, lagyCenter - self._t_height * 0.5, self._t_width, self._t_height, bgColor)
end

end

do -- Text-oriented

function ELEMENT:SetGreatText( snStringOrNumber )
	local lasttype = self._greatwasnum
	self._greattext = snStringOrNumber
	
	self._greatwasnum = type(self._greattext) == "number"
	if lasttype ~= self._greatwasnum then
		self._greatfont = self.Theme:GetAppropriateFont( self._greattext, self._greatstyle )
	end
		
end

function ELEMENT:SetGreatStyle( iChoice )
	local laststyle = self._greatstyle
	self._greatstyle = self.Theme:ToStyleNum( iChoice )
	
	if laststyle ~= self._greatstyle then
		self._greatfont = self.Theme:GetAppropriateFont( self._greattext, self._greatstyle )
	end
end

function ELEMENT:GetGreatSizes()
	surface.SetFont( self._greatfont )
	return surface.GetTextSize( self._greattext )
end

function ELEMENT:GetSmallSizes()
	surface.SetFont( self._smallfont )
	return surface.GetTextSize( self._smalltext )
end

function ELEMENT:SetSmallText( snStringOrNumber )
	local lasttype = self._smallwasnum
	self._smalltext = snStringOrNumber
	
	self._smallwasnum = type(self._greattext) == "number"
	if lasttype ~= self._smallwasnum then
		self._smallfont = self.Theme:GetAppropriateFont( self._smalltext, 0 )
	end
		
end

function ELEMENT:GetGreatText()
	return self._greattext or ""
end

function ELEMENT:GetSmallText()
	return self._smalltext or ""
end

function ELEMENT:DrawText(insideBoxXEquirel, insideBoxYEquirel, optfColorMainMod, optfColorAltMod, optfLagAdd)
	if ((self._greattext == nil) or (self._greattext == ""))
		and ((self._smalltext == nil) or (self._smalltext == "")) then
			return
	end
	
	optfLagAdd 			= optfLagAdd or 0
	optfColorMainMod 	= optfColorMainMod or 1
	optfColorAltMod 	= optfColorAltMod or 1

	
	local xText = self._t_xCenter + self.Theme:HudLagX() * self.Theme.PARAM_HUDLAG_TEXT * (1 + optfLagAdd) + insideBoxXEquirel * 0.5 * self._t_width
	local yText = self._t_yCenter + self.Theme:HudLagY() * self.Theme.PARAM_HUDLAG_TEXT * (1 + optfLagAdd) + insideBoxYEquirel * 0.5 * self._t_height
	local yTextSmall = yText + self._t_height * 0.4
	
	
	if self._greattext and (self._greattext ~= "") then
		draw.SimpleText(self._greattext, self._greatfont, xText, yText, self:GetMainColor( optfColorMainMod ) , 1, 1 )
	end
	
	if self._smalltext and (self._smalltext ~= "") then		
		draw.SimpleText(self._smalltext, self._smallfont, xText, yTextSmall, self:GetAlternateColor( optfColorAltMod ) , 1, 1 )
	end
end

function ELEMENT:DrawImmediateText( sText, sSmall, scColorMain, scColorAlt, insideBoxXEquirel, insideBoxYEquirel, optfColorMainMod, optfColorAltMod, optfLagAdd)
	if not self:ShouldDraw() then return end -- Prevents _x_center errors
	
	if sText and (sText ~= "") then
		self:SetMainColor( scColorMain )
	end
	if sSmall and (sSmall ~= "") then
		self:SetAlternateColor( scColorAlt )
	end
	
	if self._type ~= "BlankBox" then
		local ogt, ngt = self:GetGreatText( ), self:GetSmallText( )
	end
	
	self:SetGreatText( sText )
	self:SetSmallText( sSmall )
	
	self:DrawText(insideBoxXEquirel, insideBoxYEquirel, optfColorMainMod, optfColorAltMod, optfLagAdd)
		
	if self._type ~= "BlankBox" then
		self:SetGreatText( ogt )
		self:SetSmallText( ngt )
		
	end
	
end

end

do -- Textbox Specific

function ELEMENT:DrawTextbox()
	self:DrawBackground()
	self:DrawText(0, 0)
end

end

do -- Infobox Specific

function ELEMENT:SetBlinkBelowRate( fBBRate )
	self._blinkbelow = self.Theme:ToRate( fBBRate, true )
end

function ELEMENT:DisableBlink()
	self._blinkbelow = -1
end

function ELEMENT:GetBlinkBelowRate()
	return self._blinkbelow 
end

function ELEMENT:SetBoxIsAtRight( bIsAtRight )
	self._boxisatright = bIsAtRight or false
end

function ELEMENT:IsBoxAtRight()
	return self._boxisatright
end

function ELEMENT:SetBlinkSize()
	self._blinksize = self.Theme:ToRate( fBBRate, true )
end

function ELEMENT:GetBlinkSize()
	return self._blinksize
end

function ELEMENT:SetMinSize( fBBRate )
	self._minsize = self.Theme:ToRate( fBBRate, true )
end

function ELEMENT:SetMaxSize( fBBRate )
	self._maxsize = self.Theme:ToRate( fBBRate, true )
end

function ELEMENT:GetInnerSize()
	 return self._minsize + self:GetRate() * (self._maxsize - self._minsize) 
end

function ELEMENT:SetAlphaMods( fMainAlpha, fAltAlpha )
	self._mainalphamod = fMainAlpha
	self._altalphamod  = fAltAlpha
	
end

function ELEMENT:DrawInfobox()
	local sizedRate = 0	
	
	if self:GetRate() <= self:GetBlinkBelowRate() then
		self:GetFalseColor( (CurTime() % self.Theme.PARAM_BLINK_PERIOD) * (1 / self.Theme.PARAM_BLINK_PERIOD) )
		sizedRate = self:GetBlinkSize()
		
	else
		sizedRate = self:GetInnerSize()
		
	end
	
	local myDist = ((self._t_height + self._t_height * (1 - self.Theme.PARAM_INNERSQUARE_PROPORTIONS * 0.5)) * 0.5) / self._t_width
	
	self:DrawBackground()
	self:DrawInnerBox()
	
	self:DrawText((self:IsBoxAtRight() and -1 or 1) * myDist, 0, self._mainalphamod, self._altalphamod)

end

function ELEMENT:DrawInnerBox()
	
	local lagxCenter = self._t_xCenter + self.Theme:HudLagX() * self.Theme.PARAM_HUDLAG_INBOX
	local lagyCenter = self._t_yCenter + self.Theme:HudLagY() * self.Theme.PARAM_HUDLAG_INBOX
	
	local useColor = nil
	local sizedRate = -1
	if self:GetRate() > self:GetBlinkBelowRate() then
		useColor = self:GetBiaisedColor( 0.5 )
		
		sizedRate = self:GetInnerSize()
		
	else
		useColor = self:GetFalseColor( (CurTime() % self.Theme.PARAM_BLINK_PERIOD) * (1 / self.Theme.PARAM_BLINK_PERIOD) * 0.5 )
		
		sizedRate = self:GetBlinkSize()
		
	end
	
	local mySize = self._t_height * self.Theme.PARAM_INNERSQUARE_PROPORTIONS * sizedRate
	local myGap  = (self._t_height - mySize) * 0.5
	
	lagxCenter = lagxCenter + ( -self._t_width * 0.5 + myGap + mySize * 0.5) * (self:IsBoxAtRight() and -1 or 1)
	lagyCenter = lagyCenter - self._t_height * 0.5 + myGap + mySize * 0.5
	
	self.Theme:RAW_DrawRoundedBox(lagxCenter - mySize * 0.5, lagyCenter - mySize * 0.5, mySize, mySize, useColor)
	
	if self.Theme:IsUsingGlow() then
		local glowAlpha = self.Theme:GetGlowIntensity() * ( useColor.a / 255 )
		local glowSize = mySize * self.Theme:GetGlowSize()

		dhinline.DrawSprite(self.Theme.PARAM_GLOWTEXTURE, lagxCenter, lagyCenter, glowSize, glowSize, 0, useColor.r * glowAlpha, useColor.g * glowAlpha, useColor.b * glowAlpha, 255)
	end
	
end

end

do -- Volative Hub

function ELEMENT:UpdateVolatile(name, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice, duration, fadePower, storage)
	local xRel, yRel, width, height = self:ConvertGridData()
	
	self.Theme:UpdateVolatile(name, xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice, duration, fadePower, storage)
end

end