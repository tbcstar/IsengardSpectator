ezSpectator_CastBar = {}
ezSpectator_CastBar.__index = ezSpectator_CastBar

--noinspection LuaOverlyLongMethod
function ezSpectator_CastBar:Create(Parent, ParentFrame, Width, Height, Scale, Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	local self = {}
	setmetatable(self, ezSpectator_CastBar)

	self.Parent = Parent
	self.ParentFrame = ParentFrame

	self.CurrentValue = nil
	
	self.Textures = ezSpectator_Textures:Create()
	self.Width = Width - 3
	
	self.Backdrop = CreateFrame('Frame', nil, self.ParentFrame)
	self.Backdrop:SetFrameStrata('HIGH')
	self.Backdrop:SetSize(Width, Height)
	self.Backdrop:SetScale(Scale)
	self.Backdrop:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	self.Textures:HealthBar_Backdrop(self.Backdrop)
	
	self.ProgressBar = CreateFrame('Frame', nil, self.ParentFrame)
	self.ProgressBar:SetFrameStrata('DIALOG')
	self.ProgressBar:SetSize(self.Width, Height - 2)
	self.ProgressBar:SetScale(Scale)
	self.ProgressBar:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX + 1, OffsetY - 1)
	self.Textures:HealthBar_Normal(self.ProgressBar)
	self.ProgressBar.texture:SetVertexColor(1, 0, 0)
	
	self.Spark = CreateFrame('Frame', nil, self.ParentFrame)
	self.Spark:SetFrameStrata('FULLSCREEN')
	self.Spark:SetSize(128, Height - 2)
	self.Spark:SetScale(Scale)
	self.Spark:SetAlpha(0.75)
	self.Spark:SetPoint('TOP', self.ProgressBar, 'TOPRIGHT', 0, 0)
	self.Textures:StatusBar_Spark(self.Spark)
	self.Spark.texture:SetVertexColor(1, 0, 0)
	self.Spark:Hide()
	
	self.Overlay = CreateFrame('Frame', nil, self.ParentFrame)
	self.Overlay:SetFrameStrata('FULLSCREEN_DIALOG')
	self.Overlay:SetSize(Width, Height)
	self.Overlay:SetScale(Scale)
	self.Overlay:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	self.Textures:HealthBar_Overlay(self.Overlay)
	
	self.TextFrame = CreateFrame('Frame', nil, self.ParentFrame)
	self.TextFrame:SetFrameStrata('TOOLTIP')
	self.TextFrame:SetSize(Width, Height)
	self.TextFrame:SetScale(Scale)
	self.TextFrame:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	
	self.Text = self.TextFrame:CreateFontString(nil, 'OVERLAY')
	self.Text:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSans.ttf', 8)
	self.Text:SetTextColor(1, 1, 1, 0.75)
	self.Text:SetShadowColor(0, 0, 0, 0.75)
	self.Text:SetShadowOffset(1, -1)
	self.Text:SetPoint('CENTER', 0, 1)
	
	return self
end



function ezSpectator_CastBar:SetText(Name)
	self.Text:SetText(Name)
end



function ezSpectator_CastBar:SetCastType(Time, SpellName)
	self:SetMaxValue(Time)

	local CastInfo = self.Parent.Data.CastInfo[Time]
	if not CastInfo then
		CastInfo = self.Parent.Data.CastInfo[100000]
	end

	self:SetText(CastInfo.Text or SpellName)
	if CastInfo.IsProgressMode then
		self:SetValue(0)
	else
		self:SetValue(Time)
	end

	self.Backdrop.texture:SetVertexColor(CastInfo.r, CastInfo.g, CastInfo.b)
	self.ProgressBar.texture:SetVertexColor(CastInfo.r, CastInfo.g, CastInfo.b)
	self.Spark.texture:SetVertexColor(CastInfo.r, CastInfo.g, CastInfo.b)
	
	return CastInfo.IsProgressMode
end



function ezSpectator_CastBar:SetMaxValue(Value)
	if Value ~= 0 then
		self.MaxValue = Value
		self.Weight = self.Width / self.MaxValue

		if self.CurrentValue then
			self:SetValue(self.CurrentValue)
		end
	end
end



function ezSpectator_CastBar:SetValue(Value)
	local Result = true
	
	if Value > self.MaxValue then
		Value = self.MaxValue
		Result = false
	end
	
	local ProgressWidth = self.Parent.Data:SafeSize(Value * self.Weight)
	
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
	return Result
end