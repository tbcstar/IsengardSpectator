ezSpectator_CastFrame = {}
ezSpectator_CastFrame.__index = ezSpectator_CastFrame

--noinspection LuaOverlyLongMethod
function ezSpectator_CastFrame:Create(Parent, ...)
	local self = {}
	setmetatable(self, ezSpectator_CastFrame)

	self.Parent = Parent

	self.Textures = ezSpectator_Textures:Create()

	self.MainFrame = CreateFrame('Frame', nil, nil)

	self.Backdrop = CreateFrame('Frame', nil, self.MainFrame)
	self.Backdrop:SetFrameLevel(1)
	self.Backdrop:SetFrameStrata('BACKGROUND')
	self.Backdrop:SetSize(191, 24)
	self.Backdrop:SetScale(_ezSpectatorScale)
	self.Backdrop:SetPoint(...)
	self.Textures:CastFrame_Backdrop(self.Backdrop)
	
	self.Normal = CreateFrame('Frame', nil, self.MainFrame)
	self.Normal:SetFrameLevel(1)
	self.Normal:SetFrameStrata('LOW')
	self.Normal:SetSize(191, 24)
	self.Normal:SetScale(_ezSpectatorScale)
	self.Normal:SetPoint(...)
	self.Textures:CastFrame_Normal(self.Normal)
	
	self.Glow = CreateFrame('Frame', nil, self.MainFrame)
	self.Glow:SetFrameLevel(1)
	self.Glow:SetFrameStrata('TOOLTIP')
	self.Glow:SetSize(191, 24)
	self.Glow:SetScale(_ezSpectatorScale)
	self.Glow:SetPoint(...)
	self.Textures:CastFrame_Glow(self.Glow)
	
	self.CastBar = ezSpectator_CastBar:Create(self.Parent, self.MainFrame, 177, 11, _ezSpectatorScale, 'TOPLEFT', self.Normal, 'TOPLEFT', 7, -6)
	
	self.UpdateFrame = CreateFrame('Frame', nil, nil)
	self.UpdateFrame.CastBar = self.CastBar
	self.UpdateFrame.Glow = self.Glow
	self.UpdateFrame.Parent = self
	
	self.UpdateFrame.IsGlowRising = nil
	self.UpdateFrame.IsEnabled = false
	self.UpdateFrame.IsProgressMode = false
	self.UpdateFrame.ElapsedTick = 0
	self.UpdateFrame.ElapsedTotal = 0
	
	self.UpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
		if self.IsEnabled then
			self.ElapsedTick = self.ElapsedTick + Elapsed
			self.ElapsedTotal = self.ElapsedTotal + Elapsed
			
			if self.ElapsedTick > 0.03 then
				if self.IsProgressMode then
					self.IsEnabled = self.CastBar:SetValue(self.ElapsedTotal * 1000)
				end
				
				local GlowDelta = 0
				if self.IsGlowRising == true then
					GlowDelta = 0.075
				end
				
				if self.IsGlowRising == false then
					GlowDelta = -0.075
				end
				
				local GlowAlpha = self.Glow:GetAlpha()
				local NewGlowAlpha = GlowAlpha + GlowDelta
				
				if GlowAlpha >= 1 then
					GlowAlpha = 1
					self.IsGlowRising = false
				end
				if NewGlowAlpha < 0 then
					NewGlowAlpha = 0
					
					if not self.IsProgressMode then
						self.IsEnabled = false
						self.Parent:Hide()
					end
				end
				
				self.Glow:SetAlpha(NewGlowAlpha)
				
				self.ElapsedTick = 0
			end
		end
	end)
	
	self:Hide()
	return self
end



function ezSpectator_CastFrame:ShowCast(Spell, Time, Shift)
	local SpellName, _, _, _, _, _, CastTime = GetSpellInfo(Spell)
	
	if (CastTime > 0) and (Time > 0) then
		self.UpdateFrame.ElapsedTick = 0
		self.UpdateFrame.ElapsedTotal = Shift
		
		self.UpdateFrame.IsEnabled = true
		self.UpdateFrame.IsProgressMode = self.CastBar:SetCastType(Time, SpellName)
		if not self.UpdateFrame.IsProgressMode then
			local r, g, b = self.CastBar.ProgressBar.texture:GetVertexColor()
			
			self.UpdateFrame.IsGlowRising = true
			self.Glow.texture:SetVertexColor(r, g, b, 0.75)
			self.Glow:SetAlpha(0)
		end
		
		self:Show()
	end
end



function ezSpectator_CastFrame:Show()
	self.MainFrame:Show()
end



function ezSpectator_CastFrame:Hide()
	self.MainFrame:Hide()
end



function ezSpectator_CastFrame:SetAlpha(Value)
	self.MainFrame:SetAlpha(Value)
end