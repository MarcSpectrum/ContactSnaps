local Constructor = {};

local Class = {};
Class.__index = Class;

local _defaultFolder = Instance.new('Folder');

function Constructor.new(...)
    local parames = {...};
    parames[1] = type(parames[1].Value) == 'number' and parames[1].Value or 1;
    parames[2] = parames[2]:IsA('Attachment') and parames[2].CFrame.Position or Vector3.zero;
    parames[3] = parames[3]:IsA('Folder') and parames[3] or _defaultFolder;
    parames[4] = parames[4]:IsA('Folder') and parames[4] or _defaultFolder;
    local this = {};
    this['Size'] = parames[1];
    this['Position'] = parames[2];
    this['Areas'] = parames[3];
    this['Configs'] = {};
    this['Configs'].Default = {
        ['Active'] = true;
    };
    for _,configs in parames[4]:GetChildren() do
        this['Configs'][configs.Name] = {};
        for _,value in configs:GetChildren() do
            this['Configs'][configs.Name][value.Name] = value.Value;
        end;
    end;
    return this;
end;

return Constructor;