ezSpectator_TargetFrame = {}
ezSpectator_TargetFrame.__index = ezSpectator_TargetFrame

function ezSpectator_TargetFrame:Create(Parent, ...)
	local self = {}
	setmetatable(self, ezSpectator_TargetFrame)

	self.Parent = Parent

	self.Unit = nil
	
	self.Textures = ezSpectator_Textures:Create()
	
	self.Backdrop = CreateFrame('Frame', nil, nil)
	self.Backdrop:SetFrameLevel(1)
	self.Backdrop:SetFrameStrata('BACKGROUND')
	self.Backdrop:SetSize(224, 58)
	self.Backdrop:SetScale(0.5 * _ezSpectatorScale)
	self.Backdrop:SetPoint(...)
	self.Textures:TargetFrame_Backdrop(self.Backdrop)
	
	self.Normal = CreateFrame('Frame', nil, nil)
	self.Normal:SetFrameLevel(1)
	self.Normal:SetFrameStrata('LOW')
	self.Normal:SetSize(224, 58)
	self.Normal:SetScale(0.5 * _ezSpectatorScale)
	self.Normal:SetPoint(...)
	self.Textures:TargetFrame_Normal(self.Normal)
	
	self.HealthBar = ezSpectator_HealthBar:Create(self.Parent, false, false, 8 * 1, 103, 18,  _ezSpectatorScale, 'TOPLEFT', self.Normal, 'TOPLEFT', 4, -5)
	
	return self
end



function ezSpectator_TargetFrame:Hide()
	self.Backdrop:Hide()
	self.Normal:Hide()
	self.HealthBar:Hide()
end



function ezSpectator_TargetFrame:Show()
	if self.Unit then
		self.Backdrop:Show()
		self.Normal:Show()
		self.HealthBar:Show()
	end
end



function ezSpectator_TargetFrame:SetAlpha(Value)
	self.Backdrop:SetAlpha(Value)
	self.Normal:SetAlpha(Value)
	self.HealthBar:SetAlpha(Value)
end



function ezSpectator_TargetFrame:SetUnit(Value)
	if self.Parent.Interface.Viewpoint then
		if self.Unit and not self.Unit.IsDead and (self.Unit ~= self.Parent.Interface.Viewpoint) then
			self.Unit.SmallFrame:SetAlpha(1)
		end
	end

	self.Unit = Value
	self.HealthBar:ResetAnimation()
	self:Update(true)
end



function ezSpectator_TargetFrame:Update(LockAnimation)
	if self.Parent.Interface.Viewpoint and self.Parent.Interface.Viewpoint.CurrentTarget and self.Parent.Interface.IsRunning then
		self.Parent.Interface.Viewpoint.CurrentTarget.SmallFrame:SetAlpha(self.Parent.Data.ViewpointAlpha)
	end

	if self.Unit and self.Unit:IsReady() then
		self.HealthBar:SetNickname(self.Unit.Nickname)
		self.HealthBar:SetClass(self.Unit.Class)
		self.HealthBar:SetMaxValue(self.Unit.MaxHealth)
		self.HealthBar:SetValue(self.Unit.Health, LockAnimation)
		self:Show()
	else
		self:Hide()
	end
end