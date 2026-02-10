local SFX = {};

SFX['_Container'] = {}

local BG = Instance.new('Sound');
BG.SoundId = 'rbxassetid://94535484325181';
BG.Looped = true;
BG.Volume = .25;
BG.Parent = workspace;

function SFX:Load(key: string, ID: number)
    local thisSound = BG:Clone();
    thisSound.SoundId = ('rbxassetid://'..ID);
    thisSound.Volume = .5;
    thisSound.Looped = false;
    thisSound.Name = key;
    thisSound.Parent = workspace
    self._Container[tostring(key)] = thisSound
end;

function SFX:Play(key: string)
    local find = self._Container[tostring(key)];
    if find then find:Play(); end;
end;

function SFX:__Init__()
    SFX:Load('Click1', 87437544236708);
    SFX:Load('Click2', 17520503095);
    SFX:Load('Teleport1', 138819213201245);
    SFX:Load('Trigger1', 136442624750684);
    SFX:Load('Trigger2', 74660269726021);
    SFX:Load('Finished', 126747954491661);
end;

function SFX:__Start__()
    BG:Play();
end;

return SFX