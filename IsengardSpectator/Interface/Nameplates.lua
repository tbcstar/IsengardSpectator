ezSpectator_Nameplates = {}
ezSpectator_Nameplates.__index = ezSpectator_Nameplates

function ezSpectator_Nameplates:Create(Parent)
	local self = {}
	setmetatable(self, ezSpectator_Nameplates)
	
	self.Parent = Parent
	
	self.ChildrensChecked = -1
	self.EventFrame = CreateFrame('Frame')
	
	self.EventFrame.Parent = self
	self.EventFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
	self.EventFrame:SetScript('OnEvent', self.EventHandler)
	self.EventFrame:SetScript('OnUpdate', function(self)
		if WorldFrame:GetNumChildren() ~= self.Parent.ChildrensChecked then
			self.Parent.ChildrensChecked = WorldFrame:GetNumChildren()
			self.Parent:ApplyHook(WorldFrame:GetChildren())
		end
	end)

	return self
end



function ezSpectator_Nameplates:EventHandler(Event)
	if Event == 'PLAYER_ENTERING_WORLD' then
		self.ChildrensChecked = -1
	end
end



function ezSpectator_Nameplates:EncodeTexCoord(Texture)
	local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = Texture:GetTexCoord()

	Texture.OriginalTexCoord = {}
	Texture.OriginalTexCoord.ULx = ULx
	Texture.OriginalTexCoord.ULy = ULy
	Texture.OriginalTexCoord.LLx = LLx
	Texture.OriginalTexCoord.LLy = LLy
	Texture.OriginalTexCoord.URx = URx
	Texture.OriginalTexCoord.URy = URy
	Texture.OriginalTexCoord.LRx = LRx
	Texture.OriginalTexCoord.LRy = LRy
end



function ezSpectator_Nameplates:DecodeTexCoord(Texture)
	return
		Texture.OriginalTexCoord.ULx,
		Texture.OriginalTexCoord.ULy,
		Texture.OriginalTexCoord.LLx,
		Texture.OriginalTexCoord.LLy,
		Texture.OriginalTexCoord.URx,
		Texture.OriginalTexCoord.URy,
		Texture.OriginalTexCoord.LRx,
		Texture.OriginalTexCoord.LRy
end



--noinspection UnusedDef
function ezSpectator_Nameplates:SaveOriginalNameplate(Healthbar, ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon)
	Healthbar.OriginalStatusBarTexture = Healthbar:GetStatusBarTexture():GetTexture()
	Healthbar.CastbarObject.OriginalStatusBarTexture = Healthbar.CastbarObject:GetStatusBarTexture():GetTexture()
	self:EncodeTexCoord(ThreatGlow)
	self:EncodeTexCoord(HealthBorder)
	self:EncodeTexCoord(CastBorder)
	self:EncodeTexCoord(CastUninterruptible)
	self:EncodeTexCoord(HighlightTexture)
	self:EncodeTexCoord(MobIcon)
	BossIcon.OriginalAlpha = BossIcon:GetAlpha()
	RaidIcon.OriginalAlpha = RaidIcon:GetAlpha()
	SpellIcon.OriginalWidth = SpellIcon:GetWidth()
end



function ezSpectator_Nameplates:HideOriginalNameplate(Healthbar, ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon)
	Healthbar:SetStatusBarTexture(EMPTY_TEXTURE)
	Healthbar.CastbarObject:SetStatusBarTexture(EMPTY_TEXTURE)
	ThreatGlow:SetTexCoord(0, 0, 0, 0)
	HealthBorder:SetTexCoord(0, 0, 0, 0)
	CastBorder:SetTexCoord(0, 0, 0, 0)
	CastUninterruptible:SetTexCoord(0, 0, 0, 0)
	HighlightTexture:SetTexCoord(0, 0, 0, 0)
	MobIcon:SetTexCoord(0, 0, 0, 0)
	NameText:SetWidth(0.001)
	LevelText:SetWidth(0.001)
	BossIcon:SetAlpha(0)
	RaidIcon:SetAlpha(0)
	SpellIcon:SetWidth(0.001)
	
	Healthbar.IsHidden = true
end



function ezSpectator_Nameplates:ShowOriginalNameplate(Healthbar, ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon)
	Healthbar:SetStatusBarTexture(Healthbar.OriginalStatusBarTexture)
	Healthbar.CastbarObject:SetStatusBarTexture(Healthbar.CastbarObject.OriginalStatusBarTexture)
	ThreatGlow:SetTexCoord(self:DecodeTexCoord(ThreatGlow))
	HealthBorder:SetTexCoord(self:DecodeTexCoord(HealthBorder))
	CastBorder:SetTexCoord(self:DecodeTexCoord(CastBorder))
	CastUninterruptible:SetTexCoord(self:DecodeTexCoord(CastUninterruptible))
	HighlightTexture:SetTexCoord(self:DecodeTexCoord(HighlightTexture))
	MobIcon:SetTexCoord(self:DecodeTexCoord(MobIcon))
	NameText:SetWidth(0)
	LevelText:SetWidth(0)
	BossIcon:SetAlpha(BossIcon.OriginalAlpha)
	RaidIcon:SetAlpha(RaidIcon.OriginalAlpha)
	SpellIcon:SetWidth(SpellIcon.OriginalWidth)

	HealthBorder.ezSpectator_Nameplate:Hide()
	Healthbar.IsHidden = false
end



function ezSpectator_Nameplates:ProcessNameplate(SkipAnimation, Healthbar, ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon)
	if self.Parent.Interface.IsRunning then
		if not Healthbar.IsHidden then
			self:SaveOriginalNameplate(Healthbar, ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon)
			self:HideOriginalNameplate(Healthbar, ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon)
		end

		if not HealthBorder.ezSpectator_Nameplate then
			HealthBorder.ezSpectator_Nameplate = ezSpectator_Nameplate:Create(self.Parent, Healthbar, 'BOTTOM', HealthBorder, 'BOTTOM', 0, 10)
		else
			HealthBorder.ezSpectator_Nameplate:Show()
		end

		local MaxValue = select(2, Healthbar:GetMinMaxValues())
		HealthBorder.ezSpectator_Nameplate:SetMaxValue(MaxValue)

		local Value = Healthbar:GetValue()

		if not SkipAnimation then
			SkipAnimation = HealthBorder.ezSpectator_Nameplate.IsUpdating
			HealthBorder.ezSpectator_Nameplate.IsUpdating = false
		else
			HealthBorder.ezSpectator_Nameplate.IsUpdating = true
		end

		if SkipAnimation then
			HealthBorder.ezSpectator_Nameplate:ResetAnimation()
		end
		HealthBorder.ezSpectator_Nameplate:SetValue(Value, SkipAnimation)

		HealthBorder.ezSpectator_Nameplate:SetNickname(NameText:GetText())
		if self.Parent.Interface.Players[NameText:GetText()] then
			HealthBorder.ezSpectator_Nameplate:SetTeam(self.Parent.Interface.Players[NameText:GetText()].Team)
			HealthBorder.ezSpectator_Nameplate:SetClass(self.Parent.Interface.Players[NameText:GetText()].Class)

			self.Parent.Interface.Players[NameText:GetText()]:SetNameplate(HealthBorder.ezSpectator_Nameplate)
			HealthBorder.ezSpectator_Nameplate:SetPlayer(self.Parent.Interface.Players[NameText:GetText()])
		else
			HealthBorder.ezSpectator_Nameplate:SetTeam(nil)
			HealthBorder.ezSpectator_Nameplate:SetClass(nil)
			HealthBorder.ezSpectator_Nameplate:SetPlayer(nil)
		end

		if self.Parent.Interface.Viewpoint then
			if self.Parent.Interface.Viewpoint.CurrentTarget and
					(HealthBorder.ezSpectator_Nameplate.Nickname:GetText() == self.Parent.Interface.Viewpoint.CurrentTarget.Nickname)
			then
				HealthBorder.ezSpectator_Nameplate:SetAlpha(1)
				HealthBorder.ezSpectator_Nameplate.IsTarget = true
			else
				HealthBorder.ezSpectator_Nameplate:SetAlpha(self.Parent.Data.ViewpointNameplateAlpha)
				HealthBorder.ezSpectator_Nameplate.IsTarget = false
			end
		else
			HealthBorder.ezSpectator_Nameplate:SetAlpha(1)
			HealthBorder.ezSpectator_Nameplate.IsTarget = false
		end
	else
		if Healthbar.IsHidden then
			self:ShowOriginalNameplate(Healthbar, ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon)
		end
	end
end



function ezSpectator_Nameplates:OnShowHook(Healthbar)
	local ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon = Healthbar:GetParent():GetRegions()
	
	self:ProcessNameplate(true, Healthbar, ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon)
end



function ezSpectator_Nameplates:OnUpdateHook(Healthbar)
	local ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon = Healthbar:GetParent():GetRegions()
	
	self:ProcessNameplate(false, Healthbar, ThreatGlow, HealthBorder, CastBorder, CastUninterruptible, SpellIcon, HighlightTexture, NameText, LevelText, BossIcon, RaidIcon, MobIcon)
end



function ezSpectator_Nameplates:ApplyHook(...)
	for FrameLoop = 1, select('#', ...) do
		local CurrentFrame = select(FrameLoop, ...)
		local CurrentRegion = CurrentFrame:GetRegions()
		
		if CurrentRegion and (CurrentRegion:GetObjectType() == 'Texture') and (CurrentRegion:GetTexture() == 'Interface\\TargetingFrame\\UI-TargetingFrame-Flash') then
			local Healthbar, Castbar = CurrentFrame:GetChildren()
			Healthbar.CastbarObject = Castbar

			Healthbar.ezSpectator_Nameplates = self
			Healthbar:HookScript('OnShow', function(Frame)
				if Frame.ezSpectator_Nameplates then
					Frame.ezSpectator_Nameplates:OnShowHook(Frame)
				end
			end)
			Healthbar:SetScript('OnUpdate', function(Frame)
				if Frame.ezSpectator_Nameplates then
					Frame.ezSpectator_Nameplates:OnUpdateHook(Frame)
				end
			end)
			self:OnUpdateHook(Healthbar)
		end
	end
end