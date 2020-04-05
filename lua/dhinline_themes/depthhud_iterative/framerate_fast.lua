ELEMENT.Name = "Framerate (Fast)"
ELEMENT.DefaultOff = true
ELEMENT.DefaultGridPosX = 0
ELEMENT.DefaultGridPosY = 0
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.MaxFramerate = 100

ELEMENT.FPShi_table = {}
ELEMENT.FPShi_max   = 5 // Must be > 1
ELEMENT.FPShi_alphamin = 0.01
ELEMENT.FPShi_alphamax = 0.02


function ELEMENT:Initialize()
	self:SetType( "TextBox" )
	self:SetSmallText( "FPS" )
	
	for i=1,self.FPShi_max do
		self.FPShi_table[i] = 25
	end
end

function ELEMENT:DrawFunction()
	if not self:IsVisible() then self:FadeIn() end
	
	local framerate = (FrameTime() ~= 0) and math.ceil( 1 / FrameTime() ) or 0
	self:SetGreatText( framerate )
	
	self:DoDraw()
	
	return
end
