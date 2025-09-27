
-- thanks @yohan_moon for finding this animator module
-- Forsakation discord server: https://discord.gg/9XHYkWybxR
-- Reanimation was made by @emperrrr (Discord)
-- Discord server for empers reanimate: https://discord.gg/UJ7YtqadPJ
if not isfolder("Forsakation/Killers/") then
	makefolder("Forsakation/Killers/")
end
if not isfile("Forsakation/Killers/C00lkiddAnimations.rbxmx") then
	writefile("Forsakation/Killers/C00lkiddAnimations.rbxmx", game:HttpGet("https://raw.githubusercontent.com/CyberNinja103/Animations/refs/heads/main/C00lkiddAnimations.rbxmx"))
end
--local EmoteGui: ScreenGui = game:GetObjects("rbxassetid://70965231817963")[1]
--EmoteGui.Parent = game.Players.LocalPlayer.PlayerGui
--EmoteGui.Enabled = false
local Destroyed = false
--local Mobile: ScreenGui = game:GetObjects("rbxassetid://77707674968679")[1]
--Mobile.Parent = game.Players.LocalPlayer.PlayerGui
--Mobile.Enabled = false
local Controls: ScreenGui = game:GetObjects("rbxassetid://85172975543013")[1]
Controls.Parent = game.Players.LocalPlayer.PlayerGui
--local Controls = game.Players.LocalPlayer.PlayerGui.ControlsUI
Controls.Enabled = true
Controls.MobileContainer.Visible = false
Controls.Version.Text = "Version: C00lKidd 2.0"

--[[ read me NOW!!!

this was leaked with permission from ShownApe aka the one who found the original limb reanimate (and also permission from kampachi who made the original code and gave me it, we love you kam)
this is a variant of the original method which works the same way

you might be wondering why it got leaked:
when someone found this variant it got given to someone, then someone else, then someone else... and so on (including me)
till it got in the hands of a skid (feariosz0) who thought it was a good idea to use it without permission in his hub to advertise it
and get popular from it
textbook definition of skid basically

also a h1 report (aka a vulnerability report) was already filed and sent to roblox
so this will get patched soon, have fun while you still can

also please keep in mind that this code was written by me but its a remake of kampaachi's code just done and written way better (no shade)
anything after this freshly added comment was made before and not after the leak,

have fun skids, while you still can,,, :smiling_imp:

]]

-- written by Emper
-- anyone who has the method can receive this code

-- whoever originally wrote it was trying to optimize it
-- so ill be doing that here
-- although you dont really need to optimize stuff thats
-- not done in loops
-- but ill be doing it anyway since thats what they were trying to do

do
	-- Settings:

	local DefaultAnimations = false -- doesnt work in velocity because it doesnt allow u to run localscripts
	local DisableCharacterCollisions = true
	local InstantRespawn = true
	local ParentCharacterToRig = false
	local RigTransparency = 1

	--

	local CFrameidentity = CFrame.identity
	local Inverse = CFrameidentity.Inverse
	local ToAxisAngle = CFrameidentity.ToAxisAngle
	local ToEulerAnglesXYZ = CFrameidentity.ToEulerAnglesXYZ
	local ToObjectSpace = CFrameidentity.ToObjectSpace

	local Connections = {}

	local Disconnect = nil

	local game = game
	local FindFirstChild = game.FindFirstChild
	local FindFirstChildOfClass = game.FindFirstChildOfClass
	local Players = FindFirstChildOfClass(game, "Players")
	local LocalPlayer = Players.LocalPlayer
	local Character = LocalPlayer.Character
	local CharacterAdded = LocalPlayer.CharacterAdded
	local Connect = CharacterAdded.Connect
	local Wait = CharacterAdded.Wait
	local Rig = Players:CreateHumanoidModelFromDescription(Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId), Enum.HumanoidRigType.R6)
	local RigAnimate = Rig.Animate
	local RigHumanoid = Rig.Humanoid -- no need to do waitforchild here, its a safe index
	local RigRootPart = RigHumanoid.RootPart
	local RunService = FindFirstChildOfClass(game, "RunService")
	local Workspace = FindFirstChildOfClass(game, "Workspace")
	local GetDescendants = game.GetDescendants
	local IsA = game.IsA
	local WaitForChild = game.WaitForChild

	local BreakJoints = Instance.new("Model").BreakJoints

	local mathsin = math.sin

	local next = next

	local osclock = os.clock

	local replicatesignal = replicatesignal

	local RootPartCFrame = nil

	local Motor6Ds = {}

	local select = select

	local sethiddenproperty = sethiddenproperty

	local tableinsert = table.insert

	local Vector3 = Vector3
	local Vector3new = Vector3.new
	local Vector3zero = Vector3.zero

	RigAnimate.Enabled = false	

	Rig.Name = LocalPlayer.Name
	RigHumanoid.DisplayName = LocalPlayer.DisplayName -- if theres no display it will be just name so this is fine

	if Character then
		if replicatesignal then
			if InstantRespawn then
				replicatesignal(LocalPlayer.ConnectDiedSignalBackend)
				task.wait(Players.RespawnTime - 0.1)

				local RootPart = FindFirstChild(Character, "HumanoidRootPart")

				if RootPart then
					RootPartCFrame = RootPart.CFrame
				end

				replicatesignal(LocalPlayer.Kill)
			end
		else
			BreakJoints(Character)
		end
	end

	Character = Wait(CharacterAdded)

	local Animate = WaitForChild(Character, "Animate")
	Animate.Enabled = false

	local RootPart = WaitForChild(Character, "HumanoidRootPart")
	RigRootPart.CFrame = RootPartCFrame or RootPart.CFrame

	Disconnect = Connect(RigHumanoid.Died, function()
		for Index, Connection in Connections do
			Disconnect(Connection)
		end

		if ParentCharacterToRig then
			Character.Parent = Rig.Parent
		end

		BreakJoints(Character)
		Rig:Destroy()
		Controls:Destroy()
		Destroyed = true
	end).Disconnect

	for Index, Descendant in next, GetDescendants(Character) do
		if IsA(Descendant, "Motor6D") then
			Motor6Ds[Descendant] = {
				Part0 = Rig[Descendant.Part0.Name],
				Part1 = Rig[Descendant.Part1.Name]
			}
		end
	end

	for Index, Descendant in next, GetDescendants(Rig) do
		if IsA(Descendant, "BasePart") then
			Descendant.Transparency = RigTransparency
		end
	end

	Rig.Parent = Workspace

	if ParentCharacterToRig then
		Character.Parent = Rig
	end

	task.defer(function()
		local CurrentCamera = Workspace.CurrentCamera
		local CameraCFrame = CurrentCamera.CFrame

		LocalPlayer.Character = Rig
		CurrentCamera.CameraSubject = RigHumanoid

		Wait(RunService.PreRender)
		Workspace.CurrentCamera.CFrame = CameraCFrame
	end)

	tableinsert(Connections, Connect(RunService.PostSimulation, function()
		for Motor6D, Table in next, Motor6Ds do
			local Part0 = Table.Part0
			local Part1CFrame = Table.Part1.CFrame

			Motor6D.DesiredAngle = select(3, ToEulerAnglesXYZ(Part1CFrame, Part0.CFrame))

			local Delta = Inverse(Motor6D.C0) * ( Inverse(Part0.CFrame) *  Part1CFrame ) * Motor6D.C1
			local Axis, Angle = ToAxisAngle(Delta)

			sethiddenproperty(Motor6D, "ReplicateCurrentAngle6D", Axis * Angle)
			sethiddenproperty(Motor6D, "ReplicateCurrentOffset6D", Delta.Position)
		end

		RootPart.AssemblyAngularVelocity = Vector3zero
		RootPart.AssemblyLinearVelocity = Vector3zero
		RootPart.CFrame = RigRootPart.CFrame + Vector3new(0, mathsin(osclock() * 15) * 0.004, 0)
	end))

	tableinsert(Connections, Connect(RunService.PreSimulation, function()
		for Index, BasePart in next, GetDescendants(Rig) do
			if IsA(BasePart, "BasePart") then
				BasePart.CanCollide = false
			end
		end

		if DisableCharacterCollisions and not ParentCharacterToRig then
			for Index, BasePart in next, GetDescendants(Character) do
				if IsA(BasePart, "BasePart") then
					BasePart.CanCollide = false
				end
			end
		end
	end))
end
