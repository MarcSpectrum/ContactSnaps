--[[ Presets ]]--
local RUN = game:GetService('RunService') ;
local UIS = game:GetService('UserInputService') ;
local Players = game:GetService('Players') ;

local _IsServer = RUN:IsServer() ;
local _IsStudio = RUN:IsStudio() ;

--[[ Variables ]]--
local ply = Players.LocalPlayer ;
local plyRoot ;
local plyUI = ply:WaitForChild('PlayerGui') ;
local plyCam = workspace.CurrentCamera ;
local plyMouse = ply:GetMouse() ;

local Signal = require('../../../../_Shared/Customs/Signal') ;

local self = {} ;

--[[ Properties ]]--
self['ContextKey'] = 'CustomCursor' ;

self.__ValueChanged = Signal.new() ;
self.__Executed = Signal.new() ;

self._Active = false ;

--[[ TopdownCam ]]--
local _Run_Topdown = nil ;
function __ToggleTopdown(state: boolean)
    state = state or false ;
    if state == false then
        plyCam.CameraType = Enum.CameraType.Custom ;
        _Run_Topdown:Disconnect() ;
    else
        plyCam.CameraType = Enum.CameraType.Scriptable ;
        _Run_Topdown = RUN.Heartbeat:Connect(function(dltm: number)
            plyCam.CFrame = CFrame.new(plyRoot.Position.X,40,plyRoot.Position.Z) * CFrame.Angles(math.rad(-90),0,0)
        end) ;
    end ;
end ;

--[[ Interfaces ]]--
local _Cursor_Screen = Instance.new('ScreenGui') ;
_Cursor_Screen.ResetOnSpawn = false ;
_Cursor_Screen.IgnoreGuiInset = true ;
_Cursor_Screen.Name = 'ControllerCursorScreen' ;
_Cursor_Screen.Parent = plyUI ;

local _Cursor_Size = 12 ;
local _Cursor = Instance.new('Frame') ;
_Cursor.Size = UDim2.fromOffset(_Cursor_Size, _Cursor_Size) ;
_Cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255) ;
_Cursor.AnchorPoint = Vector2.new(0.5, 0.5) ;
_Cursor.Position = UDim2.fromOffset(200, 200) ;
_Cursor.Parent = _Cursor_Screen ;

local _Context = plyUI:WaitForChild('Contexts'):WaitForChild('CustomCursor') ;

--[[ MainOperations ]]--
self._CanvaX = 0 ;
self._CanvaY = 0 ;
--self._OffsetFixed_Scale = 62 ;
self._OffsetFixed_Scale = 0 ;
self._OffsetFixed = 0 ;
local function __UpdateCanvaSize()
    local scrnSz = plyCam.ViewportSize ;
    self._CanvaX = scrnSz.X ;
    self._CanvaY = scrnSz.Y ;
    self._OffsetFixed = self._OffsetFixed_Scale/self._CanvaY
end ;
plyCam:GetPropertyChangedSignal('ViewportSize'):Connect(__UpdateCanvaSize) ;
__UpdateCanvaSize() ;

local function __OffsetToScale(offset: Vector2)
    return Vector2.new(
        offset.X / self._CanvaX,
        offset.Y / self._CanvaY
    ) ;
end ;

self._Coordinate = UDim2.fromScale(0,0) ;
self._Value = Vector2.zero ;
self._Velocity = Vector2.new(0, 0) ;

local _Velociated = nil ;
local _Velociated_Scale = .01 ;
local function __Velociate(dltm: number)
    local xScale = math.clamp((self._Coordinate.X.Scale + (self._Velocity.X*_Velociated_Scale)), 0, 1) ;
    local yScale = math.clamp((self._Coordinate.Y.Scale + (self._Velocity.Y*_Velociated_Scale)), 0, 1) ;
    self._Coordinate = UDim2.fromScale(xScale, yScale) ;
    self._Value = self:GetOffsetVector() ;
    _Cursor.Position = self._Coordinate ;
    self.__ValueChanged:Fire(self._Value) ;
end ;

local _TapDetected = {} ;
local function __TapDetection(touch: InputObject, proc: boolean)
    if proc then return; end ;
    local pos = touch.Position ;
    local scl = __OffsetToScale(pos) ;
    self._Coordinate = UDim2.fromScale(scl.X, scl.Y+self._OffsetFixed) ;
end ;
local function __MoveDetection(touch: {}, proc: boolean)
    if proc then return; end ;
    local pos = touch[1].Position ;
    local scl = __OffsetToScale(pos) ;
    self._Coordinate = UDim2.fromScale(scl.X, scl.Y+self._OffsetFixed) ;
end ;
local function __MouseTapDetection()
    local scl = __OffsetToScale(Vector2.new(plyMouse.X,plyMouse.Y)) ;
    self._Coordinate = UDim2.fromScale(scl.X, scl.Y+self._OffsetFixed) ;
end ;

--[[ MainOperations_Inputs ]]--
local Action_Execute = _Context:WaitForChild('Action_Execute') :: InputAction ;
local Action_Tap = _Context:WaitForChild('Action_Tap') :: InputAction ;
local Action_Move = _Context:WaitForChild('Action_Move') :: InputAction ;

Action_Execute.Pressed:Connect(function()
    self.__Executed:Fire(self._Value) ;
end) ;

Action_Tap.StateChanged:Connect(function()
    self.__Executed:Fire(self._Value) ;
end) ;

Action_Move.StateChanged:Connect(function()
    local stte = Action_Move:GetState() ;
    self._Velocity = Vector2.new(math.sign(stte.X),-math.sign(stte.Y)) ;
end) ;

--[[ SecretOperations ]]--
function self:GetOffsetVector()
    return Vector2.new(
        self._Coordinate.X.Scale * self._CanvaX,
        self._Coordinate.Y.Scale * self._CanvaY
    ) ;
end ;

--[[ RequiredOperations ]]--
function self:Enable()
    plyRoot = ply.Character.HumanoidRootPart ;
    self._Coordinate = UDim2.fromScale(.5,.5) ;
    _Velociated = RUN.Heartbeat:Connect(__Velociate) ;
    _TapDetected = {
        UIS.TouchMoved:Connect(__TapDetection) ;
        UIS.TouchStarted:Connect(__TapDetection) ;
        UIS.TouchEnded:Connect(__TapDetection) ;
        plyMouse.Move:Connect(__MouseTapDetection) ;
    } ;
    _Context.Enabled = true ;
    _Cursor.Transparency = 0;
    --__ToggleTopdown(true) ;
    self._Active = true ;
end ;

function self:Disable()
    self._Coordinate = UDim2.fromScale(.5,.5) ;
    self.__ValueChanged:DisconnectAll() ;
    self.__Executed:DisconnectAll() ;
    _Velociated:Disconnect() ;
    for _,v in _TapDetected do v:Disconnect(); end ;
    _TapDetected = nil ;
    _Context.Enabled = false ;
    _Cursor.Transparency = 1;
    --__ToggleTopdown(false) ;
    self._Active = false ;
end ;

-->>> Mobile
if UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled then
    local ExecuteBtn = Instance.new("TextButton")
    ExecuteBtn.Size = UDim2.fromScale(0.18, 0.12)
    ExecuteBtn.Position = UDim2.fromScale(0.8, 0.8)
    ExecuteBtn.Text = 'Click'
    ExecuteBtn.BackgroundTransparency = 0.2
    ExecuteBtn.Parent = _Cursor_Screen

    ExecuteBtn.Activated:Connect(function()
        if not self._Active then return end
        self.__Executed:Fire(self._Value)
    end)
end

return self ;