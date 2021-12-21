ezSpectator_PowerBar = {}
ezSpectator_PowerBar.__index = ezSpectator_PowerBar

--noinspection LuaOverlyLongMethod
function ezSpectator_PowerBar:Create(Parent, Width, Height, Scale, Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	local self = {}
	setmetatable(self, ezSpectator_PowerBar)

	self.Parent = Parent

	self.AnimationStartSpeed = 0
	self.AnimationProgress = 10
	self.IsLayerAnimated = false
	self.IsSparkAnimated = true
		self.IsSparkSmoothMode = true
	
	self.CurrentValue = nil
	self.TargetValue = 0
	self.PowerType = nil
	
	self.Textures = ezSpectator_Textures:Create()
	self.Width = Width - 3
	
	self.Backdrop = CreateFrame('Frame', nil, nil)
	self.Backdrop:SetFrameLevel(1)
	self.Backdrop:SetFrameStrata('HIGH')
	self.Backdrop:SetSize(Width, Height)
	self.Backdrop:SetScale(Scale)
	self.Backdrop:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	self.Textures:HealthBar_Backdrop(self.Backdrop)
	
	self.ProgressBar = CreateFrame('Frame', nil, nil)
	self.ProgressBar:SetFrameLevel(1)
	self.ProgressBar:SetFrameStrata('DIALOG')
	self.ProgressBar:SetSize(self.Width, Height - 2)
	self.ProgressBar:SetScale(Scale)
	self.ProgressBar:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX + 1, OffsetY - 1)
	self.Textures:HealthBar_Normal(self.ProgressBar)
	self.ProgressBar.texture:SetVertexColor(1, 0, 0)
	
	self.Spark = CreateFrame('Frame', nil, self.ProgressBar)
	self.Spark:SetFrameLevel(1)
	self.Spark:SetFrameStrata('FULLSCREEN')
	self.Spark:SetSize(128, Height - 2)
	self.Spark:SetAlpha(0.75)
	self.Spark:SetPoint('TOP', self.ProgressBar, 'TOPRIGHT', 0, 0)
	self.Textures:StatusBar_Spark(self.Spark)
	self.Spark.texture:SetVertexColor(1, 0, 0)
	self.Spark:Hide()
	
	if self.IsLayerAnimated then
		self.AnimationDownBar = CreateFrame('Frame', nil, nil)
		self.AnimationDownBar:SetFrameLevel(0)
		self.AnimationDownBar:SetFrameStrata('HIGH')
		self.AnimationDownBar:SetSize(self.Width, Height - 2)
		self.AnimationDownBar:SetScale(Scale)
		self.AnimationDownBar:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX + 1, OffsetY - 1)
		self.Textures:HealthBar_Normal(self.AnimationDownBar)
		self.AnimationDownBar.texture:SetVertexColor(1, 0, 0)
		
		self.AnimationUpBar = CreateFrame('Frame', nil, nil)
		self.AnimationUpBar:SetFrameLevel(3)
		self.AnimationUpBar:SetFrameStrata('HIGH')
		self.AnimationUpBar:SetSize(0, Height - 2)
		self.AnimationUpBar:SetScale(Scale)
		self.AnimationUpBar:SetPoint('RIGHT', self.ProgressBar, 'RIGHT', 0, 0)
		self.Textures:HealthBar_Normal(self.AnimationUpBar)
		self.AnimationUpBar.texture:SetVertexColor(0, 1, 0)
	end
	
	self.Overlay = CreateFrame('Frame', nil, nil)
	self.Overlay:SetFrameLevel(1)
	self.Overlay:SetFrameStrata('FULLSCREEN_DIALOG')
	self.Overlay:SetSize(Width, Height)
	self.Overlay:SetScale(Scale)
	self.Overlay:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	self.Textures:HealthBar_Overlay(self.Overlay)
	
	self.TextFrame = CreateFrame('Frame', nil, nil)
	self.TextFrame:SetFrameLevel(1)
	self.TextFrame:SetFrameStrata('TOOLTIP')
	self.TextFrame:SetSize(Width, Height)
	self.TextFrame:SetScale(Scale)
	self.TextFrame:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	
	self.Value = self.TextFrame:CreateFontString(nil, 'OVERLAY')
	self.Value:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSans.ttf', 8, 'OUTLINE')
	self.Value:SetTextColor(1, 1, 1, 0.75)
	self.Value:SetPoint('CENTER', 0, 0)
	
	self.UpdateFrame = CreateFrame('Frame', nil, nil)
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
			
			self.ElapsedTick = 0
		end
	end)
	
	return self
end



function ezSpectator_PowerBar:DecAnimatedValue()
	if self.IsLayerAnimated then
		self.AnimationDownCycle = self.AnimationDownCycle + self.AnimationProgress
		local AnimateWidth = self.AnimationDownBar:GetWidth() - self.Weight * self.AnimationDownCycle
		
		if AnimateWidth <= 0 then
			self.AnimationDownBar:Hide()
		else
			if self.MainFrame:IsVisible() then
				self.AnimationDownBar:Show()
			end
		end
		self.AnimationDownBar:SetWidth(self.Parent.Data:SafeSize(AnimateWidth))
		self.AnimationDownBar.texture:SetTexCoord(0, self.Parent.Data:SafeTexCoord(AnimateWidth / self.Width), 0, 1)
		
		self.IsAnimatingDown = self.AnimationDownBar:GetWidth() >= self.ProgressBar:GetWidth()
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



function ezSpectator_PowerBar:IncAnimatedValue()
	if self.IsLayerAnimated then
		self.AnimationUpCycle = self.AnimationUpCycle + self.AnimationProgress
		local AnimateWidth = self.AnimationUpBar:GetWidth() - self.Weight * self.AnimationUpCycle
		
		if AnimateWidth <= 0 then
			self.AnimationUpBar:Hide()
		else
			if self.MainFrame:IsVisible() then
				self.AnimationUpBar:Show()
			end
		end
		self.AnimationUpBar:SetWidth(self.Parent.Data:SafeSize(AnimateWidth))
		self.AnimationUpBar.texture:SetTexCoord(
			self.Parent.Data:SafeTexCoord((self.Width - (self.Width - self.ProgressBar:GetWidth()) - self.AnimationUpBar:GetWidth()) / self.Width),
			self.Parent.Data:SafeTexCoord(self.ProgressBar:GetWidth() / self.Width),
			0,
			1
		)
		
		self.IsAnimatingUp = self.AnimationUpBar:GetWidth() > 0
	end
	
	if self.IsSparkAnimated then
		self.AnimationUpCycle = self.AnimationUpCycle + self.AnimationProgress
		local AnimateValue = self.CurrentValue + self.AnimationUpCycle
		
		if AnimateValue > self.TargetValue then
			self.IsAnimatingUp = false
			AnimateValue = self.TargetValue
		end
		
		self:SetValue(AnimateValue, true)
	end
end



function ezSpectator_PowerBar:Hide()
	self.Backdrop:Hide()
	self.ProgressBar:Hide()
	self.Spark:Hide()

	if self.IsLayerAnimated then
		self.AnimationUpBar:Hide()
		self.AnimationDownBar:Hide()
	end
	
	self.Overlay:Hide()
	self.TextFrame:Hide()
end



function ezSpectator_PowerBar:Show()
	self.Backdrop:Show()
	self.ProgressBar:Show()

	self.Overlay:Show()
	self.TextFrame:Show()
end



function ezSpectator_PowerBar:SetAlpha(Value)
	self.Backdrop:SetAlpha(Value)
	self.ProgressBar:SetAlpha(Value)
	self.Spark:SetAlpha(Value)
	self.Overlay:SetAlpha(Value)
	self.TextFrame:SetAlpha(Value)
end



function ezSpectator_PowerBar:ResetAnimation()
	if self.IsLayerAnimated then
		self.AnimationUpBar:SetWidth(0)
		self.AnimationDownBar:SetWidth(0)
	end
	
	if self.IsSparkAnimated then
		self:SetValue(self.CurrentValue, true)
	end
end



function ezSpectator_PowerBar:SetPowerType(Value)
	local PowerInfo = self.Parent.Data.PowerInfo[Value]
	if not PowerInfo then
		--noinspection ArrayElementZero
		PowerInfo = self.Parent.Data.CastInfo[0]
	end

	self.AnimationStartSpeed = PowerInfo.AnimationStartSpeed
	self.AnimationProgress = PowerInfo.AnimationProgress

	self.Backdrop.texture:SetVertexColor(PowerInfo.r, PowerInfo.g, PowerInfo.b)
	self.ProgressBar.texture:SetVertexColor(PowerInfo.r, PowerInfo.g, PowerInfo.b)
	self.Spark.texture:SetVertexColor(PowerInfo.r, PowerInfo.g, PowerInfo.b)
	
	self.PowerType = Value
	if self.CurrentValue then
		self:SetValue(self.CurrentValue, true)
	end
end



function ezSpectator_PowerBar:SetMaxValue(Value)
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



function ezSpectator_PowerBar:SetValue(Value, IsInnerCall)
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
				local AnimationWidth = self.AnimationUpBar:GetWidth() + ProgressWidth - self.ProgressBar:GetWidth()
				
				self.AnimationUpBar:SetWidth(self.Parent.Data:SafeSize(AnimationWidth))
				self.AnimationUpBar.texture:SetTexCoord(
					self.Parent.Data:SafeTexCoord((self.Width - (self.Width - ProgressWidth) - self.AnimationUpBar:GetWidth()) / self.Width),
					self.Parent.Data:SafeTexCoord(ProgressWidth / self.Width),
					0,
					1
				)
				
				if not self.IsAnimatingUp then
					self.AnimationUpCycle = self.AnimationStartSpeed
					self.IsAnimatingUp = true
				end
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
				local AnimationWidth = self.AnimationUpBar:GetWidth() + ProgressWidth - self.ProgressBar:GetWidth()

				self.AnimationUpBar:SetWidth(self.Parent.Data:SafeSize(AnimationWidth))
				self.AnimationUpBar.texture:SetTexCoord(
					self.Parent.Data:SafeTexCoord((self.Width - (self.Width - ProgressWidth) - self.AnimationUpBar:GetWidth()) / self.Width),
					self.Parent.Data:SafeTexCoord(ProgressWidth / self.Width),
					0,
					1
				)
				
				if not self.IsAnimatingDown then
					self.AnimationDownBar:SetWidth(self.ProgressBar:GetWidth())
					self.AnimationDownBar.texture:SetTexCoord(0, self.Parent.Data:SafeTexCoord(self.ProgressBar:GetWidth() / self.Width), 0, 1)
					
					self.AnimationDownCycle = self.AnimationStartSpeed
					self.IsAnimatingDown = true
				end
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
	
	if self.IsSparkAnimated and self.CurrentValue and (IsInnerCall ~= true) then
		return true
	end

	self.ProgressBar:SetWidth(ProgressWidth)
	self.ProgressBar.texture:SetTexCoord(0, self.Parent.Data:SafeTexCoord(ProgressWidth / self.Width), 0, 1)

	local SparkWidth = ProgressWidth + 64
	if SparkWidth > self.Width then
		SparkWidth = 64 + self.Width - ProgressWidth
		self.Spark:SetWidth(self.Parent.Data:SafeSize(SparkWidth))
		self.Spark.texture:SetTexCoord(0, self.Parent.Data:SafeTexCoord(SparkWidth / 128), 0, 1)
		
		self.Spark:ClearAllPoints()
		self.Spark:SetPoint('LEFT', self.ProgressBar, 'RIGHT', -64, 0)
	elseif ProgressWidth < 64 then
		SparkWidth = ProgressWidth + 64
		self.Spark:SetWidth(self.Parent.Data:SafeSize(SparkWidth))
		self.Spark.texture:SetTexCoord(self.Parent.Data:SafeTexCoord(1 - SparkWidth / 128), 1, 0, 1)
		
		self.Spark:ClearAllPoints()
		self.Spark:SetPoint('RIGHT', self.ProgressBar, 'LEFT', SparkWidth, 0)
	else
		self.Spark:SetWidth(128)
		self.Spark.texture:SetTexCoord(0, 1, 0, 1)
		
		self.Spark:ClearAllPoints()
		self.Spark:SetPoint('TOP', self.ProgressBar, 'TOPRIGHT', 0, 0)
	end

	if SparkWidth <= 65 then
		self.Spark:Hide()
	else
		self.Spark:Show()
	end
	
	self.CurrentValue = Value
	
	if (self.PowerType == 1) or (self.PowerType == 6) then
		Value = math.floor(Value / 10)
	end
	
	if Value > 0 then
		self.Value:SetText(Value)
	else
		self.Value:SetText(0)
    end
end