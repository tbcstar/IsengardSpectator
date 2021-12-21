ezSpectator_SpecWorker = {}
ezSpectator_SpecWorker.__index = ezSpectator_SpecWorker

function ezSpectator_SpecWorker:Create(Parent)
	local self = {}
	setmetatable(self, ezSpectator_SpecWorker)

	self.Parent = Parent
	
	return self
end



function ezSpectator_SpecWorker:GetData(Class, Talents)
	if not Class or not Talents then
		return ''
	end
	
	local Tree = {}
	local Index, MaxTree, MaxTreeVal = 1, nil, 0
	for Value in string.gmatch(Talents, '([^//]+)') do
		Value = tonumber(Value)
		if MaxTree then
			if Value > MaxTreeVal then
				MaxTreeVal = Value
				--noinspection UnusedDef
				MaxTree = Index
			end
		else
			MaxTree = Index
			MaxTreeVal = Value
		end
		
		Tree[Index] = tonumber(Value)
		Index = Index + 1
	end

	local SpecText
	local SpecIcon = ''
	local IsHealer = false

	if MaxTreeVal < 44 then
		SpecText = 'Гибрид'
	else
		if MaxTree then
			SpecText = self.Parent.Data.ClassTreeInfo[Class][MaxTree][1]
			SpecIcon = select(3, GetSpellInfo(self.Parent.Data.ClassTreeInfo[Class][MaxTree][2]))
			IsHealer = self.Parent.Data.ClassTreeInfo[Class][MaxTree][3]
		end
	end
	
	return SpecText, SpecIcon, IsHealer
end