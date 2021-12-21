ezSpectator_Sounds = {}
ezSpectator_Sounds.__index = ezSpectator_Sounds

function ezSpectator_Sounds:Create(Parent)
    local self = {}
    setmetatable(self, ezSpectator_Sounds)

    self.Parent = Parent

    self.Mult = 1
    self.Path = 'Interface\\Addons\\IsengardSpectator\\Sounds\\'

    return self
end



function ezSpectator_Sounds:Play(Filename, Multiplyer)
    Multiplyer = Multiplyer or self.Mult

    --noinspection UnusedDef
    for Loop = 1, Multiplyer, 1 do
        PlaySoundFile(self.Path .. Filename .. '.wav', 'master')
    end
end