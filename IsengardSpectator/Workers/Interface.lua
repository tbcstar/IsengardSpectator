ezSpectator_InterfaceWorker = {}
ezSpectator_InterfaceWorker.__index = ezSpectator_InterfaceWorker

function ezSpectator_InterfaceWorker:Create(Parent)
	local self = {}
	setmetatable(self, ezSpectator_InterfaceWorker)
	
	WorldStateScoreFrame:SetParent(nil)
	
	self.Parent = Parent

	self.IsRunning = false
	self.IsSpectating = false
	self.Viewpoint = nil

	self.TopFrame = ezSpectator_TopFrame:Create(self.Parent)
	
	self.Reactor = CreateFrame('Frame', nil, nil)
	self.Reactor.Parent = self
	self.Reactor.ElapsedTick = 0
	self.Reactor:SetScript('OnUpdate', function(self, Elapsed)
		self.ElapsedTick = self.ElapsedTick + Elapsed
		
		if self.ElapsedTick > 0.5 then
			local Winner = GetBattlefieldWinner()
			if Winner then
				if self.Parent.IsRunning then
					self.Parent.IsRunning = false

					self.Parent:ProcessWinner(Winner, 'DEFAULT')
				end
			end
		end

		self.Parent:ProcessCastQueue()
	end)
	
	self.Nameplates = ezSpectator_Nameplates:Create(self.Parent)

    self.EventFrame = CreateFrame('Frame', nil, nil);
    self.EventFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
    self.EventFrame.Parent = self;
    self.EventFrame:SetScript('OnEvent', function(self)
        if self.Parent.IsSpectating then
           self.Parent:SetMode(0)
        end
    end);

	self:Reset()
	return self
end



function ezSpectator_InterfaceWorker:Reset()
	self.Teams = {}
	self.Teams[1] = {}
	self.Teams[2] = {}
	
	self.Players = {}
end



function ezSpectator_InterfaceWorker:CheckVersion(Value)
	local Major, Minor, Build, Revision = strsplit('.', Value, 4)

	local IsActual = (tonumber(Major) == self.Parent.Data.Version.Major) and
				(tonumber(Minor) == self.Parent.Data.Version.Minor) and
				(tonumber(Build) == self.Parent.Data.Version.Build) and
				(tonumber(Revision) == self.Parent.Data.Version.Revision)

	if not IsActual then
		self.UpdateFrame = ezSpectator_UpdateFrame:Create()
	end
end



function ezSpectator_InterfaceWorker:SetMode(Value)
	self:ResetViewpoint()

	if Value == 0 then
		self.IsRunning = false
		self.IsSpectating = false
        self.IsTournament = false

		UIParent:Show()

		--noinspection UnusedDef
		for Index, Player in pairs(self.Players) do
			Player:Hide()
			Player.SmallFrame.CastFrame:Hide()
		end
		self.TopFrame:Hide()
		
		self:Reset()
	else
		self.IsRunning = true
		self.IsSpectating = true
        self.IsTournament = Value > 1

		self.TopFrame:Show()
		
		UIParent:Hide()
	end
end



function ezSpectator_InterfaceWorker:SetTeamName(TeamID, Value)
	if not TeamID then
		return
	end
	
	Value = Value:sub(2, -2)
	if TeamID == 1 then
		self.Teams[TeamID].Name = Value
		self.TopFrame.LeftTeam:SetName(Value)
	end
	
	if TeamID == 2 then
		self.Teams[TeamID].Name = Value
		self.TopFrame.RightTeam:SetName(Value)
	end
end



function ezSpectator_InterfaceWorker:SetTeamColor(TeamID, Value)
	if not TeamID then
		return
	end
	
	if TeamID == 1 then
		self.Teams[TeamID].Color = Value
		self.TopFrame.LeftTeam:SetColor(Value)
	end
	
	if TeamID == 2 then
		self.Teams[TeamID].Color = Value
		self.TopFrame.RightTeam:SetColor(Value)
	end
end



function ezSpectator_InterfaceWorker:SetTeamScore(TeamID, Value)
	if not TeamID then
		return
	end
	
	if TeamID == 1 then
		self.Teams[TeamID].Score = Value
		self.TopFrame.LeftTeam:SetScore(Value)
	end
	
	if TeamID == 2 then
		self.Teams[TeamID].Score = Value
		self.TopFrame.RightTeam:SetScore(Value)
	end
end



function ezSpectator_InterfaceWorker:SetStage(Value)
	self.TopFrame:SetStage(Value)
    self.TopFrame:UpdateTournamentTextFrame()
end



function ezSpectator_InterfaceWorker:SetBOX(Value)
    self.TopFrame:SetBOX(Value)
    self.TopFrame:UpdateTournamentTextFrame()
end



function ezSpectator_InterfaceWorker:SetMatchElapsed(Value)
	if not Value then
		return
	end
	
	self.TopFrame:StartTimer(Value)
end



function ezSpectator_InterfaceWorker:UpdateTargets()
	--noinspection UnusedDef
	for Index, Player in pairs(self.Players) do
		if not Player.SmallFrame.IsLocked and not Player.IsDead then
			Player.SmallFrame.Target:Update()
		else
			Player.SmallFrame.Target:Hide()
		end
	end
end



function ezSpectator_InterfaceWorker:UpdateTeams()
	if not self.IsRunning then
		return
	end

	local LeftMax, LeftVal, RightMax, RightVal = 0, 0, 0, 0

	--noinspection UnusedDef
	for Index, Player in pairs(self.Players) do
		if Player and Player:IsReady() then
			if Player.Team == 1 then
				LeftMax = LeftMax + Player.MaxHealth
				LeftVal = LeftVal + Player.Health
			end
			
			if Player.Team == 2 then
				RightMax = RightMax + Player.MaxHealth
				RightVal = RightVal + Player.Health
			end
		end
	end
	
	self.TopFrame.LeftTeam.HealthBar:SetMaxValue(LeftMax)
	self.TopFrame.LeftTeam.HealthBar:SetValue(LeftVal)
	
	self.TopFrame.RightTeam.HealthBar:SetMaxValue(RightMax)
	self.TopFrame.RightTeam.HealthBar:SetValue(RightVal)
end



function ezSpectator_InterfaceWorker:ProcessWinner(Value, Mode)
	Value = Value + 1

	--noinspection UnusedDef
	for Index, Player in pairs(self.Players) do
		Player:SetWinner(Value == Player.Team)
	end

	local SoundName = self.Parent.Data.MatchEndings[Mode]
	if type(SoundName) == 'table' then
		SoundName = SoundName[math.random(#SoundName)]
	end

	self.Parent.Sound:Play(SoundName, 2)
end



function ezSpectator_InterfaceWorker:ProcessCastQueue()
	--noinspection UnusedDef
	for Index, Player in pairs(self.Players) do
		if Player.CastQueue:GetCount() > 0 then
			Player:SetCast()
		end
	end
end



function ezSpectator_InterfaceWorker:ResetViewpoint()
	self.Viewpoint = nil

	--noinspection UnusedDef
	for Index, Player in pairs(self.Players) do
		if not Player.IsDead then
			Player.SmallFrame:SetAlpha(1)
		end

		Player.PlayerFrame:Hide()
		Player.VictimFrame:Hide()
	end
end



function ezSpectator_InterfaceWorker:ResetVictims()
	--noinspection UnusedDef
	for Index, Player in pairs(self.Players) do
		Player.VictimFrame:Hide()
	end
end