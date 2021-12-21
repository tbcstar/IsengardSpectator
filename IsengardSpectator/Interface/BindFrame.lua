ezSpectator_BindFrame = {}
ezSpectator_BindFrame.__index = ezSpectator_BindFrame

--noinspection LuaOverlyLongMethod
function ezSpectator_BindFrame:Create(Parent)
	local self = {}
	setmetatable(self, ezSpectator_BindFrame)

	self.Parent = Parent

	self.IsLocked = false
	
	self.Textures = ezSpectator_Textures:Create()
	
	self.Backdrop = CreateFrame('Frame', nil, nil)
	self.Backdrop:SetFrameLevel(1)
	self.Backdrop:SetFrameStrata('BACKGROUND')
	self.Backdrop:SetSize(192, 51)
	self.Backdrop:SetScale(_ezSpectatorScale)
	self.Backdrop:SetPoint('CENTER', 0, 0)
	self.Textures:SmallFrame_Backdrop(self.Backdrop)
	
	self.Normal = CreateFrame('Frame', nil, nil)
	self.Normal:SetFrameLevel(1)
	self.Normal:SetFrameStrata('LOW')
	self.Normal:SetSize(192, 51)
	self.Normal:SetScale(_ezSpectatorScale)
	self.Normal:SetPoint('CENTER', 0, 0)
	self.Textures:SmallFrame_Normal(self.Normal)
	
	self.Highlight = CreateFrame('Frame', nil, nil)
	self.Highlight:SetFrameLevel(1)
	self.Highlight:SetFrameStrata('LOW')
	self.Highlight:SetSize(192, 51)
	self.Highlight:SetScale(_ezSpectatorScale)
	self.Highlight:SetPoint('CENTER', 0, 0)
	self.Textures:SmallFrame_Highlight(self.Highlight)
	self.Highlight:Hide()
	
	self.Reactor = CreateFrame('Frame', nil, nil)
	self.Reactor:SetFrameStrata('TOOLTIP')
	self.Reactor:SetFrameLevel(1)
	self.Reactor:SetSize(192, 51)
	self.Reactor:SetScale(_ezSpectatorScale)
	self.Reactor:SetPoint('CENTER', 0, 0)
	
	self.Reactor:EnableMouse(true)
	self.Reactor:SetScript('OnEnter', function()
		if self.Backdrop:IsShown() then
			self.Normal:Hide()
			self.Highlight:Show()
		end
	end)
	self.Reactor:SetScript('OnLeave', function()
		if self.Backdrop:IsShown() then
			self.Highlight:Hide()
			self.Normal:Show()
		end
	end)
	
	self.HealthBar = ezSpectator_HealthBar:Create(self.Parent, true, true, 10 * _ezSpectatorScale, 177, 26, _ezSpectatorScale, 'TOPLEFT', self.Normal, 'TOPLEFT', 7, -6)
	
	self.PowerBar = ezSpectator_PowerBar:Create(self.Parent, 177, 9, _ezSpectatorScale, 'TOPLEFT', self.Normal, 'TOPLEFT', 7, -36)
	
	self.CastFrame = ezSpectator_CastFrame:Create(self.Parent, 'TOPLEFT', self.Normal, 'BOTTOMLEFT', 0, 5)
	
	self.AuraFrame = ezSpectator_AuraFrame:Create(self.Parent, false, 'BOTTOMLEFT', self.Normal, 'TOPLEFT', 8, 27 * _ezSpectatorScale)
	
	self.SpellFrame = nil
	
	self.TrinketIcon = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'silver', 28, 'BOTTOMLEFT', self.Normal, 'TOPLEFT', 2, -4)
	self.TrinketIcon:SetTexture('Interface\\Icons\\INV_Jewelry_TrinketPVP_02', 17, true)
	
	self.ControlIcon = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'silver', 28, 'LEFT', self.TrinketIcon.Normal, 'RIGHT', -3, 0)
	
	self.SpecIcon = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'silver', 28, 'LEFT', self.ControlIcon.Normal, 'RIGHT', -3, 0)
	
	return self
end



function ezSpectator_BindFrame:Hide()
	self.Backdrop:Hide()
	self.Normal:Hide()
	self.Highlight:Hide()
	self.HealthBar:Hide()
	self.PowerBar:Hide()
	self.CastFrame:Hide()
	self.Reactor:Hide()
	self.AuraFrame:Hide()
	self.TrinketIcon:Hide()
	self.ControlIcon:Hide()
	self.SpecIcon:Hide()
	
	if self.SpellFrame then
		self.SpellFrame:Hide()
	end
end



function ezSpectator_BindFrame:Show()
	self.Backdrop:Show()
	self.Normal:Show()
	self.Highlight:Hide()
	self.HealthBar:Show()
	self.PowerBar:Show()
	self.Reactor:Show()
	self.AuraFrame:Show()
	self.TrinketIcon:Show()
	self.ControlIcon:Show()
	self.SpecIcon:Show()
	
	if self.SpellFrame then
		self.SpellFrame:Show()
	end
end



function ezSpectator_BindFrame:IsShown()
	return self.Backdrop:IsShown()
end



function ezSpectator_BindFrame:SetPoint(...)
	self.Backdrop:SetPoint(...)
	self.Normal:SetPoint(...)
	self.Highlight:SetPoint(...)
	self.Reactor:SetPoint(...)
end



function ezSpectator_BindFrame:ClearAllPoints()
	self.Backdrop:ClearAllPoints()
	self.Normal:ClearAllPoints()
	self.Highlight:ClearAllPoints()
	self.Reactor:ClearAllPoints()
end



function ezSpectator_BindFrame:SetAlpha(Value)
	self.Backdrop:SetAlpha(Value)
	self.Normal:SetAlpha(Value)
	self.Highlight:SetAlpha(Value)
	self.HealthBar:SetAlpha(Value)
	self.PowerBar:SetAlpha(Value)
	self.TrinketIcon:SetAlpha(Value)
	self.ControlIcon:SetAlpha(Value)
	self.SpecIcon:SetAlpha(Value)
end