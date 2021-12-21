ezSpectator_EnrageOrb = {}
ezSpectator_EnrageOrb.__index = ezSpectator_EnrageOrb

--noinspection LuaOverlyLongMethod
function ezSpectator_EnrageOrb:Create(Parent, Width, Height, ...)
	local self = {}
	setmetatable(self, ezSpectator_EnrageOrb)

	self.Parent = Parent

	self.SoundLast = {}

	self.AnimationStartSpeed = 0
	self.AnimationProgress = 0.1

	self.CurrentValue = nil
	self.TargetValue = 0

	self.Textures = ezSpectator_Textures:Create()
	self.Width = Width - 40
	
	self.MainFrame = CreateFrame('Frame', nil, nil)
	self.MainFrame:SetFrameLevel(1)
	self.MainFrame:SetFrameStrata('DIALOG')
	self.MainFrame:SetSize(1, 1)
	self.MainFrame:SetScale(_ezSpectatorScale)
	self.MainFrame:SetPoint(...)
	self.MainFrame:SetAlpha(0.9)

	self.Backdrop = CreateFrame('Frame', nil, self.MainFrame)
	self.Backdrop:SetFrameLevel(2)
	self.Backdrop:SetFrameStrata('DIALOG')
	self.Backdrop:SetSize(Width, Height)
	self.Backdrop:SetScale(_ezSpectatorScale)
	self.Backdrop:SetPoint('CENTER', 0, 0)
	self.Textures:EnrageOrb_Backdrop(self.Backdrop)

	self.Normal = CreateFrame('Frame', nil, self.MainFrame)
	self.Normal:SetFrameLevel(6)
	self.Normal:SetFrameStrata('DIALOG')
	self.Normal:SetSize(Width, Height)
	self.Normal:SetScale(_ezSpectatorScale)
	self.Normal:SetPoint('CENTER', 0, 0)
	self.Textures:EnrageOrb_Normal(self.Normal)

	self.Sections = CreateFrame('Frame', nil, self.MainFrame)
	self.Sections:SetFrameLevel(7)
	self.Sections:SetFrameStrata('DIALOG')
	self.Sections:SetSize(Width, Height)
	self.Sections:SetScale(_ezSpectatorScale)
	self.Sections:SetPoint('CENTER', 0, 0)
	self.Textures:EnrageOrb_Sections(self.Sections)

	self.ProgressBar = CreateFrame('Frame', nil, self.MainFrame)
	self.ProgressBar:SetFrameLevel(3)
	self.ProgressBar:SetFrameStrata('DIALOG')
	self.ProgressBar:SetSize(Width - 40, Height - 10)
	self.ProgressBar:SetScale(_ezSpectatorScale)
	self.ProgressBar:SetPoint('TOPLEFT', self.Backdrop, 'TOPLEFT', 20, -5)
	self.Textures:HealthBar_Normal(self.ProgressBar)
	self.ProgressBar.texture:SetVertexColor(1, 0, 0)

	self.Stacks = {}
	self.StackFrame = CreateFrame('Frame', nil, self.MainFrame)
	for StackIndex = 1, self.Parent.Data.EnrageStackMax, 1 do
		local NewStack
		NewStack = CreateFrame('Frame', nil, self.StackFrame)
		NewStack:SetFrameLevel(3)
		NewStack:SetFrameStrata('DIALOG')
		NewStack:SetSize(11, Height - 10)
		NewStack:SetScale(_ezSpectatorScale)
		NewStack:SetPoint('TOPLEFT', self.Backdrop, 'TOPLEFT', 20 + ((StackIndex - 1) * 13.25), -5)
		self.Textures:HealthBar_Normal(NewStack)
		NewStack.texture:SetVertexColor(1, 0, 0)
		NewStack:Hide()

		local Cooldown

		Cooldown = CreateFrame('Cooldown', nil, self.StackFrame)
		Cooldown:SetFrameLevel(4)
		Cooldown:SetFrameStrata('TOOLTIP')
		Cooldown:SetSize(11, Height - 10)
		Cooldown:SetPoint('CENTER', NewStack, 'CENTER', 0, -0.5)

		self.Stacks[StackIndex] = {}
		self.Stacks[StackIndex].StackDot = NewStack
		self.Stacks[StackIndex].Cooldown = Cooldown
	end

	self.Spark = CreateFrame('Frame', nil, self.MainFrame)
	self.Spark:SetFrameLevel(4)
	self.Spark:SetFrameStrata('DIALOG')
	self.Spark:SetSize(128, Height - 10)
	self.Spark:SetScale(_ezSpectatorScale)
	self.Spark:SetAlpha(0.75)
	self.Spark:SetPoint('TOP', self.ProgressBar, 'TOPRIGHT', 0, 0)
	self.Textures:StatusBar_Spark(self.Spark)
	self.Spark.texture:SetVertexColor(1, 0, 0)

	self.Glow = CreateFrame('Frame', nil, self.MainFrame)
	self.Glow:SetFrameLevel(5)
	self.Glow:SetFrameStrata('DIALOG')
	self.Glow:SetSize(Width - 40, Height - 10)
	self.Glow:SetScale(_ezSpectatorScale)
	self.Glow:SetPoint('TOPLEFT', self.Backdrop, 'TOPLEFT', 20, -5)
	self.Textures:PillowBar_Glow(self.Glow)

	self.PrepareTextFrame = CreateFrame('Frame', nil, self.MainFrame)
	self.PrepareTextFrame:SetFrameStrata('TOOLTIP')
	self.PrepareTextFrame:SetSize(1, 1)
	self.PrepareTextFrame:SetScale(_ezSpectatorScale * 0.5)
	self.PrepareTextFrame:SetPoint('CENTER', self.MainFrame, 'CENTER', 0, 0)

	self.PrepareText = self.PrepareTextFrame:CreateFontString(nil, 'BACKGROUND', 'SystemFont_Shadow_Huge1')
	self.PrepareText:SetPoint('CENTER', 0, 0)
	self.PrepareText:SetText('ПОДГОТОВКА')
	self.PrepareText:Hide()

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

	self:SetMaxValue(self.Parent.Data.EnrageStartAt)
	return self
end



function ezSpectator_EnrageOrb:DecAnimatedValue()
	self.AnimationDownCycle = self.AnimationDownCycle + self.AnimationProgress
	local AnimateValue = self.CurrentValue - self.AnimationDownCycle

	if AnimateValue < self.TargetValue then
		self.IsAnimatingDown = false
		AnimateValue = self.TargetValue
	end

	self:SetProgressValue(AnimateValue, true)
end



function ezSpectator_EnrageOrb:IncAnimatedValue()
	self.AnimationUpCycle = self.AnimationUpCycle + self.AnimationProgress
	local AnimateValue = self.CurrentValue + self.AnimationUpCycle

	if AnimateValue > self.TargetValue then
		self.IsAnimatingUp = false
		AnimateValue = self.TargetValue
	end

	self:SetProgressValue(AnimateValue, true)
end



function ezSpectator_EnrageOrb:Hide()
	self.MainFrame:Hide()
end



function ezSpectator_EnrageOrb:Show()
	self.MainFrame:Show()
	self.Normal:Show()
	self.ProgressBar:Show()

	self.Sections:Hide()
	self.StackFrame:Hide()

	self:SetMaxValue(self.Parent.Data.EnrageStartAt)
	self:SetProgressValue(self.Parent.Data.EnrageStartAt, true)
	self:SetTime()
end



function ezSpectator_EnrageOrb:SetStackCount(Time)
	self.Normal:Hide()
	self.ProgressBar:Hide()
	self.Spark:Hide()

	if not self.StackFrame:IsShown() then
		for StackIndex = 1, self.Parent.Data.EnrageStackMax, 1 do
			self.Stacks[StackIndex].StackDot:Hide()
		end

		self.StackFrame:Show()
		self.Sections:Show()
	end

	local StackCount = ((Time - self.Parent.Data.EnrageStartAt) / self.Parent.Data.EnrageStackInterval) + 1

	for StackIndex = 1, self.Parent.Data.EnrageStackMax, 1 do
		if StackIndex <= StackCount then
			if not self.Stacks[StackIndex].StackDot:IsShown() then
				self.Stacks[StackIndex].Cooldown:SetCooldown(0, 0)

				if StackIndex == 1 then
					self.Parent.Sound:Play('Berzerk', 2)
				end
			end

			self.Stacks[StackIndex].StackDot:Show()
		else
			self.Stacks[StackIndex].StackDot:Hide()
		end
	end
end



function ezSpectator_EnrageOrb:SetTime(Time)
	if not self.MainFrame:IsShown() then
		return
	end

	if Time then
		if self.PrepareText:IsShown() and Time < 1 then
			self.Parent.Sound:Play('Play', 1)
		end

		self.PrepareText:Hide()

		local SoundName = self.Parent.Data.TimeWarnings[self.Parent.Data.EnrageStartAt - Time]
		if SoundName and (GetTime() - (self.SoundLast[SoundName] or 0) > 3) then
			self.SoundLast[SoundName] = GetTime()
			self.Parent.Sound:Play(SoundName, 1)
		end

		if Time < self.Parent.Data.EnrageStartAt then
			self:SetProgressValue(Time)
		else
			self:SetStackCount(Time)
		end
	else
		self.PrepareText:Show()
	end
end



function ezSpectator_EnrageOrb:SetMaxValue(Value)
	if Value == 0 then
		self:SetValue(0, true)
	else
		self.MaxValue = Value
		self.Weight = self.Width / self.MaxValue

		if self.CurrentValue then
			self:SetProgressValue(self.CurrentValue, true)
		end
	end
end



function ezSpectator_EnrageOrb:SetProgressValue(Value, IsInnerCall)
	if not self.MaxValue then
		return
	end

	if Value == 0 then
		Value = -1
	end

	if Value > self.MaxValue then
		Value = self.MaxValue
	end

	if Value <= self.Parent.Data.EnrageStartAt then
		local ColorDelta = Value / self.Parent.Data.EnrageStartAt
		self.ProgressBar.texture:SetVertexColor(1, 1 - ColorDelta, 1 - ColorDelta)
		self.Spark.texture:SetVertexColor(1, 1 - ColorDelta, 1 - ColorDelta)
	end

	local ProgressWidth = self.Parent.Data:SafeSize(Value * self.Weight)

	if self.CurrentValue and (IsInnerCall ~= true) then
		if Value > self.CurrentValue then
			self.TargetValue = Value

			if not self.IsAnimatingUp then
				self.AnimationUpCycle = self.AnimationStartSpeed
				self.IsAnimatingUp = true

				self.IsAnimatingDown = false
			end
		else
			self.TargetValue = Value

			if not self.IsAnimatingDown then
				self.AnimationDownCycle = self.AnimationStartSpeed
				self.IsAnimatingDown = true

				self.IsAnimatingUp = false
			end
		end
	end

	if self.CurrentValue and (IsInnerCall ~= true) then
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
		if self.Backdrop:IsShown() then
			self.Spark:Show()
		else
			self.Spark:Hide()
		end
	end

	self.CurrentValue = Value
end