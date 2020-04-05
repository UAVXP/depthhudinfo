ELEMENT.Name = "Compass"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 1
ELEMENT.SizeX = -2.0
ELEMENT.SizeY = -0.75

ELEMENT.colorXcoords = Color(255,0,0,42)
ELEMENT.colorYcoords = Color(0,255,0,42)
ELEMENT.EyeAng = nil
ELEMENT.yaw = nil

ELEMENT.baseColor = ELEMENT.Theme:GetColorReference("basecolor")

ELEMENT.tvars = {}
ELEMENT.pointsCard = {
	[0] = "N",
	[45] = "NE",
	[90] = "E",
	[135] = "SE",
	[180] = "S",
	[225] = "SW",
	[270] = "W",
	[315] = "NW",
}
ELEMENT.pointsSmall = {
	[0] = "Y+",
	[45] = "|",
	[90] = "X+",
	[135] = "|",
	[180] = "Y-",
	[225] = "|",
	[270] = "X-",
	[315] = "|",
}
ELEMENT.pointsSmallColor = {
	[0]   = ELEMENT.colorYcoords,
	[90]  = ELEMENT.colorXcoords,
	[180] = ELEMENT.colorYcoords,
	[270] = ELEMENT.colorXcoords
}

function ELEMENT:Initialize()
	self:SetType( "BlankBox" )
	self:SetGreatStyle( 2 )

	for i = 0,359,15 do
		if not self.pointsCard[i] then
			self.pointsCard[i] = "."
		end
	end
end

function ELEMENT:DrawFunction()
	if not self:IsVisible() then self:FadeIn() end
	
	
	self.EyeAng = EyeAngles()
	self.yaw = self.EyeAng.y
	
	self:DoDraw()
	
	for k,text in pairs(self.pointsCard) do
		local myReferal = (self.yaw + k) / 180 * math.pi
		local myXEquirel = math.sin(myReferal)
		if myXEquirel > 0 then
			local myYEquirel = math.cos(myReferal)
			local myAlphaAlter = (1 - (1 - myXEquirel ^ 2) )

			local myTextSmall = ""
			local altColor = nil
			-- Small compass stands
			if (self.pointsSmall[k]) then
				if self.pointsSmallColor[k] then
					altColor = self.pointsSmallColor[k]
					
				end
					
				myTextSmall = self.pointsSmall[k]
			
			else
				myTextSmall = ""
			end
			self:DrawImmediateText(
				text, myTextSmall,
				nil, altColor,
				myYEquirel * 0.9,   --xE
				-0.3, 				--yE
				myAlphaAlter,		--mmod
				myAlphaAlter,		--amod
				myXEquirel * 0.2	--lag	
			)
		end
	end
	
	return
end
