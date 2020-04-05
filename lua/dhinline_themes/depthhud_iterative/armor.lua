////////////////////////////////////////////////
// -- DepthHUD Inline                         //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Iterative :: Armor                         //
////////////////////////////////////////////////

ELEMENT.Name = "Armor"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 2
ELEMENT.DefaultGridPosY = 16
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.EVO_XREL = 0
ELEMENT.EVO_YREL = -1

ELEMENT.EVO_LAGMUL   = 2.5
ELEMENT.EVO_DURATION = 2
ELEMENT.EVO_POWER = 4
ELEMENT.EVO_FONT = nil

ELEMENT.LastArmor = 0

ELEMENT.accumPositive    = Color(164,220,255,192)
ELEMENT.accumNegative    = Color(128,164,190,192)

function ELEMENT:Initialize()
	self:SetType( "InfoBox" )
	self:SetTrueColor( Color(164,220,255,42) )
	self:SetFalseColor( Color(128,164,190,42) )
	self:SetMainColor( self:GetBiaisedColor() )
	self:SetMinSize( 1 )
	self:SetMaxSize( 1 )
	self:SetSmallText( "" )
end

function ELEMENT:DrawFunction()
	if (LocalPlayer():Alive() and LocalPlayer():Armor() > 0) or ((not LocalPlayer():Alive()) and (self.LastArmor > 0)) then
		self:FadeIn()
		self:SetRate( LocalPlayer():Armor() / 100 )
		
		if (LocalPlayer():Armor() ~= self.LastArmor) then
			self:SetGreatText( LocalPlayer():Armor() )
			
			local accum = self.Theme:GetVolatileStorage("armor_evolution") or 0
			local text = ""
			accum = accum + (LocalPlayer():Armor() - self.LastArmor)
			self.stocolor = nil
			
			if (accum > 0) then
				self.stocolor = self.accumPositive
				text = "+" .. accum
			else
				self.stocolor = self.accumNegative
				text = "" .. accum
			end
			
			self:UpdateVolatile( "armor_evolution", self.EVO_XREL ,self.EVO_YREL, text, self.stocolor, self.EVO_LAGMUL, self.EVO_FONT, self.EVO_DURATION, self.EVO_POWER, accum )
		end
		
		self.LastArmor = LocalPlayer():Alive() and LocalPlayer():Armor() or 0
		
	elseif self:IsVisible() then
		self.LastArmor = 0
		
		--self:SetGreatText( 0 )
		self:SetRate( 0 )
		self:FadeOut()
		
	end
	
	self:DoDraw()
	
	return
end
