ezSpectator_TopFrame = {}
ezSpectator_TopFrame.__index = ezSpectator_TopFrame

--noinspection LuaOverlyLongMethod
function ezSpectator_TopFrame:Create(Parent)
	local self = {}
	setmetatable(self, ezSpectator_TopFrame)
	
	self.Parent = Parent
	
	self.MatchTime = nil
	self.TournamentStage = nil
	self.TournamentBOX = nil
	self.Textures = ezSpectator_Textures:Create()
	
	self.MainFrame = CreateFrame('Frame', nil, nil)
	self.MainFrame:SetFrameStrata('BACKGROUND')
	self.MainFrame:SetWidth(self.Parent.Data:SafeSize(GetScreenWidth() / _ezSpectatorScale))
	self.MainFrame:SetHeight(35)
	self.MainFrame:SetScale(_ezSpectatorScale)
	self.MainFrame:SetPoint('TOP', 0, 0)

	self.Ezlogo = CreateFrame('Frame', nil,  self.MainFrame)
	self.Ezlogo:SetFrameStrata('TOOLTIP')
	self.Ezlogo:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', 0, 0)
	self.Ezlogo:SetSize(128, 32)
	self.Ezlogo:SetScale(_ezSpectatorScale)
	self.Textures:Isengard_Logo(self.Ezlogo)
	self.Ezlogo.texture:SetVertexColor(1, 1, 1, 0.5)

	self.LeftTeam = ezSpectator_TeamFrame:Create(self.Parent, true, 'TOP', -290, -1)
	self.RightTeam = ezSpectator_TeamFrame:Create(self.Parent, false, 'TOP', 290, -1)

	self.EnrageOrb = ezSpectator_EnrageOrb:Create(self.Parent, 170, 22, 'TOP', self.MainFrame, 'BOTTOM', 0, -10 * _ezSpectatorScale)

	self.TimeTextFrame = CreateFrame('Frame', nil, self.MainFrame)
	self.TimeTextFrame:SetFrameStrata('TOOLTIP')
	self.TimeTextFrame:SetSize(1, 1)
	self.TimeTextFrame:SetPoint('CENTER', self.MainFrame, 'CENTER', 0, 0)

	self.Time = self.TimeTextFrame:CreateFontString(nil, 'BACKGROUND', 'SystemFont_Shadow_Huge1')
	self.Time:SetPoint('CENTER', 0, 0)
	
	self.UpdateFrame = CreateFrame('Frame', nil, nil)
	self.UpdateFrame.Parent = self
	self.UpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
		if self.Parent.MatchTime ~= nil and self.Parent.Parent.Interface.IsRunning then
			self.Parent.MatchTime = self.Parent.MatchTime + Elapsed

			self.Parent.Time:SetText(self.Parent.Parent.Data:SecondsToTime(self.Parent.MatchTime))

            if self.Parent.Parent.Interface.IsTournament then
			    self.Parent.EnrageOrb:SetTime(self.Parent.MatchTime)
            end
        else
            self.Parent.Time:SetText('00:00')
		end
	end)

	self.TournamentTextFrame = CreateFrame('Frame', nil, self.MainFrame)
	self.TournamentTextFrame:SetFrameStrata('TOOLTIP')
	self.TournamentTextFrame:SetSize(1, 1)
	self.TournamentTextFrame:SetPoint('CENTER', self.MainFrame, 'CENTER', 0, -48)

	self.TournamentInfo = self.TournamentTextFrame:CreateFontString(nil, 'BACKGROUND', 'SystemFont_Outline')
	self.TournamentInfo:SetPoint('CENTER', 0, 0)

	self.ShowUI = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'gold', 34 / _ezSpectatorScale, 'LEFT', self.MainFrame, 'LEFT', 0, 0)
	self.ShowUI:SetIcon('Eye_Normal')
	self.ShowUI:SetAction(function()
		UIParent:Show()
		
		self.ShowUI:Hide()
		self.HideUI:Show()
	end)
	
	self.HideUI = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'gold', 34 / _ezSpectatorScale, 'LEFT', self.MainFrame, 'LEFT', 0, 0)
	self.HideUI:SetIcon('Eye_Stroked')
	self.HideUI:Hide()
	self.HideUI:SetAction(function()
		UIParent:Hide()
		
		self.ShowUI:Show()
		self.HideUI:Hide()
	end)
	
	self.Reset = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'gold', 34 / _ezSpectatorScale, 'LEFT', self.ShowUI.Normal, 'RIGHT', -3, 0)
	self.Reset:SetIcon('Refresh')
	self.Reset:SetAction(function()
		SendChatMessage('.spectate view ' .. UnitName('player'), 'GUILD')
		self.Parent.Interface:ResetViewpoint()
	end)
	
	self.Leave = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'gold', 34 / _ezSpectatorScale, 'LEFT', self.Reset.Normal, 'RIGHT', -3, 0)
	self.Leave:SetIcon('Logout')
	self.Leave:SetAction(function()
		LeaveBattlefield()
	end)

	self:Hide()
	return self
end



function ezSpectator_TopFrame:Hide()
	self.MainFrame:Hide()
	self.LeftTeam:Hide()
	self.RightTeam:Hide()
	self.EnrageOrb:Hide()
	self.Ezlogo:Hide()
	self.TournamentInfo:SetText('')
end



function ezSpectator_TopFrame:Show()
	self.MainFrame:Show()
	self.LeftTeam:Show()
	self.RightTeam:Show()
	self.Ezlogo:Show()
    if self.Parent.Interface.IsTournament then
	    self.EnrageOrb:Show()
		self.TournamentStage = nil
		self.TournamentBOX = nil
    end
end



function ezSpectator_TopFrame:StartTimer(Value)
    if Value and Value >= 0 then
        self.MatchTime = Value
    else
        self.MatchTime = nil
    end
end



function ezSpectator_TopFrame:SetStage(Value)
	self.TournamentStage = self.Parent.Data.TournamentStages[Value]
end



function ezSpectator_TopFrame:SetBOX(Value)
	self.TournamentBOX = Value
end



function ezSpectator_TopFrame:UpdateTournamentTextFrame()
	if self.TournamentStage and self.TournamentBOX then
		self.TournamentInfo:SetText(self.TournamentStage .. ' (BO' .. self.TournamentBOX .. ')')
	end
end