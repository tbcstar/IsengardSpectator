_ezSpectatorScale = 1.15

ezSpectator = {}
ezSpectator.__index = ezSpectator

function ezSpectator:Create()
	local self = {}
	setmetatable(self, ezSpectator)

	self.Data = ezSpectator_DataWorker:Create(self)
	self.Sound = ezSpectator_Sounds:Create(self)

	self.Interface = ezSpectator_InterfaceWorker:Create(self)
	self.Handler = ezSpectator_MessageHandler:Create(self)

	self.Tooltip = ezSpectator_TooltipWorker:Create(self)

    self.Gossip = ezSpectator_GossipWorker:Create(self)

	return self
end

_ezSpectator = ezSpectator:Create()

plate, worker = nil, nil


function ezSpectator_Demo()
	_ezSpectator.Interface.IsRunning = true
	_ezSpectator.Interface.TopFrame:Show()
	_ezSpectator.Interface.TopFrame:StartTimer(235)

	worker = ezSpectator_PlayerWorker:Create(_ezSpectator)
	worker:SetNickname('Test')
	worker:SetClass(1)
	worker:SetPowerType(1)
	worker:SetMaxHealth(30000)
	worker:SetMaxPower(100)

	plate = ezSpectator_Nameplate:Create(_ezSpectator, _ezSpectator.Interface.TopFrame.MainFrame, 'CENTER', _ezSpectator.Interface.TopFrame.MainFrame, 'CENTER', 0, -100)
	worker:SetNameplate(plate)
	plate:SetPlayer(worker)
	plate:SetMaxValue(30000)
	plate:SetValue(15000)
	plate:SetNickname('Test')
	plate:SetTeam(1)
	plate:SetClass(1)
	plate:SetAlpha(1)
	plate:Show()
end