ezSpectator_UpdateFrame = {}
ezSpectator_UpdateFrame.__index = ezSpectator_UpdateFrame

--noinspection LuaOverlyLongMethod
function ezSpectator_UpdateFrame:Create()
    local self = {}
    setmetatable(self, ezSpectator_UpdateFrame)

    self.Parent = Parent

    self.MainFrame = CreateFrame('Frame', nil, nil)
    self.MainFrame:SetFrameStrata('TOOLTIP')
    self.MainFrame:SetFrameLevel(100500)
    self.MainFrame:SetSize(300, 125)
    self.MainFrame:SetPoint('TOP', 0, -50);
    self.MainFrame:SetBackdrop({
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
    self.MainFrame:SetBackdropColor(0, 0, 0, 1)

    self.Line1 = self.MainFrame:CreateFontString(nil, 'OVERLAY')
    self.Line1:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSansCondensed.ttf', 12, 'OUTLINE')
    self.Line1:SetTextColor(1, 0, 0, 1)
    self.Line1:SetPoint('TOP', 0, -8)
    self.Line1:SetText('Версия аддона "Isengard Spectator" устарела!')

    self.Line2 = self.MainFrame:CreateFontString(nil, 'OVERLAY')
    self.Line2:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSansCondensed.ttf', 9, 'OUTLINE')
    self.Line2:SetTextColor(1, 1, 1, 1)
    self.Line2:SetPoint('TOP', self.Line1, 'BOTTOM', 0, -5)
    self.Line2:SetText('Поверьте, намного проще обновить аддон, чем бегать с этим')

    self.Line3 = self.MainFrame:CreateFontString(nil, 'OVERLAY')
    self.Line3:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSansCondensed.ttf', 9, 'OUTLINE')
    self.Line3:SetTextColor(1, 1, 1, 1)
    self.Line3:SetPoint('TOP', self.Line2, 'BOTTOM', 0, -5)
    self.Line3:SetText('сообщением постоянно - вплоть до перезахода на персонажа.')

    self.Line4 = self.MainFrame:CreateFontString(nil, 'OVERLAY')
    self.Line4:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSansCondensed.ttf', 9, 'OUTLINE')
    self.Line4:SetTextColor(1, 1, 1, 1)
    self.Line4:SetPoint('TOP', self.Line3, 'BOTTOM', 0, -10)
    self.Line4:SetText('Ссылка на новую версию:')

    self.LinkHolder = CreateFrame('EditBox', nil, self.MainFrame)
    self.LinkHolder:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSansCondensed.ttf', 12, 'OUTLINE')
    self.LinkHolder:SetSize(275, 25)
    self.LinkHolder:SetPoint('TOP', self.Line4, 'BOTTOM', 0, -5)
    self.LinkHolder:SetBackdrop({
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
    self.LinkHolder:SetBackdropColor(0, 0, 0, 1)
    self.LinkHolder:SetTextInsets(5, 5, 0, 0)
    self.LinkHolder:SetMaxLetters(255)
    self.LinkHolder:SetText('https://ezwow.org/ezspec')
    self.LinkHolder:SetAutoFocus(false)

    self.LinkHolder:EnableMouse(true)
    self.LinkHolder:SetScript('OnMouseUp', function(self)
        self:HighlightText(0)
    end)
    self.LinkHolder:SetScript('OnTextChanged', function(self)
        self:SetText('https://ezwow.org/ezspec')
        self:ClearFocus()
    end)

    self.Line5 = self.MainFrame:CreateFontString(nil, 'OVERLAY')
    self.Line5:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSansCondensed.ttf', 9, 'OUTLINE')
    self.Line5:SetTextColor(1, 1, 1, 1)
    self.Line5:SetPoint('TOP', self.LinkHolder, 'BOTTOM', 0, -5)
    self.Line5:SetText('(можно скопировать при помощи Ctrl+C)')

    return self
end