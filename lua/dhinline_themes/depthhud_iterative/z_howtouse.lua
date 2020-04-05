ELEMENT.Name = "##Menu Notice (Disable me !)"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 4
ELEMENT.SizeX = nil
ELEMENT.SizeY = -0.7

ELEMENT.SpinTimeInPersist = 0.5
ELEMENT.PersistTime = 30.0
ELEMENT.SafeTime = 4.0

ELEMENT.NeverDraw = false
ELEMENT.CalcTextd = false

function ELEMENT:Initialize()
	self.InitTime = RealTime()
	
	self:SetType( "InfoBox" )
	self:SetBlinkBelowRate( 1 )
	self:SetFalseColor( Color(0, 255, 0, 255) )
	
	self:SetGreatStyle( 1 )
	self:SetGreatText( "You are now using " .. self.Theme:GetDisplayName() .. " Theme, a beta duplicate of DepthHUD Classic." )
	self:SetSmallText( "Its main use is to reduce framerate loss. It is currently being worked on." )
end

function ELEMENT:DrawFunction()
	if self.NeverDraw then return end
	
	if RealTime() > (self.InitTime + self.SpinTimeInPersist) and RealTime() < (self.InitTime + self.PersistTime) then
		
		self:FadeIn()
		
		if not self.CalcTextd then
			local wB, hB = self:GetGreatSizes()
			local wS, hS = self:GetSmallSizes()
			local w = math.Max(wB,wS)
			self.SizeX = w + 44
			
			self.CalcTextd = true
		end
		
	else
		self:FadeOut()
		
	end
	
	self:DoDraw()
	
	if RealTime() > (self.InitTime + self.PersistTime + self.SafeTime) then
		self.NeverDraw = true
	end
	
	return true
end
