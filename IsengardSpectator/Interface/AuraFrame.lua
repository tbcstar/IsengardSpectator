ezSpectator_AuraFrame = {}
ezSpectator_AuraFrame.__index = ezSpectator_AuraFrame

function ezSpectator_AuraFrame:Create(Parent, IsUpfilling, ...)
	local self = {}
	setmetatable(self, ezSpectator_AuraFrame)

	self.Parent = Parent

	self.IsUpfilling = IsUpfilling
	
	self.BuffLines = 2
	self.DebuffLines = 2
	self.PerLine = 9
	
	self.IconSize = 20
	
	self.MainFrame = CreateFrame('Frame', nil, nil)
	self.MainFrame:SetFrameLevel(1)
	self.MainFrame:SetSize(192, 120)
	self.MainFrame:SetScale(_ezSpectatorScale)
	self.MainFrame:SetPoint(...)
	
	self.AuraStack = {}
	self.AuraIcons = {}
	
	for Line = 1, self.BuffLines + self.DebuffLines, 1 do
		self.AuraIcons[Line] = {}
		for Index = 1, self.PerLine, 1 do 
			if IsUpfilling then
				self.AuraIcons[Line][Index] = ezSpectator_AuraIcon:Create(self.Parent, self.MainFrame, self.IconSize - 4, 'TOPLEFT', self.MainFrame, 'TOPLEFT', (Index - 1) * self.IconSize, (Line - 1) * self.IconSize * -1 + (_ezSpectatorScale - 1) * 10)
			else
				self.AuraIcons[Line][Index] = ezSpectator_AuraIcon:Create(self.Parent, self.MainFrame, self.IconSize - 4, 'BOTTOMLEFT', self.MainFrame, 'BOTTOMLEFT', (Index - 1) * self.IconSize, (Line - 1) * self.IconSize)
			end
		end
	end
	
	return self
end



function ezSpectator_AuraFrame:Show()
	self.MainFrame:Show()
end



function ezSpectator_AuraFrame:Hide()
	self.MainFrame:Hide()
end



function ezSpectator_AuraFrame:SetAlpha(Value)
	self.MainFrame:SetAlpha(Value)
end



function ezSpectator_AuraFrame:PeekAura(IsPositive, DesiredIndex)
	local Line, Index
	local InnerIndex = 1

	--noinspection UnusedDef
	for IndexLoop, Record in ipairs(self.AuraStack) do
		if (InnerIndex == DesiredIndex) and (Record.IsPositive == IsPositive) then
			return Record
		end
		
		if Record.IsPositive == IsPositive then
			InnerIndex = InnerIndex + 1
		end
	end
	
	return nil
end



function ezSpectator_AuraFrame:DrawAura(Record, Line, Index)
	local DoDraw
	if Record.Line and Record.Index then
		--noinspection UnusedDef
		DoDraw = Record.IsNeedUpdate or (Index ~= Record.Index) or (Line ~= Record.Line)
	else
		DoDraw = true
	end
	
	if DoDraw then
		local TimeOverride
		if Record.Line and Record.Index then
			if not Record.IsNeedUpdate then
				TimeOverride = self.AuraIcons[Record.Line][Record.Index].Cooldown.StartTime
			end
		end
		
		Record.Line = Line
		Record.Index = Index
		
		self.AuraIcons[Line][Index]:Show(Record.Spell, Record.StackCount, Record.Expiration, Record.Duration, Record.DebuffType, Record.IsPositive, TimeOverride, not Record.IsNeedUpdate)
		Record.IsNeedUpdate = false
	end
end



function ezSpectator_AuraFrame:Redraw()
	local AuraType
	local LastUsedLine = 0
	
	if self.IsUpfilling then
		--noinspection UnusedDef
		AuraType = 0
	else
		AuraType = 1
	end

	for LineLoop = 1, self.DebuffLines, 1 do
		for IndexLoop = 1, self.PerLine, 1 do
			local Record = self:PeekAura(AuraType, IndexLoop + (LineLoop - 1) * self.PerLine)
			if Record then
				LastUsedLine = LineLoop
				self:DrawAura(Record, LineLoop, IndexLoop)
			else
				if LineLoop == LastUsedLine then
					self.AuraIcons[LineLoop][IndexLoop]:Hide()
				end
			end
		end
	end
	
	local LinesLeft = self.BuffLines + self.DebuffLines - LastUsedLine
	
	if self.IsUpfilling then
		--noinspection UnusedDef
		AuraType = 1
	else
		AuraType = 0
	end

	for LineLoop = 1, LinesLeft, 1 do
		for IndexLoop = 1, self.PerLine, 1 do
			local Record = self:PeekAura(AuraType, IndexLoop + (LineLoop - 1) * self.PerLine)
			if Record then
				self:DrawAura(Record, LineLoop + LastUsedLine, IndexLoop)
			else
				self.AuraIcons[LineLoop + LastUsedLine][IndexLoop]:Hide()
			end
		end
	end
end



function ezSpectator_AuraFrame:SetAura(IsRemoved, StackCount, Expiration, Duration, Spell, DebuffType, IsPositive, Caster)
	local SpellTexture = select(3, GetSpellInfo(Spell))
	if not SpellTexture then
		return
	end
	
	local Record = {}
	local RecordIndex

	Record.IsNeedUpdate = false
	for Index, Value in ipairs(self.AuraStack) do
		if (Value.Spell == Spell) and (Value.Caster == Caster) then
			Record = Value
			RecordIndex = Index
			
			Record.IsNeedUpdate = (Record.StackCount ~= StackCount) or (Record.Expiration ~= Expiration) or (Record.Duration ~= Duration)
		end
	end
	
	Record.IsNeedUpdate = Record.IsNeedUpdate or (RecordIndex == nil)
	if IsRemoved == 0 then
		Record.Spell = Spell
		Record.DebuffType = DebuffType
		Record.IsPositive = IsPositive
		Record.Caster = Caster
		
		if Record.IsNeedUpdate then
			Record.StackCount = StackCount
			Record.Expiration = Expiration
			Record.Duration = Duration
		end
		
		if RecordIndex == nil then
			table.insert(self.AuraStack, Record)
		end
	else
		if (RecordIndex ~= nil) and Record.Line and Record.Index then
			self.AuraIcons[Record.Line][Record.Index]:Hide()
			table.remove(self.AuraStack, RecordIndex)
		end
	end
	
	self:Redraw()
end