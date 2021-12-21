ezSpectator_TooltipWorker = {}
ezSpectator_TooltipWorker.__index = ezSpectator_TooltipWorker

function ezSpectator_TooltipWorker:Create(Parent)
    local self = {}
    setmetatable(self, ezSpectator_TooltipWorker)

    self.Parent = Parent

    self.MainFrame = CreateFrame('Frame', nil, nil)
    self.MainFrame:SetFrameStrata('TOOLTIP')
    self.MainFrame:SetFrameLevel(100500)

    self.TooltipFrame = CreateFrame('GameTooltip', 'ezSpectator_DataWorkerTooltip', self.MainFrame, 'GameTooltipTemplate')

    self.ReactorFrame = CreateFrame('Frame', nil, nil)
    self.ReactorFrame:SetFrameStrata('TOOLTIP')
    self.ReactorFrame:SetFrameLevel(100500)
    self.ReactorFrame:EnableMouse(true)
    self.ReactorFrame.Parent = self

    return self
end



function ezSpectator_TooltipWorker:ShowSpell(ParentFrame, SpellID)
    self.ReactorFrame:ClearAllPoints()
    self.ReactorFrame:SetAllPoints(ParentFrame)

    self.ReactorFrame:SetScript('OnLeave', function(self)
        self.Parent.TooltipFrame:Hide()

        self:Hide()
        self:SetScript('OnLeave', nil)
    end)
    self.ReactorFrame:Show()

    local IsLeft = select(1, GetCursorPosition()) < GetScreenWidth() * UIParent:GetEffectiveScale() / 2
    if IsLeft then
        self.TooltipFrame:SetOwner(ParentFrame, 'ANCHOR_BOTTOMLEFT')
    else
        self.TooltipFrame:SetOwner(ParentFrame, 'ANCHOR_BOTTOMRIGHT')
    end

    self.TooltipFrame:ClearLines()
    self.TooltipFrame:SetHyperlink('|cff71d5ff|Hspell:' .. SpellID .. '|h[Blizzard Sucks]|h|r')
    self.TooltipFrame:AddDoubleLine('\nИдентификатор #' .. SpellID, '', 0.4, 0.4, 0.4)

    self:Stylize()
    self.TooltipFrame:Show()
end



function ezSpectator_TooltipWorker:Stylize()
    self.TooltipFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = 'Interface\\AddOns\\IsengardSpectator\\Textures\\TooltipEdge',
        tile = true, tileSize = 16, edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    })

    self.TooltipFrame:SetBackdropColor(0, 0, 0, 1)
end