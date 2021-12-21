ezSpectator_CooldownFrame = {}
ezSpectator_CooldownFrame.__index = ezSpectator_CooldownFrame

function ezSpectator_CooldownFrame:Create(Parent, ParentFrame, IsLeft)
    local self = {}
    setmetatable(self, ezSpectator_CooldownFrame)

    self.MaxCount = 22
    self.IconSize = 27
    self.IconOffsetX = -6
    self.ClassOffsetX = 0
    self.TextureSize = self.IconSize * 0.70
    self.OffsetX = 20 * _ezSpectatorScale
    self.OffsetY = 2 * _ezSpectatorScale

    self.Parent = Parent
    self.ParentFrame = ParentFrame
    self.IsLeft = IsLeft

    self.MainFrame = CreateFrame('Frame', nil, nil)
    self.MainFrame:SetFrameLevel(1)
    self.MainFrame:SetFrameStrata('HIGH')
    self.MainFrame:SetScale(_ezSpectatorScale)
    self.MainFrame:SetSize(1, 1)

    if IsLeft then
        self.MainFrame:SetPoint('LEFT', UIParent, 'BOTTOM', self.OffsetX, self.OffsetY)
    else
        self.MainFrame:SetPoint('RIGHT', UIParent, 'BOTTOM', -self.OffsetX, self.OffsetY)
    end

    self.LastNickname = nil
    self.CooldownLinks = {}

    self.CooldownIcons = {}
    local AlignFrame = self.MainFrame
    for Index = 1, self.MaxCount, 1 do
        if self.IsLeft then
            self.CooldownIcons[Index] = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'mild', self.IconSize, 'BOTTOMLEFT', AlignFrame, 'BOTTOMRIGHT', self.IconOffsetX, 0)
        else
            self.CooldownIcons[Index] = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'mild', self.IconSize, 'BOTTOMRIGHT', AlignFrame, 'BOTTOMLEFT', -self.IconOffsetX, 0)
        end
        AlignFrame = self.CooldownIcons[Index].Backdrop

        self.CooldownIcons[Index].Spell = nil

        self.CooldownIcons[Index].Reactor:SetScript('OnMouseUp', function(self)
            if self.Parent.Backdrop:IsShown() then
                self.Parent.Parent.Tooltip:ShowSpell(self, self.Parent.Spell)
            end
        end)

        self.CooldownIcons[Index]:SetTextInteractive(true)
        self.CooldownIcons[Index]:Hide()
    end

    self.UpdateFrame = CreateFrame('Frame', nil, nil)
    self.UpdateFrame.Parent = self

    self.UpdateFrame.ElapsedTick = 0
    self.UpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
        self.ElapsedTick = self.ElapsedTick + Elapsed

        if self.ElapsedTick > 1 then
            self.Parent:Update()

            self.ElapsedTick = 0
        end
    end)

    return self
end



function ezSpectator_CooldownFrame:Show()
    self.MainFrame:Show()
end



function ezSpectator_CooldownFrame:Hide()
    self.MainFrame:Hide()

    for Index = 1, self.MaxCount, 1 do
        if Index > 1 then
            if self.IsLeft then
                self.CooldownIcons[Index]:SetPoint('BOTTOMLEFT', self.CooldownIcons[Index - 1].Backdrop, 'BOTTOMRIGHT', self.IconOffsetX, 0)
            else
                self.CooldownIcons[Index]:SetPoint('BOTTOMRIGHT', self.CooldownIcons[Index - 1].Backdrop, 'BOTTOMLEFT', -self.IconOffsetX, 0)
            end
        end

        self.CooldownIcons[Index]:SetTexture(EMPTY_TEXTURE, self.TextureSize, false)
        self.CooldownIcons[Index].Spell = nil
        self.CooldownIcons[Index]:Hide()
    end
    self.CooldownLinks = {}
    self.LastNickname = nil
end



function ezSpectator_CooldownFrame:Push(Nickname, Spell, Cooldown)
    if Cooldown and Cooldown >= 0 then
        if not self.CooldownLinks[Nickname] then
            self.CooldownLinks[Nickname] = {}
        end

        if self.CooldownLinks[Nickname][Spell] then
            self.CooldownLinks[Nickname][Spell]:SetCooldown(GetTime(), Cooldown)
            self.CooldownLinks[Nickname][Spell]:SetTime(Cooldown)
        else
            for Index = 1, self.MaxCount, 1 do
                if self.CooldownIcons[Index].Spell == nil then
                    if Nickname ~= self.LastNickname and Index > 1 then
                        if self.IsLeft then
                            self.CooldownIcons[Index]:SetPoint('BOTTOMLEFT', self.CooldownIcons[Index - 1].Backdrop, 'BOTTOMRIGHT', self.ClassOffsetX, 0)
                        else
                            self.CooldownIcons[Index]:SetPoint('BOTTOMRIGHT', self.CooldownIcons[Index - 1].Backdrop, 'BOTTOMLEFT', self.ClassOffsetX, 0)
                        end
                    end

                    self.LastNickname = Nickname

                    self.CooldownIcons[Index]:SetBorderClassColor(self.Parent.Interface.Players[Nickname].Class)

                    local SpellTexture = select(3, GetSpellInfo(Spell))
                    self.CooldownIcons[Index]:SetTexture(SpellTexture, self.TextureSize, true)
                    self.CooldownIcons[Index]:SetCooldown(GetTime(), Cooldown)
                    self.CooldownIcons[Index]:SetTime(Cooldown)

                    self.CooldownIcons[Index].Spell = Spell
                    self.CooldownIcons[Index]:Show()

                    self.CooldownLinks[Nickname][Spell] = self.CooldownIcons[Index]
                    break
                end
            end
        end
    end
end



function ezSpectator_CooldownFrame:Update()
    for Index = 1, self.MaxCount, 1 do
        if self.CooldownIcons[Index].Spell then
            local Minutes, Seconds = strsplit(':', self.CooldownIcons[Index]:GetText())
            local Time = (tonumber(Minutes) or 0) * 60 + (tonumber(Seconds) or 0) - 1

            self.CooldownIcons[Index]:SetTime(Time)
        end
    end
end