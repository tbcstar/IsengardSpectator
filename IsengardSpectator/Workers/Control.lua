ezSpectator_ControlWorker = {}
ezSpectator_ControlWorker.__index = ezSpectator_ControlWorker

function ezSpectator_ControlWorker:Create(Parent)
	local self = {}
	setmetatable(self, ezSpectator_ControlWorker)

	self.Parent = Parent

	self.ControlIcon = nil
	self.Class = nil
	
	self.CurrentAura = nil
	self.CurrentAuraLevel = -1
	self.IsAnimated = false
	
	self.UpdateFrame = CreateFrame('Frame', nil, nil)
	self.UpdateFrame.Parent = self
	self.UpdateFrame.ElapsedTick = 0
	self.UpdateFrame.UpdateTick = 0.5
	self.UpdateFrame.IsRising = false
	self.UpdateFrame.CurrentAlpha = 1
	self.UpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
		self.ElapsedTick = self.ElapsedTick + Elapsed
		
		if self.ElapsedTick > self.UpdateTick then
			self.ElapsedTick = 0
			self.UpdateTick = 0.01
			
			if self.Parent.IsAnimated and self.Parent.ControlIcon and self.Parent.ControlIcon.Backdrop:IsShown() then
				if self.IsRising == true then
					self.CurrentAlpha = self.CurrentAlpha - 0.07
					if self.CurrentAlpha < 0.2 then 
						self.IsRising = false 
					end
				else
					self.CurrentAlpha = self.CurrentAlpha + 0.07
					if self.CurrentAlpha > 1 then 
						self.IsRising = true 
					end
				end
				
				self.Parent.ControlIcon.Icon:SetAlpha(self.CurrentAlpha)
			end
		end
	end)
	
	return self
end



function ezSpectator_ControlWorker:BindIcon(IconClass)
	self.ControlIcon = IconClass
end



function ezSpectator_ControlWorker:SetClass(Class, Size)
	Size = Size or 17

	self.CurrentAuraLevel = -1
	
	if Class then
		self.Class = Class
	end

	if self.Class then
		local OffsetTable = self.Parent.Data.ClassIconOffset[self.Class]
		if OffsetTable then
			self.ControlIcon:SetTexture('Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes', Size, false)
			local Left, Right, Top, Bottom = unpack(OffsetTable)
			Left = Left + (Right - Left) * 0.08
			Right = Right - (Right - Left) * 0.08
			Top = Top + (Bottom - Top) * 0.08
			Bottom = Bottom - (Bottom - Top) * 0.08
			
			self.ControlIcon.Icon.texture:SetTexCoord(Left, Right, Top, Bottom)
		end
	end
end



function ezSpectator_ControlWorker:Update(AuraFrame, Size)
	Size = Size or 17

	local IsAuraFound = false

	if AuraFrame then
		for _, AuraRecord in pairs(AuraFrame.AuraStack) do
			if self.Parent.Data.ControlList[AuraRecord.Spell] ~= nil then
				if self.Parent.Data.ControlList[AuraRecord.Spell] >= self.CurrentAuraLevel then
					IsAuraFound = true

					self.CurrentAura = AuraRecord
					self.CurrentAuraLevel = self.Parent.Data.ControlList[AuraRecord.Spell]
				end
			end
		end
	end

	if IsAuraFound then
		local _, _, AuraTexture = GetSpellInfo(self.CurrentAura.Spell)
		self.ControlIcon:SetTexture(AuraTexture, Size, true)
		self:DoAnimate(true)
	else
		self:SetClass(nil, Size)
		self:DoAnimate(false)
	end
end



function ezSpectator_ControlWorker:DoAnimate(Value)
	if not self.IsAnimated and Value then
		self.UpdateFrame.UpdateTick = 0.5
		self.UpdateFrame.IsRising = false
		self.UpdateFrame.CurrentAlpha = 1
		
		if self.ControlIcon.Backdrop:IsShown() then
			self.ControlIcon:SetCooldown(0, 0)
		end
	end
	
	self.IsAnimated = Value
	if not Value then
		self.ControlIcon.Icon:SetAlpha(1)
	end
end