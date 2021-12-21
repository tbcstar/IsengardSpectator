ezSpectator_SpellIcon = {}
ezSpectator_SpellIcon.__index = ezSpectator_SpellIcon

function ezSpectator_SpellIcon:Create(Parent, ParentFrame, IsRightShift, ShiftFrame)
	local self = {}
	setmetatable(self, ezSpectator_SpellIcon)

	self.Parent = Parent

	self.FadeLock = 0.33
	
	self.Textures = ezSpectator_Textures:Create()
	self.ParentFrame = ParentFrame
	self.Texture = nil
	self.Spell = nil
	
	self.Normal = CreateFrame('Frame', nil, ParentFrame)
	self.Normal:SetFrameStrata('MEDIUM')
	self.Normal:SetSize(32, 32)
	self.Normal:SetScale(1)
	if IsRightShift then
		self.Normal:SetPoint('LEFT', ShiftFrame, 'RIGHT', -3, 0)
	else
		self.Normal:SetPoint('RIGHT', ShiftFrame, 'LEFT', 3, 0)
	end
	self.Textures:SpellIcon_Normal(self.Normal)
	
	self.Normal:SetAlpha(0)
	self.Normal.FadeStart = 0
	self.Normal.ElapsedTick = 0

	self.Normal:EnableMouse(true)
	self.Normal:SetScript('OnMouseUp', function()
		if self.Normal:GetAlpha() > 0 then
			self.Parent.Tooltip:ShowSpell(self.Normal, self.Spell)
		end
	end)
	self.Normal:SetScript('OnUpdate', function(self, Elapsed)
		self.ElapsedTick = self.ElapsedTick + Elapsed
		
		if self.ElapsedTick > 0.03 then
			self.ElapsedTick = 0
			
			if GetTime() > self.FadeStart then
				self:SetAlpha(self:GetAlpha() - 0.01)
			end
		end
	end)
	
	self.IconFrame = CreateFrame('Frame', nil, self.Normal)
	self.IconFrame:SetFrameStrata('LOW')
	self.IconFrame:SetSize(22, 22)
	self.IconFrame:SetScale(1)
	self.IconFrame:SetPoint('CENTER', self.Normal, 'CENTER', 0, 0)
	
	self.Icon = self.IconFrame:CreateTexture(nil, 'BORDER')
	self.Icon:SetAllPoints(self.IconFrame)
	self.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	
	return self
end



function ezSpectator_SpellIcon:SetTexture(Texture, Alpha, Spell)
	self.Spell = Spell
	self.Texture = Texture
	
	if Texture then
		self.Normal.FadeStart = GetTime() + self.FadeLock
		
		self.Normal:SetAlpha(Alpha)
		self.Icon:SetTexture(Texture)
	end
end