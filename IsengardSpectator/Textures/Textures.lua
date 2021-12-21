ezSpectator_Textures = {}
ezSpectator_Textures.__index = ezSpectator_Textures

function ezSpectator_Textures:Create()
	local self = {}
	setmetatable(self, ezSpectator_Textures)
	
	self.Mult = 768 / string.match(GetCVar('gxResolution'), '%d+x(%d+)') / 1
	
	return self
end



function ezSpectator_Textures:CreateShadow(Frame)
	local Shadow = CreateFrame('Frame', nil, Frame)
	Shadow:SetPoint('TOPLEFT', -4, 4)
	Shadow:SetPoint('BOTTOMRIGHT', 4, -4)
	Shadow:SetFrameStrata('BACKGROUND')
	Shadow:SetFrameLevel(1)
	Shadow:SetBackdrop({
		edgeFile = 'Interface\\AddOns\\IsengardSpectatorUI\\media\\glowTex', edgeSize = 5,
		insets = {left = 3, right = 3, top = 3, bottom = 3}
	})
	Shadow:SetBackdropBorderColor(0, 0, 0, 0.8)
end



function ezSpectator_Textures:GeneratePanel(Frame)
	Frame:SetBackdrop({
		bgFile =  "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Buttons\\WHITE8x8", 
		tile = false, tileSize = 0, edgeSize = self.Mult, 
		insets = { left = -self.Mult , right = -self.Mult, top = -self.Mult, bottom = -self.Mult}
	})
	Frame:SetBackdropColor(.04, .04, .04)
	Frame:SetBackdropBorderColor(.18, .18, .18)
end



function ezSpectator_Textures:Load(Frame, Path, Style)
	Style = Style or 'BACKGROUND'
	
	local Texture = Frame.texture
	if not Texture then
		Texture = Frame:CreateTexture(nil, Style)
	end
	Texture:SetTexture(Path)
	
	return Texture
end



function ezSpectator_Textures:SmallFrame_Normal(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\SmallFrame_Normal.tga')
	Texture:SetTexCoord(0.109375, 0.89453125, 0.2734375, 0.734375)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:SmallFrame_Backdrop(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\SmallFrame_Backdrop.tga')
	Texture:SetTexCoord(0.109375, 0.89453125, 0.2734375, 0.734375)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:SmallFrame_Highlight(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\SmallFrame_Highlight.tga')
	Texture:SetTexCoord(0.109375, 0.89453125, 0.2734375, 0.734375)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:TargetFrame_Normal(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\TargetFrame_Normal.tga')
	Texture:SetTexCoord(0.109375, 0.89453125, 0.2734375, 0.625)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:TargetFrame_Backdrop(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\TargetFrame_Backdrop.tga')
	Texture:SetTexCoord(0.109375, 0.89453125, 0.2734375, 0.625)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:CastFrame_Normal(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\CastFrame_Normal.tga')
	Texture:SetTexCoord(0.109375, 0.890625, 0.3125, 0.703125)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:CastFrame_Backdrop(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\CastFrame_Backdrop.tga')
	Texture:SetTexCoord(0.109375, 0.890625, 0.3125, 0.703125)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:CastFrame_Glow(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\CastFrame_Glow.tga')
	Texture:SetTexCoord(0.109375, 0.890625, 0.3125, 0.703125)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:TeamFrame_Normal(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\TeamFrame_Normal.tga')
	Texture:SetTexCoord(0.029296875, 0.97265625, 0.1015625, 0.453125)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:HealthBar_Backdrop(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\HealthBar_Backdrop.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:EnrageOrb_Backdrop(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\EnrageOrb_Backdrop.tga')
	Texture:SetTexCoord(0, 1, 0.3046875, 0.6875)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:EnrageOrb_Normal(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\EnrageOrb_Normal.tga')
	Texture:SetTexCoord(0, 1, 0.3046875, 0.6875)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:EnrageOrb_Sections(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\EnrageOrb_Sections.tga')
	Texture:SetTexCoord(0, 1, 0.3046875, 0.6875)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:PillowBar_Normal(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\PillowBar_Normal.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:PillowBar_Glow(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\PillowBar_Glow.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:HealthBar_Normal(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\HealthBar_Normal.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:HealthBar_Overlay(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\HealthBar_Overlay.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Backdrop(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\Nameplate_Backdrop.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Normal(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\Nameplate_Normal.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Overlay(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\Nameplate_Overlay.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Effect(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\Nameplate_Effect.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Glow(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\Nameplate_Glow.tga')
	Texture:SetTexCoord(0.23046875, 0.7734375, 0.296875, 0.71875)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Castborder(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\Nameplate_Castborder.tga')
	Texture:SetTexCoord(0.140625, 0.890625, 0.140625, 0.890625)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:SpellIcon_Normal(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\SpellIcon_Normal.tga')
	Texture:SetTexCoord(0.21875, 0.7890625, 0.21875, 0.7890625)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Backdrop(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\ClickIcon_Backdrop.tga')
	Texture:SetTexCoord(0.15625, 0.859375, 0.15625, 0.859375)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Normal_Gold(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\ClickIcon_Normal_Gold.tga')
	Texture:SetTexCoord(0.15625, 0.859375, 0.15625, 0.859375)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end


function ezSpectator_Textures:ClickIcon_Normal_Silver(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\ClickIcon_Normal_Silver.tga')
	Texture:SetTexCoord(0.15625, 0.859375, 0.15625, 0.859375)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Normal_Mild(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\ClickIcon_Normal_Mild.tga')
	Texture:SetTexCoord(0.140625, 0.890625, 0.140625, 0.890625)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Highlight_Gold(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\ClickIcon_Highlight_Gold.tga')
	Texture:SetTexCoord(0.15625, 0.859375, 0.15625, 0.859375)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Highlight_Silver(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\ClickIcon_Highlight_Silver.tga')
	Texture:SetTexCoord(0.15625, 0.859375, 0.15625, 0.859375)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Highlight_Mild(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\ClickIcon_Highlight_Mild.tga')
	Texture:SetTexCoord(0.140625, 0.890625, 0.140625, 0.890625)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:StatusBar_Spark(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\StatusBar_Spark.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:AlphaPlus(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\AlphaPlus.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end



function ezSpectator_Textures:Isengard_Logo(Frame)
	local Texture = self:Load(Frame, 'Interface\\Addons\\IsengardSpectator\\Textures\\Isengard_Logo.tga')
	Texture:SetTexCoord(0, 1, 0, 1)
	Texture:SetAllPoints(Frame)
	Frame.texture = Texture
end