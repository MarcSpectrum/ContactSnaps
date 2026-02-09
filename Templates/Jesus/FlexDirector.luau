--->>>OOP
local Constructor = {} ;

local Class = {} ;
Class.__index = Class

--[[
*When want to turn _Charged from Connector use him
*But this guy can rotate and change direction toward alternative Connector 
]]

--->>>ConstructorMethod
function Constructor.new(basePlate: Instance, model: Instance, UniqueID, Voltage)
    local instance = setmetatable({}, Class);
    instance['_basePlate'] = basePlate;
    instance['_model'] = model;
    instance['_Charged'] = false;
    instance['Type'] = 'FlexDirector';
    instance['UniqueID'] = UniqueID;
    instance['_basePlate'].Name = instance['UniqueID'];
    instance['Voltage'] = Voltage;
    instance['_Color'] = Color3.fromRGB(193, 193, 193);
    return instance ;
end ;

function Constructor.is(object: any) : boolean
end ;

--->>>ClassMethods
function Class:__Refresh__()
    --connect to _Charged -> Become _Charged
    --if _Charged with generater -> absorb generator Color
    local rayParam = RaycastParams.new()
    rayParam.FilterType = Enum.RaycastFilterType.Include;
    rayParam.FilterDescendantsInstances = {self['_basePlate'].Parent.Parent}
    local cframe = self['_basePlate'].CFrame;
    local rayOrigin = cframe.Position;
    local markerOrigin = self['_basePlate'].DirectionMarker.WorldPosition
    local rayLength = (markerOrigin - rayOrigin).Magnitude + 50;
    local raycasted = {
        workspace:Raycast(markerOrigin,(markerOrigin).Unit*rayLength,rayParam);
    }
    for _,v in raycasted do
        v = v.Instance.Name;
        local content = self.Voltage._Container[v]
        if not content then continue; end;
        if content['_Charged'] == true then
            self['_Charged'] = true;
            self['_Color'] = content['_Color'];
            continue;
        end;
        if self['_Charged'] == true and content['Solid'] ~= true then
            content._Color = self['_Color'];
            content._Charged = true;
        end;
    end;
end;

return Constructor ;