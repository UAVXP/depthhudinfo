ELEMENT.Name = "Target Information"
ELEMENT.DefaultOff = true
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 10
ELEMENT.SizeX = 0
ELEMENT.SizeY = -0.7

ELEMENT.LastTimeStored = 0
ELEMENT.PersistTime    = 1.0
ELEMENT.FadeOutTime    = 1.5


ELEMENT.TraceDelay    = 0.05
ELEMENT.LastTimeQueried = 0

ELEMENT.MyTraceData = {}
ELEMENT.MyTraceData.filter = {}
ELEMENT.MyTraceRes = {}

function ELEMENT:Initialize()
	self:CreateSmoother("width", 0, 0.7)
	self:CreateSmoother("health", 1, 0.2)

	self:SetType( "InfoBox" )
	self:SetGreatStyle( 1 )
	self:SetMinSize( 0.5 )
	self:SetUsingStaticColor( true )
end

function ELEMENT:DrawFunction()
	local found = false
	local blinkSize = -1

	if (CurTime() > (self.LastTimeQueried + self.TraceDelay)) then
		self.MyTraceData = util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetAimVector() )
		self.MyTraceData.filter[1] = LocalPlayer():GetVehicle()
		self.MyTraceData.filter[2] = LocalPlayer()

		self.MyTraceRes = util.TraceLine( self.MyTraceData )

		if (self.MyTraceRes.Hit) and (self.MyTraceRes.HitNonWorld) and IsValid(self.MyTraceRes.Entity) and (self.MyTraceRes.Entity ~= LocalPlayer()) then
			local name = ""
			local sub = ""
			local HitEntity = self.MyTraceRes.Entity

			if (HitEntity:IsPlayer()) then
				name = HitEntity:Nick()
				if (HitEntity.dhradar_communitycolor) then
					self:SetMainColor( HitEntity.dhradar_communitycolor )
					self:SetTrueColor( HitEntity.dhradar_communitycolor )

				else
					self:SetMainColor( team.GetColor(HitEntity:Team()) )
					self:SetTrueColor( team.GetColor(HitEntity:Team()) )

				end

				self:ChangeSmootherTarget("health", math.Clamp(HitEntity:Health() / 100, 0, 1))

				sub = "Player"
				if not self.overteams then self.overteams = ((team.GetAllTeams ~= nil) and (table.Count(team.GetAllTeams()) > 3)) end
				if self.overteams then
					sub = sub .. " (" .. team.GetName(HitEntity:Team()) .. ")"

				end

			else
				name = HitEntity:GetClass()
				self:SetMainColor( nil )
				self:SetTrueColor( nil )

				if HitEntity:IsNPC() then
					sub = "NPC"
					self:ChangeSmootherTarget("health", math.Clamp(HitEntity:Health() / 100, 0, 1))

				else
					if string.Right(HitEntity:GetModel() , 4) == ".mdl" then
						local parts = string.Explode("/", HitEntity:GetModel() )
						sub = dhinline.StringNiceNameTransform( string.Left(parts[#parts] , -5) )
					else
						if (string.Left(HitEntity:GetClass(),4) == "prop") then
							sub = "Prop"
						elseif (string.Left(HitEntity:GetClass(),4) == "func") then
							sub = "World Entity"
						else
							sub = "Entity"
						end
					end

					self:ChangeSmootherTarget("health", 1)
				end

			end

			name = dhinline.StringNiceNameTransform( name )
			self:SetGreatText( name )
			self:SetSmallText( sub )


			local wB, hB = self:GetGreatSizes()
			local wS, hS = self:GetSmallSizes()
			local w = math.Max(wB, wS)

			self:ChangeSmootherTarget("width", 44 + w)
			self:ChangeSmootherRate("width", 0.6)

			found = true
			self.LastTimeStored = CurTime()
		end

		self.LastTimeQueried = CurTime()
	end

	if self:IsVisible() and (self:GetGreatText() ~= "") and (not found) and ((CurTime() - self.LastTimeStored) > self.PersistTime) then
		self:SetGreatText( "" )
		self:SetSmallText( "" )
		self:SetMainColor( nil )
		self:SetTrueColor( nil )
		self:ChangeSmootherTarget("health", 1)

		local mX,mY = self:GetMySizes()

		self:ChangeSmootherTarget("width", mY)
		self:ChangeSmootherRate("width", 0.2)
	end

	self.SizeX = self:GetSmootherCurrent("width")

	if self:ShouldDraw() then
		self:SetRate( self:GetSmootherCurrent("health") )

		local alphaMod = ( 1 - ((CurTime() - self.LastTimeStored) / self.PersistTime)^8 )
		self:SetAlphaMods(alphaMod, alphaMod)
	end

	if ((CurTime() - self.LastTimeStored) > self.FadeOutTime) then
		self:FadeOut()

	else
		self:FadeIn()

	end

	self:DoDraw()

	return
end
