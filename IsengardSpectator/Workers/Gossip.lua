ezSpectator_GossipWorker = {}
ezSpectator_GossipWorker.__index = ezSpectator_GossipWorker

--noinspection LuaOverlyLongMethod
function ezSpectator_GossipWorker:Create(Parent)
    local self = {}
    setmetatable(self, ezSpectator_GossipWorker)

    GossipFrame:SetScript('OnShow', self.overrideGossipShow);
    GossipFrame:SetScript('OnHide', self.overrideGossipHide);
    GossipFrame.ezSpectator_GossipWorker = self

    self.Parent = Parent
    self.IsSpectatorGossip = false
    self.MatchList = {}
    self.StageVisibility = {
        [0] = true, --tournament
        [1] = true, --soloq
        [2] = true  --2x2
    }
    self.LockEvent = 0
    self.SelectedMatch = nil
    self.IsSubscribed = nil

    self.Textures = ezSpectator_Textures:Create()

    self.MainFrame = CreateFrame('Frame', nil, nil)
    self.MainFrame:SetSize(420, 400)
    self.MainFrame:SetPoint('TOPLEFT', GossipFrame, 'TOPLEFT', 0, 0)
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

    self.MainFrame.MainAlignFrame = CreateFrame('Frame', nil, self.MainFrame)
    self.MainFrame.MainAlignFrame:SetSize(1, 1)
    self.MainFrame.MainAlignFrame:SetPoint('TOP', self.MainFrame, 'TOP', 0, -41)

    self.MainFrame.Leave = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'gold', 36, 'TOPRIGHT', self.MainFrame, 'TOPRIGHT', -3, -3)
    self.MainFrame.Leave:SetIcon('Logout')
    self.MainFrame.Leave:SetAction(function()
        _ezSpectator.Gossip:Hide()
    end)

    self.MainFrame.Subscribe = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'gold', 36, 'TOPRIGHT', self.MainFrame, 'TOPRIGHT', -33, -3)
    self.MainFrame.Subscribe:SetIcon('Eye_Normal')
    self.MainFrame.Subscribe:SetAction(function()
        _ezSpectator.Gossip:SubscribeClick()
    end)

    self.MainFrame.Filter2 = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'gold|toggle', 36, 'TOPRIGHT', self.MainFrame, 'TOPRIGHT', -63, -3)
    self.MainFrame.Filter2:SetFontIcon('2')
    self.MainFrame.Filter2:SetToggleDown()
    self.MainFrame.Filter2:SetAction(function(ClickIcon)
        ClickIcon.Parent.Gossip:SetStageVisibility(2, not ClickIcon.IsToggleUp)
    end)

    self.MainFrame.FilterS = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'gold|toggle', 36, 'TOPRIGHT', self.MainFrame, 'TOPRIGHT', -93, -3)
    self.MainFrame.FilterS:SetFontIcon('S')
    self.MainFrame.FilterS:SetToggleDown()
    self.MainFrame.FilterS:SetAction(function(ClickIcon)
        ClickIcon.Parent.Gossip:SetStageVisibility(1, not ClickIcon.IsToggleUp)
    end)

    self.MainFrame.FilterT = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'gold|toggle', 36, 'TOPRIGHT', self.MainFrame, 'TOPRIGHT', -123, -3)
    self.MainFrame.FilterT:SetFontIcon('T')
    self.MainFrame.FilterT:SetToggleDown()
    self.MainFrame.FilterT:SetAction(function(ClickIcon)
        ClickIcon.Parent.Gossip:SetStageVisibility(0, not ClickIcon.IsToggleUp)
    end)

    self.MainFrame.Line1 = self.MainFrame:CreateFontString(nil, 'BACKGROUND', 'SystemFont_Outline')
    self.MainFrame.Line1:SetPoint('TOPLEFT', self.MainFrame, 'TOPLEFT', 10, -8)
    self.MainFrame.Line1:SetText('Isengard Spectator ' .. self.Parent.Data.Version.Major .. '.' .. self.Parent.Data.Version.Minor .. '.' .. self.Parent.Data.Version.Build .. '.' .. self.Parent.Data.Version.Revision)

    self.MainFrame.Line2 = self.MainFrame:CreateFontString(nil, 'BACKGROUND', 'SystemFont_Outline')
    self.MainFrame.Line2:SetPoint('TOPLEFT', self.MainFrame.Line1, 'BOTTOMLEFT', 0, -3)
    self.MainFrame.Line2:SetText('Матчи обновляются автоматически!')

    self.MainFrame:Hide()

    self.EventFrame = CreateFrame('Frame', nil, nil)
    self.EventFrame:RegisterEvent('GOSSIP_SHOW');
    self.EventFrame:RegisterEvent('GOSSIP_SHOW');

    self.EventFrame.Parent = self
    self.EventFrame:SetScript('OnEvent', self.onGossipShow)

    self.UpdateStage = -1

    self.UpdateFrame = CreateFrame('Frame', nil, nil)
    self.UpdateFrame.Parent = self

    self.UpdateFrame.ElapsedTick = 0
    self.UpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
        self.ElapsedTick = self.ElapsedTick + Elapsed

        if self.ElapsedTick > 1 and self.Parent.IsSpectatorGossip == true and self.Parent.SelectedMatch == nil then
            self.Parent.UpdateStage = self.Parent.UpdateStage + 1
            if self.Parent.UpdateStage > 2 then
                self.Parent.UpdateStage = 0
            end

            self.Parent:GetStageGossip()

            self.ElapsedTick = 0
        end
    end)

    return self
end



function ezSpectator_GossipWorker:Hide()
    self.IsSpectatorGossip = false
    self.SelectedMatch = nil
    self.IsSubscribed = nil
    self.MainFrame:Hide()
    self:ClearMatches()
    self.UpdateStage = -1
    self.LockEvent = time()
end



function ezSpectator_GossipWorker:SubscribeClick()
    if self.IsSubscribed == true then
        SendChatMessage('.tour subs off')

        self.MainFrame.Subscribe:SetIcon('Eye_Normal')

        self.IsSubscribed = false
        return
    end

    if self.IsSubscribed == false then
        SendChatMessage('.tour subs on')

        self.MainFrame.Subscribe:SetIcon('Eye_Stroked')

        self.IsSubscribed = true
        return
    end
end



function ezSpectator_GossipWorker:GetStageGossip(Stage)
    local DesiredStage = Stage or self.UpdateStage
    self.UpdateStage = DesiredStage

    if DesiredStage == 0 then
        SendChatMessage('.i s t', 'GUILD')
    end

    if DesiredStage == 1 then
        SendChatMessage('.i s s', 'GUILD')
    end

    if DesiredStage == 2 then
        SendChatMessage('.i s 2', 'GUILD')
    end
end



function ezSpectator_GossipWorker:ParseClassName(Data)
    if string.find(Data, 'CLASSES:16:16:0:6:16:16:0:4:0:4') then
        return 1
    end

    if string.find(Data, 'CLASSES:16:16:0:6:16:16:0:4:8:12') then
        return 2
    end

    if string.find(Data, 'CLASSES:16:16:0:6:16:16:0:4:4:8') then
        return 3
    end

    if string.find(Data, 'CLASSES:16:16:0:6:16:16:8:12:0:4') then
        return 4
    end
    if string.find(Data, 'CLASSES:16:16:0:6:16:16:8:12:4:8') then
        return 5
    end

    if string.find(Data, 'CLASSES:16:16:0:6:16:16:4:8:8:12') then
        return 6
    end

    if string.find(Data, 'CLASSES:16:16:0:6:16:16:4:8:4:8') then
        return 7
    end

    if string.find(Data, 'CLASSES:16:16:0:6:16:16:4:8:0:4') then
        return 8
    end

    if string.find(Data, 'CLASSES:16:16:0:6:16:16:12:16:4:8') then
        return 9
    end

    if string.find(Data, 'CLASSES:16:16:0:6:16:16:12:16:0:4') then
        return 11
    end

    return nil
end



function ezSpectator_GossipWorker:ParseMatch(Data, Index)
    local Result = {
        ['type'] = self.UpdateStage,
        ['index'] = Index,
        ['1'] = {},
        ['2'] = {},
        ['info1'] = '',
        ['info2'] = ''
    }

    local PlayerTeam = '1'

    for Parameter in Data:gmatch("[^|]+") do
        Parameter = string.sub(Parameter, 2)

        local IsParsed = false
        if not Result.Time then
            Result.Time = string.sub(Parameter, 1, 5)
            Parameter = string.sub(Parameter, 8, -1)
        end

        if string.find(Parameter, 'Interface/GLUES/CHARACTERCREATE/UI') then
            IsParsed = true
            table.insert(Result[PlayerTeam], self:ParseClassName(Parameter))
        end

        if string.find(Parameter, 'началось %d+ минут.* назад') then
            Parameter = string.gsub(Parameter, 'началось %d+ минут.* назад', '')
        end

        if Parameter == 'FFFF0000VS' then
            IsParsed = true
            PlayerTeam = '2'
        end

        if not IsParsed then
            --noinspection StringConcatenationInLoops
            Result['info' .. PlayerTeam] = Result['info' .. PlayerTeam] .. string.gsub(Parameter, '[\(\)]', '')
        end
    end

    Result['info1'] = Result['info1']:gsub('^%s*(.-)%s*$', '%1')
    Result['info2'] = Result['info2']:gsub('^%s*(.-)%s*$', '%1')

    return Result
end



function ezSpectator_GossipWorker:CompareMatches(MatchA, MatchB)
    local IsPreliminarilySuccess = MatchA['type'] == MatchB['type'] and MatchA['info1'] == MatchB['info1'] and MatchA['time'] == MatchB['time']

    if IsPreliminarilySuccess then
        for Index, Value in pairs(MatchA['1']) do
            if MatchB['1'][Index] ~= Value then
                return false
            end
        end

        return true
    else
        return false
    end
end



function ezSpectator_GossipWorker:FindMatch(Match)
    for Index, Value in pairs(self.MatchList) do
        if self:CompareMatches(Value, Match) == true then
            Value.IsActual = true
            return true
        end
    end

    return false
end



function ezSpectator_GossipWorker:ProcessMatch(Match)
    if not self:FindMatch(Match) then
        Match.IsActual = true
        table.insert(self.MatchList, Match)
    end
end



function ezSpectator_GossipWorker:ParseGossip()
    local GossipOptions = {GetGossipOptions()}

    if self.SelectedMatch == nil then
        GossipFrame:Hide()
    end

    if self.UpdateStage == -1 then
        local IsInitSuccess = false

        for _, Value in pairs(GossipOptions) do
            if Value == self.Parent.Data:GetString('GOSSIP_SPECTATOR_SUBSCRIBE') then
                self.IsSubscribed = false
                self.MainFrame.Subscribe:SetIcon('Eye_Normal')
                IsInitSuccess = true
            end

            if Value == self.Parent.Data:GetString('GOSSIP_SPECTATOR_UNSUBSCRIBE') then
                self.IsSubscribed = true
                self.MainFrame.Subscribe:SetIcon('Eye_Stroked')
                IsInitSuccess = true
            end
        end

        if IsInitSuccess then
            self.IsSpectatorGossip = true
            self.MainFrame:Show()
        else
            SendChatMessage('.i s', 'GUILD')
        end
    else
        local SelectedMatchIndex

        self:DeactualizeMatches()

        local Index = 1
        for _, Value in pairs(GossipOptions) do
            if string.find(Value, 'VS') then
                local ParsedMatch = self:ParseMatch(Value, Index)
                Index = Index + 1

                if self.SelectedMatch then
                    if self:CompareMatches(ParsedMatch, self.SelectedMatch) then
                        SelectedMatchIndex = Index
                        break
                    end
                end

                self:ProcessMatch(ParsedMatch)
            end
        end

        self:DisplayMatches()

        if SelectedMatchIndex ~=nil then
            SelectGossipOption(SelectedMatchIndex)
            self:Hide()
        else
            if self.SelectedMatch ~= nil then
                self.SelectedMatch = nil
            end
        end
    end
end



function ezSpectator_GossipWorker:DeactualizeMatches()
    for Index, Value in pairs(self.MatchList) do
        if Value['type'] == self.UpdateStage then
            Value.IsActual = false
        end
    end
end



function ezSpectator_GossipWorker:DisplayMatches()
    for Index, Value in pairs(self.MatchList) do
        if Value.IsActual then
            self:ShowMatch(Value)
        else
            self:HideMatch(Value)
            table.remove(self.MatchList, Index)
        end
    end
end



function ezSpectator_GossipWorker:SetMatchFramePoint(Frame, IsFirst, AlignFrame)
    if IsFirst then
        Frame:SetPoint('TOP', AlignFrame or self.MainFrame.MainAlignFrame, 'TOP', 0, 0)
    else
        Frame:SetPoint('TOP', AlignFrame or self.LastMatch.MainFrame, 'BOTTOM', 0, -3)
    end
end



function ezSpectator_GossipWorker:ShowMatch(Match)
    if not self.StageVisibility[Match['type']] then
        return
    end

    if not Match.MainFrame then
        Match.MainFrame = CreateFrame('Frame', nil, self.MainFrame)
        Match.MainFrame:SetSize(410, 35)
        Match.MainFrame:SetBackdrop({
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

        Match.MainFrame.Parent = self
        Match.MainFrame.Match = Match
        Match.MainFrame:SetBackdropColor(0, 0, 0, 0.5)
        Match.MainFrame:EnableMouse(true)
        Match.MainFrame:SetScript('OnMouseUp', function(self)
            self.Parent.SelectedMatch = self.Match
            self.Parent:GetStageGossip(self.Match['type'])
        end)

        Match.MainFrame.TypeText = Match.MainFrame:CreateFontString(nil, 'BACKGROUND', 'PVPInfoTextFont')
        Match.MainFrame.TypeText:SetPoint('LEFT', Match.MainFrame, 'LEFT', 5, -2)
        if Match['type'] == 0 then
            Match.MainFrame.TypeText:SetText('T')
        end
        if Match['type'] == 1 then
            Match.MainFrame.TypeText:SetText('S')
        end
        if Match['type'] == 2 then
            Match.MainFrame.TypeText:SetText('2')
        end

        Match.MainFrame.CentralFrame = CreateFrame('Frame', nil, Match.MainFrame)
        Match.MainFrame.CentralFrame:SetSize(1, 1)
        Match.MainFrame.CentralFrame:SetPoint('CENTER', Match.MainFrame, 'LEFT', 210, -1)
        Match.MainFrame.CentralFrame:SetFrameStrata('HIGH')

        Match.MainFrame.CentralFrame.VersusText = Match.MainFrame.CentralFrame:CreateFontString(nil, 'BACKGROUND', 'GameFontRedLarge')
        Match.MainFrame.CentralFrame.VersusText:SetPoint('CENTER', Match.MainFrame.CentralFrame, 'LEFT', 0, 0)
        Match.MainFrame.CentralFrame.VersusText:SetText('VS')

        Match.MainFrame.CentralFrame.Info1 = Match.MainFrame.CentralFrame:CreateFontString(nil, 'BACKGROUND')
        Match.MainFrame.CentralFrame.Info1:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\RobotoCondensed-Regular.ttf', 14, 'OUTLINE')
        Match.MainFrame.CentralFrame.Info1:SetTextColor(1, 1, 1, 1)
        Match.MainFrame.CentralFrame.Info1:SetPoint('RIGHT', Match.MainFrame.CentralFrame, 'LEFT', -10, 0)
        Match.MainFrame.CentralFrame.Info1:SetText(Match['info1'])

        Match.MainFrame.CentralFrame.Info2 = Match.MainFrame.CentralFrame:CreateFontString(nil, 'BACKGROUND')
        Match.MainFrame.CentralFrame.Info2:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\RobotoCondensed-Regular.ttf', 14, 'OUTLINE')
        Match.MainFrame.CentralFrame.Info2:SetTextColor(1, 1, 1, 1)
        Match.MainFrame.CentralFrame.Info2:SetPoint('LEFT', Match.MainFrame.CentralFrame, 'LEFT', 10, 0)
        Match.MainFrame.CentralFrame.Info2:SetText(Match['info2'])

        for Team = 1, 2, 1 do
            for Index, Class in pairs(Match[tostring(Team)]) do
                local IconName = 'Icon' .. Team .. Index
                Match[IconName] = CreateFrame('Frame', nil, Match.MainFrame)
                Match[IconName]:SetSize(28, 28)
                Match[IconName]:SetFrameStrata('MEDIUM')
                Match[IconName]:SetAlpha(0.5)
                if Team == 1 then
                    Match[IconName]:SetPoint('RIGHT', Match.MainFrame.CentralFrame, 'LEFT', -10 - (Index - 1) * 29, 0)
                else
                    Match[IconName]:SetPoint('LEFT', Match.MainFrame.CentralFrame, 'LEFT', 10 + (Index - 1) * 29, 0)
                end

                local OffsetTable = self.Parent.Data.ClassIconOffset[Class]
                if OffsetTable then
                    local Texture = self.Textures:Load(Match[IconName], 'Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes')
                    Texture:SetAllPoints(Match[IconName])
                    Match[IconName].texture = Texture

                    local Left, Right, Top, Bottom = unpack(OffsetTable)
                    Left = Left + (Right - Left) * 0.08
                    Right = Right - (Right - Left) * 0.08
                    Top = Top + (Bottom - Top) * 0.08
                    Bottom = Bottom - (Bottom - Top) * 0.08

                    Match[IconName].texture:SetTexCoord(Left, Right, Top, Bottom)
                end
            end
        end

        if self.LastMatch then
            Match.PrevMatch = self.LastMatch
            self.LastMatch.NextMatch = Match

            self:SetMatchFramePoint(Match.MainFrame, false)
        else
            Match.PrevMatch = nil
            self:SetMatchFramePoint(Match.MainFrame, true)
        end

        self.LastMatch =  Match
    else
        if not Match.MainFrame:IsVisible() then
            Match.MainFrame:Show()

            if self.LastMatch then
                Match.PrevMatch = self.LastMatch
                self.LastMatch.NextMatch = Match

                self:SetMatchFramePoint(Match.MainFrame, false)
            else
                Match.PrevMatch = nil
                self:SetMatchFramePoint(Match.MainFrame, true)
            end

            self.LastMatch =  Match
        end
    end
end



function ezSpectator_GossipWorker:HideMatch(Match, IsCleanupAllowed)
    if Match.MainFrame then
        if IsCleanupAllowed then
            Match.MainFrame:Hide()

            if self.LastMatch == Match then
                self.LastMatch = Match.PrevMatch
            end

            if Match.NextMatch then
                if Match.PrevMatch then
                    self:SetMatchFramePoint(Match.NextMatch.MainFrame, false, Match.PrevMatch.MainFrame)
                    Match.PrevMatch.NextMatch = Match.NextMatch
                else
                    self:SetMatchFramePoint(Match.NextMatch.MainFrame, true)
                end

                Match.NextMatch.PrevMatch = Match.PrevMatch
            end

            Match.NextMatch = nil
            Match.PrevMatch = nil
        else
            Match.MainFrame:SetAlpha(0.75)

            Match.MainFrame.ElapsedTick = 0
            Match.MainFrame:SetScript('OnUpdate', function(self, Elapsed)
                self.ElapsedTick = self.ElapsedTick + Elapsed

                if self.ElapsedTick > 0.05 then
                    self.ElapsedTick = 0

                    local Alpha = self:GetAlpha()
                    Alpha = Alpha - ((0.75 - Alpha) * 0.01) - 0.01
                    if Alpha > 0 then
                        self:SetAlpha(Alpha)
                    else
                        self:SetAlpha(0)
                    end


                    local Scale = self:GetScale() - 0.01
                    if Scale > 0 then
                        self:SetScale(Scale)
                    else
                        self.Parent:HideMatch(self.Match, true)
                    end
                end
            end)
        end
    end
end



function ezSpectator_GossipWorker:SetStageVisibility(Stage, IsVisible)
    self.StageVisibility[Stage] = IsVisible

    for Index, Value in pairs(self.MatchList) do
        if Value['type'] == Stage then
            if IsVisible then
                self:ShowMatch(Value)
            else
                self:HideMatch(Value, true)
            end
        end
    end
end



function ezSpectator_GossipWorker:ClearMatches()
    for Index, Value in pairs(self.MatchList) do
        self:HideMatch(Value)
        table.remove(self.MatchList, Index)
    end
end



function ezSpectator_GossipWorker:onGossipShow()
    if GetGossipText() == self.Parent.Parent.Data:GetString('GOSSIP_SPECTATOR_TEXT') then
        if self.Parent.LockEvent < time() then
            self.Parent:ParseGossip()
        else
            GossipFrame:Hide()
        end
    else
        self.Parent:Hide()
        PlaySound('igQuestListOpen')
    end
end



function ezSpectator_GossipWorker:overrideGossipShow()
    if StaticPopup_Visible('XP_LOSS') then
        StaticPopup_Hide('XP_LOSS')
    end
end



function ezSpectator_GossipWorker:overrideGossipHide()
    if not self.ezSpectator_GossipWorker.IsSpectatorGossip then
        PlaySound('igQuestListClose')
    end

    CloseGossip()
end



function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
