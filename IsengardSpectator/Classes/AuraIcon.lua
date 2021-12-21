ezSpectator_AuraIcon = {}
ezSpectator_AuraIcon.__index = ezSpectator_AuraIcon

function ezSpectator_AuraIcon:Create(Parent, ParentFrame, Size, ...)
	local self = {}
	setmetatable(self, ezSpectator_AuraIcon)

	self.Parent = Parent

	self.MainFrame = CreateFrame('Button', nil, ParentFrame)
	self.MainFrame:SetSize(Size, Size)
	self.MainFrame:SetPoint(...)
	self.MainFrame:Hide()

	self.MainFrame:EnableMouse(true)
	self.MainFrame:SetScript('OnMouseUp', function()
		if self.MainFrame:IsShown() then
			self.Parent.Tooltip:ShowSpell(self.MainFrame, self.Spell)
		end
	end)
	
	self.Cooldown = CreateFrame('Cooldown', nil, self.MainFrame)
	self.Cooldown:SetAllPoints(self.MainFrame)
	self.Cooldown:SetReverse()
	
	self.Icon = self.MainFrame:CreateTexture(nil, 'BORDER')
	self.Icon:SetAllPoints(self.MainFrame)
	self.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	
	self.StackCount = self.MainFrame:CreateFontString(nil, 'OVERLAY')
	self.StackCount:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSansCondensed.ttf', 9, 'OUTLINE')
	self.StackCount:SetTextColor(1, 1, 1, 1)
	self.StackCount:SetPoint('BOTTOMLEFT', self.MainFrame, 'BOTTOMLEFT', 0, 1)
	
	self.OverlayFrame = CreateFrame('Frame', nil, self.MainFrame)
	self.OverlayFrame:SetFrameStrata('TOOLTIP')
	self.OverlayFrame:SetPoint('TOPLEFT', self.MainFrame, 'TOPLEFT', -2, 2)
	self.OverlayFrame:SetPoint('BOTTOMRIGHT', self.MainFrame, 'BOTTOMRIGHT', 2, -2)
	
	self.Overlay = self.OverlayFrame:CreateTexture(nil, 'OVERLAY')
	self.Overlay:SetTexture('Interface\\AddOns\\IsengardSpectator\\Textures\\AuraIcon_Border')
	self.Overlay:SetAllPoints(self.OverlayFrame)
	
	self.IsFree = true
	self.IsPositive = nil

	self.Spell = nil
	
	return self
end


--TODO check "Expiration" parameter...
--noinspection UnusedDef
function ezSpectator_AuraIcon:Show(Spell, StackCount, Expiration, Duration, DebuffType, IsPositive, TimeOverride, LockAnimation)
	local SpellTexture = select(3, GetSpellInfo(Spell))

	if SpellTexture then
		self.Spell = Spell

		self.MainFrame:Show()
		
		if Duration and Duration > 0 then
			if TimeOverride then
				self.Cooldown.StartTime = TimeOverride
			else
				self.Cooldown.StartTime = GetTime()
			end
			
			self.Cooldown:SetCooldown(self.Cooldown.StartTime, Duration / 1000)
			self.Cooldown:Show()
		else
			self.Cooldown:Hide()
		end
		
		if DebuffType and IsPositive == 0 then
			local Color = self.Parent.Data.DebuffColor[self.Parent.Data.DebuffList[DebuffType]] or self.Parent.Data.DebuffColor.none
			self.Overlay:SetVertexColor(Color.r, Color.g, Color.b)
			
			if DebuffType > 0 then
				self.OverlayFrame.ElapsedTick = 0
				self.OverlayFrame.IsRising = true
				self.OverlayFrame.CurrentAlpha = 1
				
				self.OverlayFrame:SetScript('OnUpdate', function(self, Elapsed)
					self.ElapsedTick = self.ElapsedTick + Elapsed
					
					if self.ElapsedTick > 0.01 then
						self.ElapsedTick = 0
						
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
						
						self:SetAlpha(self.CurrentAlpha)
					end
				end)
			end
		else
			self.Overlay:SetVertexColor(0, 0, 0)
			self.OverlayFrame:SetScript('OnUpdate', nil) 
		end
		
		self.Icon:SetTexture(SpellTexture)
		self.StackCount:SetText((StackCount > 1 and StackCount))
		
		if self.IsFree and not (LockAnimation == true) then
			self.IsFree = false
			self.MainFrame:SetAlpha(0)
			
			self.MainFrame.ElapsedTick = 0
			self.MainFrame:SetScript('OnUpdate', function(self, Elapsed)
				self.ElapsedTick = self.ElapsedTick + Elapsed
				
				if self.ElapsedTick > 0.01 then
					self.ElapsedTick = 0
					
					self:SetAlpha(self:GetAlpha() + 0.03)
					if self:GetAlpha() == 1 then 
						self:SetScript('OnUpdate', nil) 
					end
				end
			end)
		else
			self.MainFrame:SetAlpha(1)
		end
		
		self.IsPositive = IsPositive
	end
end



function ezSpectator_AuraIcon:Hide()
	self.MainFrame:SetScript('OnUpdate', nil) 
	self.MainFrame:Hide()
	self.IsFree = true
end