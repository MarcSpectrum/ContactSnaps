local LightningModule = {}

local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

function Tween(...)
	return TweenService:Create(...):Play()
end

export type LightningTemplate = {
	Start: Vector3; -- Starting Position for the bolt.
	End: Vector3; -- Ending Position for the bolt.
	
	Offset: number; -- The distance from the center the bolt curve will have.
	Segments: number; -- the amount of bolt segments.
	
	WidthStart: number; -- The width of the bolt at the start of its duration.
	WidthEnd: number; -- The width of the bolt at the end of its duration.
	
	Transparency0: number; -- The starting transparency of a bolt.
	Transparency1: number; -- The ending transparency of a bolt.
	
	Duration: number; -- The time the bolt exists for.
	
	BoltTweenInfo: TweenInfo; -- The tweeninfo on the bolt tween.
	
	Colors: {Color3}; -- The colors each bolt can start at.
	EndColors: {Color3}; -- The colors each bolt can end at.
		IsColorStatic: boolean; -- Determines if the bolt will change from the randomized color from Colors.
		ColorsAffectWholeBolt: boolean; -- Determines if the randomized color from both tables above will affect the whole bolt or individual segments.
		
	DelayTime: number; -- Delay time between each bolt, if delay is 0 it will make the bolt instant.
	
	CustomBoltPart: BasePart; -- If a basepart is given, it will override the default bolt part with this part.
	
	CustomParent: Instance; -- If provided, will override the creation of a bolt group and instead put all contents into the provided instance.
	CustomModelDescendants: {any}; -- Clones all provided instances directly into the model which stores the bolts.
	
	-- ANYTHING BELOW SHOULDNT NEED TO BE USED IF THE DELAY TIME IS 0 --
	
	RemoteEventOnEnd: RemoteEvent; -- Remote event to fire when the bolt hits the End Position.
		FireAllClients: boolean; -- If true, will fire the remote on all clients.
		ClientsToFire: {}; -- If FireAllClients isnt true, the remote will fire on all of the clients provided.
	
	BindableEventOnEnd: BindableEvent; -- Remote event to fire when the bolt hits the End Position.
}

local Template = {
	Start = nil;
	End = nil;

	Offset = 1;
	Segments = 4;

	WidthStart = 1;
	WidthEnd = 0;
	
	Transparency0 = 0;
	Transparency1 = 0;
	
	Duration = 0.25;

	BoltTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);

	Colors = {Color3.fromRGB(255, 243, 110)};
	EndColors = {Color3.fromRGB(255, 243, 110)};
		ColorsAffectWholeBolt = true;
		IsColorStatic = false;

	DelayTime = 0;
	
	CustomBoltPart = nil;

	CustomParent = nil;
	CustomModelDescendants = {};
	
	RemoteEventOnEnd = nil;
		FireAllClients = false;
		ClientsToFire = {};
	
	BindableEventOnEnd = nil;
	
} :: LightningTemplate

local function DeepCopyTable(array)
	local copy = {}
	for key, value in pairs(array) do
		copy[key] = (type(value) == "table" and DeepCopyTable(value)) or value
	end
	return copy
end

function LightningModule.GetDefaultTemplate()
	return DeepCopyTable(Template)
end

local DefaultBolt = Instance.new("Part")
DefaultBolt.CanCollide = false
DefaultBolt.CanTouch = false
DefaultBolt.CanQuery = false

DefaultBolt.Material = Enum.Material.Neon
DefaultBolt.CastShadow = false

DefaultBolt.Anchored = true

function LightningModule.New(BoltTemplate: LightningTemplate)
	
	--- TEMPLATE INFO ---
	
	local Start = BoltTemplate.Start
	local End = BoltTemplate.End
	local Points = BoltTemplate.Segments
	
	local Offset = BoltTemplate.Offset
	local DelayTime = BoltTemplate.DelayTime
	local BoltTweenInfo = BoltTemplate.BoltTweenInfo
	
	local Width0 = BoltTemplate.WidthStart
	local Width1 = BoltTemplate.WidthEnd
	
	local Trans0 = BoltTemplate.Transparency0
	local Trans1 = BoltTemplate.Transparency1
	
	local Duration = BoltTemplate.Duration
	
	local Colors = BoltTemplate.Colors
	local EndColors = BoltTemplate.EndColors
	
	local ColorsAffectWholeBolt = BoltTemplate.ColorsAffectWholeBolt
	local BoltColorStatic = BoltTemplate.IsColorStatic
	
	local CustomBolt = BoltTemplate.CustomBoltPart
	local CustomParent = BoltTemplate.CustomParent
	local CustomDescendants = BoltTemplate.CustomModelDescendants
	
	local REventOnEnd = BoltTemplate.RemoteEventOnEnd
	
	local FireAllClients = BoltTemplate.FireAllClients
	local ClientsToFire = BoltTemplate.ClientsToFire
	
	local BEventOnEnd = BoltTemplate.BindableEventOnEnd
	
	--- OTHER LOCALS ---
	
	local Bolt = (CustomBolt and CustomBolt:Clone()) or DefaultBolt:Clone()
	
	local BoltParent = CustomParent or Instance.new("Model", workspace)
	
	--- Main ---
	
	local SegmentPoints = {
		[0] = Start
	}
	
	local SegmentDistance = (End - Start) / Points
	local LastPosition = Start
	
	local StartSegmentPart = Bolt:Clone()
	
	StartSegmentPart.Transparency = 1
	StartSegmentPart.Parent = BoltParent
	StartSegmentPart.Position = LastPosition
	Debris:AddItem(StartSegmentPart, 0.1)

	if not CustomParent then
		Debris:AddItem(BoltParent, Duration+(Points*DelayTime))
	end

	for i = 1,Points do
		local Position = (i == Points and End) or (LastPosition + SegmentDistance)
		local Offset = CFrame.new(Vector3.new(Random.new():NextNumber(-Offset, Offset), Random.new():NextNumber(-Offset, Offset), 0))
		
		local NewPosition = Position+Offset.Position
		
		LastPosition = Position
		SegmentPoints[i] = (i == Points and End) or NewPosition
	end
	
	local BaseRandomColor = Colors[math.random(1, #Colors)]
	local BaseRandomColorEnd = EndColors[math.random(1, #EndColors)]

	for i = 1,Points do
		local PreviousPoint: Vector3 = SegmentPoints[i-1]
		local NextPoint: Vector3 = SegmentPoints[i]
		
		local Distance = (PreviousPoint - NextPoint).Magnitude
		
		local Segment = Bolt:Clone()
		Segment.Parent = BoltParent		
		Segment.CFrame = CFrame.lookAt(PreviousPoint, NextPoint)*CFrame.new(Vector3.new(0,0,-Distance/2))
		Segment.Color = (ColorsAffectWholeBolt and BaseRandomColor) or Colors[math.random(1, #Colors)]
		Segment.Transparency = Trans0
		
		if #CustomDescendants > 0 then
			for _,Inst: Instance in CustomDescendants do
				Inst:Clone().Parent = Segment
			end
		end
		
		Segment.Size = Vector3.new(Width0, Width0, Distance)
		Tween(Segment, BoltTweenInfo, {Size = Vector3.new(Width1, Width1, Distance), Transparency = Trans1})
		if not BoltColorStatic then Tween(Segment, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Color = (ColorsAffectWholeBolt and BaseRandomColorEnd) or EndColors[math.random(1, #EndColors)]}) end

		if DelayTime > 0 then
			task.wait(DelayTime)
		end
		
		Debris:AddItem(Segment, Duration)
	end
	
	if REventOnEnd then 
		if FireAllClients then REventOnEnd:FireAllClients() return end 
		
		if #ClientsToFire > 0 then
			for _,Client in ClientsToFire do
				REventOnEnd:FireClient(Client)
			end
		end
	end
	
	if BEventOnEnd then BEventOnEnd:Fire() end
end


return LightningModule
