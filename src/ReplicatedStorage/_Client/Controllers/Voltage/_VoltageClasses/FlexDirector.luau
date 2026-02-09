--->>>OOP
local Constructor = {} ;

local Class = {
    Type = 'FlexDirector';
} ;
Class.__index = Class

local _DefaultConstructor = require('./_DefaultConstructor');

--->>>ConstructorMethod
function Constructor.new(...)
    local this = setmetatable({}, Class);
    _DefaultConstructor.Construct(this, {...});
    this['Connections'] = {};
    return this;
end ;

--->>>ClassMethods
function Class:__Refresh__()
    local rayParam = RaycastParams.new()
    rayParam.FilterType = Enum.RaycastFilterType.Include;
    rayParam.FilterDescendantsInstances = self['basePlate'].Parent.Parent:GetChildren();
    local headOrigin = self['basePlate'].HeadDirection.WorldPosition + Vector3.new(0,20,0)
    local rayDirection = Vector3.new(0,-100,0);
    local raycasted = {
        workspace:Raycast(headOrigin,rayDirection,rayParam);
    };
    table.clear(self['Connections']);
    for _,v in raycasted do
        v = v.Instance.Name;
        local content = self.Voltage._Container[v]
        if not content then continue; end;
        if content['UniqueID'] == self['UniqueID'] then continue; end;
        if content._Solid == true then continue; end;
        table.insert(self['Connections'], content);
    end;
end;

function Class:__Interact__()
    self['basePlate'].CFrame = self['basePlate'].CFrame * CFrame.Angles(0, math.rad(90), 0)
    self.Voltage:__Calculate__()
end;

function Class:__OnPowered__(color)
    self['_ZipZap'].Enabled = true;
    self['_ZipZap'].Color = ColorSequence.new(color)
end

function Class:__OffPowered__(color)
    self['_ZipZap'].Enabled = false;
end

return Constructor ;