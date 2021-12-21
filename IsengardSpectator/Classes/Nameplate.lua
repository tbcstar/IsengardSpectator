ezSpectator_Nameplate = {}
ezSpectator_Nameplate.__index = ezSpectator_Nameplate

--noinspection LuaOverlyLongMethod
function ezSpectator_Nameplate:Create(Parent, ParentFrame, Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	local self = {}
	setmetatable(self, ezSpectator_Nameplate)

	self.Parent = Parent
	self.PlayerWorker = nil
    self.IsPlayerStyle = nil

	self.AnimationStartSpeed = 0
	self.AnimationProgress = 10
	self.IsLayerAnimated = true
	self.IsSparkAnimated = false
		self.IsSparkSmoothMode = false
	
	self.CurrentValue = nil
	self.TargetValue = 0
	
	self.Scale = 0.75 * _ezSpectatorScale
	self.SecondaryScale = 0.50 * _ezSpectatorScale
	self.ParentFrame = ParentFrame
	self.Textures = ezSpectator_Textures:Create()
	
	self.Width = 128
	self.Height = 12
	self.CastSize = 36

	self.IsCastFree = true

	self.MainFrame = CreateFrame('Frame', nil, ParentFrame)
	self.MainFrame:SetSize(1, 1)
	self.MainFrame:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)

	self.HealthBar = CreateFrame('Frame', nil, self.MainFrame)
	self.HealthBar:SetFrameLevel(4 + self.Parent.Data.NamePlateLevel)
	self.HealthBar:SetFrameStrata('BACKGROUND')
	self.HealthBar:SetSize(self.Width, self.Height)
	self.HealthBar:SetScale(self.Scale)
	self.Textures:Nameplate_Normal(self.HealthBar)

	self.HealthBar.Backdrop = CreateFrame('Frame', nil, self.HealthBar)
	self.HealthBar.Backdrop:SetFrameLevel(2 + self.Parent.Data.NamePlateLevel)
	self.HealthBar.Backdrop:SetFrameStrata('BACKGROUND')
	self.HealthBar.Backdrop:SetSize(self.Width, self.Height)
	self.HealthBar.Backdrop:SetPoint('TOPLEFT', self.HealthBar, 'TOPLEFT', 0, 0)
	self.Textures:Nameplate_Backdrop(self.HealthBar.Backdrop)

	self.HealthBar.Glow = CreateFrame('Frame', nil, self.HealthBar)
	self.HealthBar.Glow:SetFrameLevel(1 + self.Parent.Data.NamePlateLevel)
	self.HealthBar.Glow:SetFrameStrata('BACKGROUND')
	self.HealthBar.Glow:SetSize(self.Width + 14, self.Height + 14)
	self.HealthBar.Glow:SetPoint('TOPLEFT', self.HealthBar.Backdrop, 'TOPLEFT', -6, 6)
	self.Textures:Nameplate_Glow(self.HealthBar.Glow)
	self.HealthBar.Glow.texture:SetVertexColor(0.2, 0.2, 0.2, 0)

	if self.IsLayerAnimated then
		self.HealthBar.AnimationDownBar = CreateFrame('Frame', nil, self.HealthBar)
		self.HealthBar.AnimationDownBar:SetFrameLevel(3 + self.Parent.Data.NamePlateLevel)
		self.HealthBar.AnimationDownBar:SetFrameStrata('BACKGROUND')
		self.HealthBar.AnimationDownBar:SetSize(0, self.Height)
		self.HealthBar.AnimationDownBar:SetPoint('TOPLEFT', self.HealthBar, 'TOPLEFT', 0, 0)
		self.Textures:HealthBar_Normal(self.HealthBar.AnimationDownBar)
		self.HealthBar.AnimationDownBar.texture:SetVertexColor(1, 0, 0)
		
		self.HealthBar.AnimationUpBar = CreateFrame('Frame', nil, self.HealthBar)
		self.HealthBar.AnimationUpBar:SetFrameLevel(3 + self.Parent.Data.NamePlateLevel)
		self.HealthBar.AnimationUpBar:SetFrameStrata('BACKGROUND')
		self.HealthBar.AnimationUpBar:SetSize(0, self.Height)
        self.HealthBar.AnimationUpBar:SetPoint('TOPLEFT', self.HealthBar, 'TOPLEFT', 0, 0)
		self.Textures:HealthBar_Normal(self.HealthBar.AnimationUpBar)
		self.HealthBar.AnimationUpBar.texture:SetVertexColor(0, 1, 0)
	end
	
	self.HealthBar.Overlay = CreateFrame('Frame', nil, self.HealthBar)
	self.HealthBar.Overlay:SetFrameLevel(6 + self.Parent.Data.NamePlateLevel)
	self.HealthBar.Overlay:SetFrameStrata('BACKGROUND')
	self.HealthBar.Overlay:SetSize(self.Width, self.Height)
	self.HealthBar.Overlay:SetPoint('TOPLEFT', self.HealthBar, 'TOPLEFT', 0, 0)
	self.Textures:Nameplate_Overlay(self.HealthBar.Overlay)
	
	self.HealthBar.Effect = CreateFrame('Frame', nil, self.HealthBar)
	self.HealthBar.Effect:SetFrameLevel(7 + self.Parent.Data.NamePlateLevel)
	self.HealthBar.Effect:SetFrameStrata('BACKGROUND')
	self.HealthBar.Effect:SetSize(self.Width, self.Height)
	self.HealthBar.Effect:SetPoint('TOPLEFT', self.HealthBar, 'TOPLEFT', 0, 0)
	self.Textures:Nameplate_Effect(self.HealthBar.Effect)
	self.HealthBar.Effect.texture:SetVertexColor(1, 0, 0)

	self.CastBar = CreateFrame('Frame', nil, self.MainFrame)
	self.CastBar:SetFrameLevel(4 + self.Parent.Data.NamePlateLevel)
	self.CastBar:SetFrameStrata('BACKGROUND')
	self.CastBar:SetSize(self.Width, self.Height)
	self.CastBar:SetScale(self.Scale)
	self.CastBar:SetPoint('TOPLEFT', self.HealthBar, 0, -self.Height - 3)
	self.Textures:Nameplate_Normal(self.CastBar)
	self.CastBar.texture:SetVertexColor(0, 1, 1)
	self.CastBar:Hide()

	self.CastBar.Backdrop = CreateFrame('Frame', nil, self.CastBar)
	self.CastBar.Backdrop:SetFrameLevel(2 + self.Parent.Data.NamePlateLevel)
	self.CastBar.Backdrop:SetFrameStrata('BACKGROUND')
	self.CastBar.Backdrop:SetSize(self.Width, self.Height)
	self.CastBar.Backdrop:SetPoint('TOPLEFT', self.CastBar, 'TOPLEFT', 0, 0)
	self.Textures:Nameplate_Backdrop(self.CastBar.Backdrop)

	self.CastBar.Glow = CreateFrame('Frame', nil, self.CastBar)
	self.CastBar.Glow:SetFrameLevel(1 + self.Parent.Data.NamePlateLevel)
	self.CastBar.Glow:SetFrameStrata('BACKGROUND')
	self.CastBar.Glow:SetSize(self.Width + 14, self.Height + 14)
	self.CastBar.Glow:SetPoint('TOPLEFT', self.CastBar.Backdrop, 'TOPLEFT', -6, 6)
	self.Textures:Nameplate_Glow(self.CastBar.Glow)
	self.CastBar.Glow:SetAlpha(0)

	self.CastBar.Overlay = CreateFrame('Frame', nil, self.CastBar)
	self.CastBar.Overlay:SetFrameLevel(6 + self.Parent.Data.NamePlateLevel)
	self.CastBar.Overlay:SetFrameStrata('BACKGROUND')
	self.CastBar.Overlay:SetSize(self.Width, self.Height)
	self.CastBar.Overlay:SetPoint('TOPLEFT', self.CastBar, 'TOPLEFT', 0, 0)
	self.Textures:Nameplate_Overlay(self.CastBar.Overlay)

	self.CastBar.Effect = CreateFrame('Frame', nil, self.CastBar)
	self.CastBar.Effect:SetFrameLevel(7 + self.Parent.Data.NamePlateLevel)
	self.CastBar.Effect:SetFrameStrata('BACKGROUND')
	self.CastBar.Effect:SetSize(self.Width, self.Height)
	self.CastBar.Effect:SetPoint('TOPLEFT', self.CastBar, 'TOPLEFT', 0, 0)
	self.Textures:Nameplate_Effect(self.CastBar.Effect)

	self.Castborder = CreateFrame('Frame', nil, self.MainFrame)
	self.Castborder:SetFrameLevel(2 + self.Parent.Data.NamePlateLevel)
	self.Castborder:SetFrameStrata('BACKGROUND')
	self.Castborder:SetSize(self.CastSize, self.CastSize)
	self.Castborder:SetScale(self.Scale)
	self.Castborder:SetPoint('RIGHT', self.HealthBar, 'LEFT', 2, -8)
	self.Textures:Nameplate_Castborder(self.Castborder)

	self.Icon = ezSpectator_ClickIcon:Create(self.Parent, self.Castborder, 'clear', self.CastSize, 'CENTER', -1, 1)
	self.Icon.Icon:SetFrameLevel(1 + self.Parent.Data.NamePlateLevel)
	self.Icon.Icon:SetFrameStrata('BACKGROUND')

	self.HealerIcon = ezSpectator_ClickIcon:Create(self.Parent, self.Castborder, 'clear', self.CastSize, 'CENTER', 10, 11)
	self.HealerIcon.Icon:SetFrameLevel(8 + self.Parent.Data.NamePlateLevel)
	self.HealerIcon.Icon:SetFrameStrata('BACKGROUND')
	self.HealerIcon:SetIcon('Plus')
	self.HealerIcon.Icon.texture:SetVertexColor(0, 1, 0, 1)
	self.HealerIcon:Hide()

	self.ControlWorker = ezSpectator_ControlWorker:Create(self.Parent)
	self.ControlWorker:BindIcon(self.Icon)

	self.TextFrame = CreateFrame('Frame', nil, self.MainFrame)
	self.TextFrame:SetFrameLevel(8 + self.Parent.Data.NamePlateLevel)
	self.TextFrame:SetFrameStrata('BACKGROUND')
	self.TextFrame:SetSize(1, 1)
	self.TextFrame:SetScale(1)
	
	self.Nickname = self.TextFrame:CreateFontString(nil, 'OVERLAY')
	self.Nickname:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSans.ttf', 12)
	self.Nickname:SetTextColor(1, 1, 1, 1)
	self.Nickname:SetShadowColor(0, 0, 0, 0.75)
	self.Nickname:SetShadowOffset(1, -1)
	self.Nickname:SetPoint('CENTER', 0, 0)
	
	self.CastUpdateFrame = CreateFrame('Frame', nil, nil)
	self.CastUpdateFrame.Parent = self

	self.CastUpdateFrame.IsProgressMode = false
	self.CastUpdateFrame.ElapsedTick = 0
	self.CastUpdateFrame.ElapsedTotal = 0

	self.CastUpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
		if self.IsProgressMode then
			self.ElapsedTick = self.ElapsedTick + Elapsed
			self.ElapsedTotal = self.ElapsedTotal + Elapsed

			if self.ElapsedTick > 0.03 then
				self.IsProgressMode = self.Parent:SetCastValue(self.ElapsedTotal * 1000)

				self.ElapsedTick = 0
			end
		end
	end)

	self.UpdateFrame = CreateFrame('Frame', nil, self.MainFrame)
	self.UpdateFrame.Parent = self

	self.AnimationDownCycle = 0
	self.IsAnimatingDown = false

	self.AnimationUpCycle = 0
	self.IsAnimatingUp = false

	self.UpdateFrame.ElapsedTick = 0
	self.UpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
		self.ElapsedTick = self.ElapsedTick + Elapsed

		if self.ElapsedTick > 0.03 then
			if self.Parent.IsAnimatingDown then
				self.Parent:DecAnimatedValue()
			end

			if self.Parent.IsAnimatingUp then
				self.Parent:IncAnimatedValue()
			end

			local Alpha = self.Parent.CastBar.Glow:GetAlpha()
			if Alpha > 0 then
				Alpha = Alpha - 0.03
				if Alpha < 0 then
					self.Parent.IsCastFree = not self.Parent.CastUpdateFrame.IsProgressMode
					Alpha = 0
				end

				self.Parent.CastBar.Glow:SetAlpha(Alpha)
			end

			self.ElapsedTick = 0
		end

		if self.Parent.IsCastFree then
			self.Parent.CastBar:Hide()
		end
	end)

	self.Parent.Data.NamePlateLevel = self.Parent.Data.NamePlateLevel + 1
	return self
end



function ezSpectator_Nameplate:DecAnimatedValue()
	if self.IsLayerAnimated then
        self.AnimationDownCycle = self.AnimationDownCycle + self.AnimationProgress
        local AnimateWidth = self.HealthBar.AnimationDownBar:GetWidth() - self.Weight * self.AnimationDownCycle

        if AnimateWidth <= 0 then
            self.HealthBar.AnimationDownBar:Hide()
        else
            if self.MainFrame:IsVisible() then
                self.HealthBar.AnimationDownBar:Show()
            end
        end
        self.HealthBar.AnimationDownBar:SetWidth(self.Parent.Data:SafeSize(AnimateWidth))
        self.HealthBar.AnimationDownBar.texture:SetTexCoord(0, self.Parent.Data:SafeTexCoord(AnimateWidth / self.Width), 0, 1)

        self.IsAnimatingDown = self.HealthBar.AnimationDownBar:GetWidth() >= self.HealthBar:GetWidth()
	end
	
	if self.IsSparkAnimated then
		self.AnimationDownCycle = self.AnimationDownCycle + self.AnimationProgress
		local AnimateValue = self.CurrentValue - self.AnimationDownCycle
		
		if AnimateValue < self.TargetValue then
			self.IsAnimatingDown = false
			AnimateValue = self.TargetValue
		end
		
		self:SetValue(AnimateValue, true)
	end
end



function ezSpectator_Nameplate:IncAnimatedValue()
    self.AnimationUpCycle = self.AnimationUpCycle + self.AnimationProgress
    local AnimateValue = self.CurrentValue + self.AnimationUpCycle

    if AnimateValue > self.TargetValue then
        self.IsAnimatingUp = false
        AnimateValue = self.TargetValue
        self.HealthBar.AnimationUpBar:Hide()
    else
        if self.MainFrame:IsVisible() then
            self.HealthBar.AnimationUpBar:Show()
        end
    end

    self:SetValue(AnimateValue, true)
end



function ezSpectator_Nameplate:IsValid()
	local Result

	if self.PlayerWorker then
		if self.PlayerWorker.Nameplate == self then
			Result = true
		else
			Result = false
		end
	else
		Result = false
    end

	if not Result then
		self.Icon:Hide()
		self.ControlWorker:Update(nil, self.CastSize / 2 / self.Scale + 2)
		self.CastBar:Hide()
	end

	return Result
end



function ezSpectator_Nameplate:Show()
	self.MainFrame:Show()

	self:IsValid()
end



function ezSpectator_Nameplate:Hide()
	self.MainFrame:Hide()

	if self.IsLayerAnimated then
		self.HealthBar.AnimationUpBar:Hide()
		self.HealthBar.AnimationDownBar:Hide()
	end
end



function ezSpectator_Nameplate:SetAlpha(Value)
	self.MainFrame:SetAlpha(Value)
end



function ezSpectator_Nameplate:ResetAnimation()
	if self.IsLayerAnimated then
		self.HealthBar.AnimationUpBar:SetWidth(0)
		self.HealthBar.AnimationDownBar:SetWidth(0)
	end
	
	if self.IsSparkAnimated then
		self:SetValue(self.CurrentValue, true)
	end
end



function ezSpectator_Nameplate:SetMaxValue(Value)
	if Value == 0 then
		self:SetValue(0, true)
	else
		self.MaxValue = Value
		self.Weight = self.Width / self.MaxValue
	
		if self.CurrentValue then
			self:SetValue(self.CurrentValue, true)
		end
	end
end



function ezSpectator_Nameplate:SetValue(Value, IsInnerCall)
	if not self.MaxValue then
		return
	end
	
	if Value == 0 then
		Value = -1
	end
	
	if Value > self.MaxValue then
		Value = self.MaxValue
	end
	
	local ProgressWidth = self.Parent.Data:SafeSize(Value * self.Weight)
	
	if self.CurrentValue and (IsInnerCall ~= true) then
		if Value > self.CurrentValue then
			if self.IsLayerAnimated then
                self.TargetValue = Value

                self.HealthBar.AnimationUpBar:SetWidth(ProgressWidth)
                self.HealthBar.AnimationUpBar.texture:SetTexCoord(0, self.Parent.Data:SafeTexCoord(ProgressWidth / self.Width), 0, 1)
				
				if not self.IsAnimatingUp then
					self.AnimationUpCycle = self.AnimationStartSpeed
					self.IsAnimatingUp = true
                end

                self.IsAnimatingDown = false
                self.HealthBar.AnimationDownBar:Hide()
			end
			
			if self.IsSparkAnimated then
				self.TargetValue = Value
				
				if not self.IsAnimatingUp then
					self.AnimationUpCycle = self.AnimationStartSpeed
					self.IsAnimatingUp = true
					
					if self.IsSparkSmoothMode then
						self.IsAnimatingDown = false
					end
				end
			end
		else
			if self.IsLayerAnimated then
                local AnimationUpBarWidth = 0
                if self.HealthBar.AnimationUpBar:IsVisible() then
                    AnimationUpBarWidth = self.HealthBar.AnimationUpBar:GetWidth()
                end

				local AnimationWidth = math.max(self.HealthBar:GetWidth(), AnimationUpBarWidth)
				
				if not self.IsAnimatingDown then
					self.HealthBar.AnimationDownBar:SetWidth(AnimationWidth)
					self.HealthBar.AnimationDownBar.texture:SetTexCoord(0, self.Parent.Data:SafeTexCoord(AnimationWidth / self.Width), 0, 1)
					
					self.AnimationDownCycle = self.AnimationStartSpeed
					self.IsAnimatingDown = true
                end

                self.IsAnimatingUp = false
                self.HealthBar.AnimationUpBar:Hide()
			end
			
			if self.IsSparkAnimated then
				self.TargetValue = Value
				
				if not self.IsAnimatingDown then
					self.AnimationDownCycle = self.AnimationStartSpeed
					self.IsAnimatingDown = true
					
					if self.IsSparkSmoothMode then
						self.IsAnimatingUp = false
					end
				end
			end
		end
	end
	
	if (self.IsSparkAnimated or self.IsAnimatingUp) and self.CurrentValue and (IsInnerCall ~= true) then
		return true
	end

	self.HealthBar:SetWidth(ProgressWidth)
	self.HealthBar.texture:SetTexCoord(0, self.Parent.Data:SafeTexCoord(ProgressWidth / self.Width), 0, 1)
	
	self.CurrentValue = Value
end



function ezSpectator_Nameplate:SetCastMaxValue(Value)
	self.CastMaxValue = Value
	self.CastWeight = self.Width / self.CastMaxValue

	self:SetCastValue(0)
end



function ezSpectator_Nameplate:SetCastValue(Value)
	if not self.CastMaxValue or (self.CastMaxValue == 0) then
		return
	end

	if Value == 0 then
		Value = -1
	end

	if Value > self.CastMaxValue then
		Value = self.CastMaxValue
	end

	local ProgressWidth = self.Parent.Data:SafeSize(Value * self.CastWeight)

	self.CastBar:SetWidth(ProgressWidth)
	self.CastBar.texture:SetTexCoord(0, self.Parent.Data:SafeTexCoord(ProgressWidth / self.Width), 0, 1)

	return Value < self.CastMaxValue
end



function ezSpectator_Nameplate:SetNickname(Value)
	self.Nickname:SetText(Value)

	if self.Parent.Data.PinkList[Value] then
		self.Nickname:SetTextColor(1, 0, 1)
		self.Nickname:SetShadowColor(1, 0, 1, 0.75)
		self.Nickname:SetShadowOffset(1, -1)
		self.Nickname.IsOverriden = true
	else
		self.Nickname:SetShadowColor(1, 0, 1, 0)
		self.Nickname.IsOverriden = false
	end
end



function ezSpectator_Nameplate:SetTeam(Value)
	if Value then
		if Value == 1 then
			if not self.Nickname.IsOverriden then
				self.Nickname:SetTextColor(0, 0.75, 0)
                self.Nickname:SetShadowColor(0, 0.25, 0, 0.75)
                self.Nickname:SetShadowOffset(1, -1)
			end
			self.HealthBar.texture:SetVertexColor(0, 0.5, 0)
		end
		
		if Value == 2 then
			if not self.Nickname.IsOverriden then
				self.Nickname:SetTextColor(0.9, 0.9, 0)
                self.Nickname:SetShadowColor(0.65, 0.65, 0, 0.75)
                self.Nickname:SetShadowOffset(1, -1)
			end
			self.HealthBar.texture:SetVertexColor(0.9, 0.9, 0)
		end

		self.HealthBar.Glow:Show()
		if self.IsTarget then
			self.HealthBar.Effect:Show()
		else
			self.HealthBar.Effect:Hide()
		end

		self.CastBar.Effect:Hide()
	else
		self.Nickname:SetTextColor(1, 1, 1)
        self.Nickname:SetShadowColor(0, 0, 0, 0.75)
        self.Nickname:SetShadowOffset(1, -1)
		self.HealthBar.texture:SetVertexColor(1, 1, 1)
		self.HealthBar.Glow:Hide()
		self.HealthBar.Effect:Hide()
		self.CastBar.Effect:Hide()
	end
end



function ezSpectator_Nameplate:SetPlayer(Value)
	self.PlayerWorker = Value

    local IsValid = self:IsValid()

    self:UpdateStyle(IsValid)

	if IsValid then
		self:SetAura()
	end
end



function ezSpectator_Nameplate:UpdateStyle(IsPlayer)
    if self.IsPlayerStyle ~= IsPlayer then
        self.IsPlayerStyle = IsPlayer
        if (IsPlayer) then
            self.MainFrame:SetFrameStrata('LOW');

			self.HealthBar:SetScale(self.Scale)
            self.HealthBar:SetPoint('CENTER', self.CastSize / 2, 0)

            self.Castborder:Show()

			self.Nickname:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSans.ttf', 12)
            self.TextFrame:SetPoint('BOTTOM', self.HealthBar.Backdrop, 'TOP', -self.CastSize / 4, 8)
        else
            self.MainFrame:SetFrameStrata('BACKGROUND');

			self.HealthBar:SetScale(self.SecondaryScale)
            self.HealthBar:SetPoint('CENTER', 0, 0)

            self.Castborder:Hide()

			self.Nickname:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSans.ttf', 10)
            self.TextFrame:SetPoint('BOTTOM', self.HealthBar.Backdrop, 'TOP', 0, 8)
        end
    end
end



function ezSpectator_Nameplate:SetClass(Value)
	if self:IsValid() then
		if not Value then
			self.Icon:Hide()
		else
			if self.PlayerWorker.IsHealer then
				self.HealerIcon:Show()
			else
				self.HealerIcon:Hide()
			end

			if not self.Icon:IsShown() then
				self.Icon:Show()
			end

			if self.ControlWorker.Class ~= Value then
				self.ControlWorker:SetClass(Value, self.CastSize / 2 / self.Scale + 2)
			end
		end
	else
		self.HealerIcon:Hide()
	end
end



function ezSpectator_Nameplate:SetCast(Spell, Time, Shift)
	if self:IsValid() then
		local CastTime = select(7, GetSpellInfo(Spell))

		if (CastTime > 0) and (Time > 0) then
			self.CastUpdateFrame.ElapsedTick = 0
			self.CastUpdateFrame.ElapsedTotal = Shift

			self.IsCastFree = false
			self.CastUpdateFrame.IsProgressMode = self.Parent.Data.CastInfo[Time] == nil
			if  self.CastUpdateFrame.IsProgressMode then
				self:SetCastMaxValue(Time)
				self.CastBar:Show()
			else
				if Time == self.Parent.Data.CAST_SUCCESS then
					self:SetCastValue(Time)
				end

				local CastInfo = self.Parent.Data.CastInfo[Time]
				if CastInfo then
					self.CastBar.Glow.texture:SetVertexColor(CastInfo.r, CastInfo.g, CastInfo.b)
					self.CastBar.Glow:SetAlpha(1)
				end
			end
		end
	end
end



function ezSpectator_Nameplate:SetAura()
	if self:IsValid() then
		self.ControlWorker:Update(self.PlayerWorker.SmallFrame.AuraFrame, self.CastSize / 2 / self.Scale + 2)
	end
end