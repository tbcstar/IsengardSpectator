ezSpectator_TeamFrame = {}
ezSpectator_TeamFrame.__index = ezSpectator_TeamFrame

function ezSpectator_TeamFrame:Create(Parent, IsLeft, ...)
	local self = {}
	setmetatable(self, ezSpectator_TeamFrame)

	IsLeft = not IsLeft

	self.Parent = Parent

	self.Textures = ezSpectator_Textures:Create()
	
	self.Normal = CreateFrame('Frame', nil, nil)
	self.Normal:SetFrameStrata('LOW')
	self.Normal:SetSize(482, 44)
	self.Normal:SetScale(0.75 * _ezSpectatorScale)
	self.Normal:SetPoint(...)
	self.Textures:TeamFrame_Normal(self.Normal)
	
	self.HealthBar = ezSpectator_HealthBar:Create(self.Parent, IsLeft, false, 12 * _ezSpectatorScale, 462, 24, 0.75 * _ezSpectatorScale, 'TOPLEFT', self.Normal, 'TOPLEFT', 10, -9)
	self.SpellCooldown = ezSpectator_CooldownFrame:Create(self.Parent, self.Normal, IsLeft)

	return self
end



function ezSpectator_TeamFrame:Hide()
	self.Normal:Hide()
	self.HealthBar:Hide()
	self.SpellCooldown:Hide()
end



function ezSpectator_TeamFrame:Show()
	self.Normal:Show()
	self.HealthBar:Show()
	self.SpellCooldown:Show()
end



function ezSpectator_TeamFrame:SetName(Value)
	self.HealthBar:SetNickname(Value)
end



function ezSpectator_TeamFrame:SetColor(Value)
	if Value == 'gold' then
		self.HealthBar.Backdrop.texture:SetVertexColor(0.9, 0.9, 0)
		self.HealthBar.ProgressBar.texture:SetVertexColor(0.9, 0.9, 0)
		self.HealthBar.Spark.texture:SetVertexColor(0.9, 0.9, 0)
	else
		self.HealthBar.Backdrop.texture:SetVertexColor(0, 0.75, 0)
		self.HealthBar.ProgressBar.texture:SetVertexColor(0, 0.75, 0)
		self.HealthBar.Spark.texture:SetVertexColor(0, 0.75, 0)
	end
end



function ezSpectator_TeamFrame:SetScore(Value)
	self.HealthBar:SetDescription(Value)
end



function ezSpectator_TeamFrame:SetCooldown(Nickname, Spell, Value)
	self.SpellCooldown:Push(Nickname, Spell, Value)
end