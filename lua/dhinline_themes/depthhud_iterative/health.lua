////////////////////////////////////////////////
// -- DepthHUD Inline                         //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Iterative :: Health                        //
////////////////////////////////////////////////

ELEMENT.Name = "Health"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 0
ELEMENT.DefaultGridPosY = 16
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.EVO_XREL = 0
ELEMENT.EVO_YREL = -1

ELEMENT.EVO_LAGMUL   = 2.5
ELEMENT.EVO_DURATION = 2
ELEMENT.EVO_POWER = 4
ELEMENT.EVO_FONT = nil

ELEMENT.LastHealth = 0

ELEMENT.accumPositive    = Color(0,255,0,255)
ELEMENT.accumNegative    = Color(255,0,0,255)

function ELEMENT:Initialize()
	self:SetType( "InfoBox" )
	self:SetBlinkBelowRate( 0.05 )
	self:SetMinSize( 1 )
	self:SetMaxSize( 1 )
	self:SetSmallText( "" )
end

function ELEMENT:DrawFunction()
	if LocalPlayer():Alive() then
		self:FadeIn()
		self:SetRate( LocalPlayer():Health() / 100 )
		
		if (self:GetRate() > 0.25) then
			self:SetMainColor( "basecolor" )
		else
			self:SetMainColor( "badcolor" )
		end
		
		if (LocalPlayer():Health() ~= self.LastHealth) then
			self:SetGreatText( LocalPlayer():Health() )
			
			local accum = self.Theme:GetVolatileStorage("health_evolution") or 0
			local text = ""
			accum = accum + (LocalPlayer():Health() - self.LastHealth)
			self.stocolor = nil
			
			if (accum > 0) then
				self.stocolor = self.accumPositive
				text = "+" .. accum
			else
				self.stocolor = self.accumNegative
				text = "" .. accum
			end
			
			self:UpdateVolatile( "health_evolution", self.EVO_XREL ,self.EVO_YREL, text, self.stocolor, self.EVO_LAGMUL, self.EVO_FONT, self.EVO_DURATION, self.EVO_POWER, accum )
		end
		
		self.LastHealth = LocalPlayer():Health()
		
	elseif self:IsVisible() then
		self.LastHealth = 0
		
		self:SetGreatText( 0 )
		self:SetRate( 0 )
		self:FadeOut()
		
	end
	
	self:DoDraw()
	
	return true
end
