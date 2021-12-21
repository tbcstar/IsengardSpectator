ezSpectator_DataStack = {}
ezSpectator_DataStack.__index = ezSpectator_DataStack

function ezSpectator_DataStack:Create(Mode)
    local self = {}
    setmetatable(self, ezSpectator_DataStack)

    self.List = {}
    self.First = 0
    self.Last = -1

    if Mode == 'FIFO' then
        self.InnerPop = self.PopFIFO
    end

    if Mode == 'FILO' then
        self.InnerPop = self.PopFILO
    end

    return self
end



function ezSpectator_DataStack:Push(Data)
    self.Last = self.Last + 1
    self.List[self.Last] = Data
end



function ezSpectator_DataStack:Pop()
    return self.InnerPop(self)
end



function ezSpectator_DataStack:GetCount()
    if self.First > self.Last then
        return 0
    else
        return self.Last - self.First + 1
    end
end



function ezSpectator_DataStack.PopFIFO(self)
    if self.First > self.Last then
        return nil
    end

    local Return = self.List[self.First]
    self.List[self.First] = nil
    self.First = self.First + 1

    return Return
end



function ezSpectator_DataStack.PopFILO(self)
    if self.First > self.Last then
        return nil
    end

    local Return = self.List[self.Last]

    self.List[self.Last] = nil
    self.Last = self.Last - 1

    return Return
end