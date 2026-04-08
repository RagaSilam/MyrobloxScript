-- [[ NGOHI HYBRID FINAL ABSOLUTE - TRUE FULL VERSION ]] --
-- Fix: Anti-Adonis, Silent Scan, & Delta Mobile Optimization
-- STATUS: NO CUT VERSION + AI INTEGRATED

local lp = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local mouse = lp:GetMouse()
local PlayerGui = lp:WaitForChild("PlayerGui")

-- [[ 1. ULTRA SILENT BYPASS (ANTI-ADONIS) ]] --
local function Bypass()
	pcall(function()
		-- Sembunyikan Kick dari deteksi Adonis indexInstance
		local oldKick
		oldKick = hookfunction(lp.Kick, newcclosure(function(self, reason)
			if self == lp and not checkcaller() then 
				return nil 
			end
			return oldKick(self, reason)
		end))
		
		if getgenv then
			local g = getgenv()
			g.Check = function() return end
			g.Detector = function() return end
			g.Adonis = {Disabled = true}
		end

		-- Metamethod Bypass (Mencegah deteksi pemanggilan remote secara paksa)
		local oldNamecall
		oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
			local method = getnamecallmethod()
			if not checkcaller() and (method == "Kick" or method == "BreakJoints") then
				return nil
			end
			return oldNamecall(self, ...)
		end))
	end)
end
Bypass()

-- [[ 2. AI SNIFFER LOGIC (NEW INTEGRATION) ]] --
-- Logika AI untuk menangkap argumen Remote secara real-time
local AI_Captured_Data = {}
local function StartAISniffer()
	local oldFireServer
	oldFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
		if not checkcaller() then
			AI_Captured_Data[self.Name] = {
				Args = {...},
				Remote = self,
				Timestamp = tick()
			}
		end
		return oldFireServer(self, ...)
	end))
end
StartAISniffer()

-- Cleanup UI Lama
if PlayerGui:FindFirstChild("Ngohi_Absolute_System") then
	PlayerGui["Ngohi_Absolute_System"]:Destroy()
end

-- [[ 3. GLOBAL STATES ]] --
local flying = false
local noclip = false
local flingActive = false
local flySpeed = 100
local spinActive = false
local infJumpActive = false
local orbitActive = false
local DiscoOn = false
local NightOn = false
local CurrentRemote = nil
local ClickTP = false
local Spam = false

-- [[ 4. GUI DESIGN ]] --
local MainGui = Instance.new("ScreenGui", PlayerGui)
MainGui.Name = "Ngohi_Absolute_System"
MainGui.ResetOnSpawn = false
MainGui.IgnoreGuiInset = true

local function makeDraggable(frame, handle)
	local dragStart, startPos
	local dragging = false
	handle = handle or frame

	handle.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	handle.InputEnded:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
		end
	end)
end

local IconButton = Instance.new("Frame", MainGui)
IconButton.Size = UDim2.new(0, 60, 0, 60)
IconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
IconButton.Active = true
local IconCorner = Instance.new("UICorner", IconButton); IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton); IconStroke.Color = Color3.fromRGB(0, 255, 120); IconStroke.Thickness = 3
makeDraggable(IconButton)

local IconLogo = Instance.new("TextButton", IconButton)
IconLogo.Size = UDim2.new(1, 0, 1, 0)
IconLogo.BackgroundTransparency = 1
IconLogo.Text = "W"
IconLogo.TextColor3 = Color3.fromRGB(0, 255, 120)
IconLogo.Font = Enum.Font.GothamBold
IconLogo.TextSize = 24

local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Size = UDim2.new(0, 400, 0, 540)
MainFrame.Position = UDim2.new(0.5, -200, 0.4, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = Color3.fromRGB(0, 255, 120); MainStroke.Thickness = 2
makeDraggable(MainFrame)

IconLogo.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(1, 0, 0, 55)
TabHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0, 12)

local TabFitur = Instance.new("ScrollingFrame", MainFrame)
TabFitur.Size = UDim2.new(1, -20, 1, -75)
TabFitur.Position = UDim2.new(0, 10, 0, 65)
TabFitur.BackgroundTransparency = 1
TabFitur.CanvasSize = UDim2.new(0, 0, 4.5, 0)
TabFitur.ScrollBarThickness = 2
TabFitur.Visible = true
Instance.new("UIListLayout", TabFitur).Padding = UDim.new(0, 8)

local TabScan = Instance.new("Frame", MainFrame)
TabScan.Size = UDim2.new(1, -20, 1, -75)
TabScan.Position = UDim2.new(0, 10, 0, 65)
TabScan.BackgroundTransparency = 1
TabScan.Visible = false

local TabSpectator = Instance.new("Frame", MainFrame)
TabSpectator.Size = UDim2.new(1, -20, 1, -75)
TabSpectator.Position = UDim2.new(0, 10, 0, 65)
TabSpectator.BackgroundTransparency = 1
TabSpectator.Visible = false

local SpecScroll = Instance.new("ScrollingFrame", TabSpectator)
SpecScroll.Size = UDim2.new(1, 0, 1, -120)
SpecScroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
SpecScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SpecScroll.ScrollBarThickness = 2
local SpecList = Instance.new("UIListLayout", SpecScroll); SpecList.Padding = UDim.new(0, 4)
SpecList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	SpecScroll.CanvasSize = UDim2.new(0, 0, 0, SpecList.AbsoluteContentSize.Y)
end)

local SelectedPlayerLabel = Instance.new("TextLabel", TabSpectator)
SelectedPlayerLabel.Size = UDim2.new(1, 0, 0, 30)
SelectedPlayerLabel.Position = UDim2.new(0, 0, 1, -115)
SelectedPlayerLabel.Text = "Selected: None"
SelectedPlayerLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
SelectedPlayerLabel.BackgroundTransparency = 1
SelectedPlayerLabel.Font = Enum.Font.GothamMedium
SelectedPlayerLabel.TextSize = 14

local ScanScroll = Instance.new("ScrollingFrame", TabScan)
ScanScroll.Size = UDim2.new(1, 0, 1, -110)
ScanScroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
ScanScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ScanScroll.ScrollBarThickness = 2
local ScanList = Instance.new("UIListLayout", ScanScroll); ScanList.Padding = UDim.new(0, 4)
ScanList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScanScroll.CanvasSize = UDim2.new(0, 0, 0, ScanList.AbsoluteContentSize.Y)
end)

local StatusLabel = Instance.new("TextLabel", TabScan)
StatusLabel.Size = UDim2.new(1, 0, 0, 35)
StatusLabel.Position = UDim2.new(0, 0, 1, -100)
StatusLabel.Text = "Status: IDLE"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 14

local TabLayout = Instance.new("UIListLayout", TabHolder)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)

local function updateBtn(b, state, onColor)
	b.BackgroundColor3 = state and (onColor or Color3.fromRGB(0, 150, 80)) or Color3.fromRGB(40, 40, 40)
end

local function createBtn(parent, txt, color, func)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1, -5, 0, 40)
	b.Text = txt
	b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 14
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	b.MouseButton1Click:Connect(function() func(b) end)
	return b
end

local btnT1 = createBtn(TabHolder, "FEATURES", Color3.fromRGB(30, 30, 30), function() TabFitur.Visible = true; TabScan.Visible = false; TabSpectator.Visible = false end)
btnT1.Size = UDim2.new(0.33, -5, 1, 0)
btnT1.TextColor3 = Color3.fromRGB(0, 255, 150)

local btnT2 = createBtn(TabHolder, "AI SCANNER", Color3.fromRGB(25, 25, 25), function() TabFitur.Visible = false; TabScan.Visible = true; TabSpectator.Visible = false end)
btnT2.Size = UDim2.new(0.33, -5, 1, 0)
btnT2.TextColor3 = Color3.fromRGB(255, 50, 50)

local btnT3 = createBtn(TabHolder, "SPECTATOR", Color3.fromRGB(25, 25, 25), function() TabFitur.Visible = false; TabScan.Visible = false; TabSpectator.Visible = true end)
btnT3.Size = UDim2.new(0.33, -5, 1, 0)
btnT3.TextColor3 = Color3.fromRGB(0, 150, 255)

-- [[ 5. FEATURES IMPLEMENTATION ]] --
createBtn(TabFitur, "RUN INFINITE YIELD", Color3.fromRGB(100, 0, 255), function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

createBtn(TabFitur, "ORBIT AURA: OFF", nil, function(b)
	orbitActive = not orbitActive
	b.Text = "ORBIT AURA: " .. (orbitActive and "ON" or "OFF")
	updateBtn(b, orbitActive, Color3.fromRGB(0, 255, 255))
	if orbitActive then
		local hl = Instance.new("Highlight", lp.Character)
		hl.Name = "DeltaOrbit"
		task.spawn(function()
			while orbitActive do
				runService.Heartbeat:Wait()
				hl.FillColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
			end
			if lp.Character:FindFirstChild("DeltaOrbit") then lp.Character.DeltaOrbit:Destroy() end
		end)
	end
end)

createBtn(TabFitur, "FLY (SPACE/Q): OFF", nil, function(b)
	flying = not flying
	b.Text = "FLY (SPACE/Q): " .. (flying and "ON" or "OFF")
	updateBtn(b, flying, Color3.fromRGB(0, 120, 255))
	if flying then
		task.spawn(function()
			local hrp = lp.Character.HumanoidRootPart
			lp.Character.Humanoid.PlatformStand = true
			local bg = Instance.new("BodyGyro", hrp); bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			local bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			while flying do
				runService.RenderStepped:Wait()
				local cam = workspace.CurrentCamera.CFrame
				local moveDir = Vector3.new(0, 0, 0)
				if uis:IsKeyDown("W") then moveDir = moveDir + cam.LookVector end
				if uis:IsKeyDown("S") then moveDir = moveDir - cam.LookVector end
				if uis:IsKeyDown("A") then moveDir = moveDir - cam.RightVector end
				if uis:IsKeyDown("D") then moveDir = moveDir + cam.RightVector end
				if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
				if uis:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end
				bv.Velocity = moveDir * flySpeed; bg.CFrame = cam
			end
			bg:Destroy(); bv:Destroy(); lp.Character.Humanoid.PlatformStand = false
		end)
	end
end)

createBtn(TabFitur, "FLING CLOSEST", Color3.fromRGB(200, 0, 50), function()
	local target = nil; local dist = 100
	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local d = (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
			if d < dist then dist = d; target = v end
		end
	end
	if target and not flingActive then
		flingActive = true
		local hrp = lp.Character.HumanoidRootPart
		local oldPos = hrp.CFrame
		task.spawn(function()
			local start = tick()
			while tick() - start < 0.8 do
				runService.Heartbeat:Wait()
				if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
					hrp.CFrame = target.Character.HumanoidRootPart.CFrame
					hrp.Velocity = Vector3.new(0, 50000, 50000)
				end
			end
			flingActive = false; hrp.Velocity = Vector3.new(0,0,0); hrp.CFrame = oldPos
		end)
	end
end)

createBtn(TabFitur, "TP RANDOM PLAYER", Color3.fromRGB(100, 0, 200), function()
	local p = game.Players:GetPlayers()
	local target = p[math.random(#p)]
	if target ~= lp and target.Character then
		lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
	end
end)

createBtn(TabFitur, "CLICK TP (CTRL+LCLICK): OFF", nil, function(b)
	ClickTP = not ClickTP
	b.Text = "CLICK TP: " .. (ClickTP and "ON" or "OFF")
	updateBtn(b, ClickTP, Color3.fromRGB(0, 200, 255))
end)

createBtn(TabFitur, "SERVER SPIN: OFF", nil, function(b)
	spinActive = not spinActive
	b.Text = "SERVER SPIN: " .. (spinActive and "ON" or "OFF")
	updateBtn(b, spinActive, Color3.fromRGB(150, 0, 150))
	local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		if hrp:FindFirstChild("DeltaSpin") then hrp.DeltaSpin:Destroy() end
		if spinActive then
			local av = Instance.new("AngularVelocity", hrp)
			av.Name = "DeltaSpin"; av.MaxTorque = math.huge; av.AngularVelocity = Vector3.new(0, 100, 0)
			av.Attachment0 = hrp:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", hrp)
		end
	end
end)

createBtn(TabFitur, "CHAT SPAM: OFF", nil, function(b)
	Spam = not Spam
	b.Text = "CHAT SPAM: " .. (Spam and "ON" or "OFF")
	updateBtn(b, Spam, Color3.fromRGB(150, 150, 0))
	task.spawn(function()
		while Spam do
			local msg = "NGOHI POWER! ["..math.random(100,999).."]"
			if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
				game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg)
			else
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
			end
			task.wait(3)
		end
	end)
end)

createBtn(TabFitur, "NOCLIP: OFF", nil, function(b)
	noclip = not noclip
	b.Text = "NOCLIP: " .. (noclip and "ON" or "OFF")
	updateBtn(b, noclip, Color3.fromRGB(0, 150, 0))
end)

createBtn(TabFitur, "SPEED 100", Color3.fromRGB(0, 150, 100), function()
	if lp.Character then lp.Character.Humanoid.WalkSpeed = 100 end
end)

createBtn(TabFitur, "INF JUMP: OFF", nil, function(b)
	infJumpActive = not infJumpActive
	b.Text = "INF JUMP: " .. (infJumpActive and "ON" or "OFF")
	updateBtn(b, infJumpActive)
end)

createBtn(TabFitur, "DESTROY ALL GUI", Color3.fromRGB(60, 0, 0), function() MainGui:Destroy() end)

-- [[ 6. ADVANCED REMOTE PANEL ]] --
local ActionPanel = Instance.new("Frame", MainGui)
ActionPanel.Size = UDim2.new(0, 230, 0, 340)
ActionPanel.Position = UDim2.new(0.5, 210, 0.4, -170)
ActionPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ActionPanel.Visible = false
ActionPanel.Active = true
Instance.new("UICorner", ActionPanel)
local ActionStroke = Instance.new("UIStroke", ActionPanel); ActionStroke.Color = Color3.fromRGB(255, 255, 0); ActionStroke.Thickness = 2
makeDraggable(ActionPanel)

local ActionTitle = Instance.new("TextLabel", ActionPanel)
ActionTitle.Size = UDim2.new(1, 0, 0, 45)
ActionTitle.Text = " REMOTE CONTROL"
ActionTitle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ActionTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
ActionTitle.Font = Enum.Font.Code
ActionTitle.TextSize = 13

-- [[ AI FIRE SYSTEM ]] --
local function Fire(rem, target, prop, val)
	-- AI Menentukan apakah harus menggunakan argumen tangkapan atau manual
	local captured = AI_Captured_Data[rem.Name]
	if captured then
		pcall(function()
			local newArgs = table.clone(captured.Args)
			-- AI Mencoba memetakan target ke dalam argumen yang benar
			for i, v in ipairs(newArgs) do
				if typeof(v) == "Instance" and (v:IsA("Player") or v:IsA("Humanoid")) then
					newArgs[i] = target
				end
			end
			rem:FireServer(unpack(newArgs))
		end)
	else
		pcall(function() rem:FireServer(target, prop, val) end)
	end
end

local killBtn = createBtn(ActionPanel, "KILL ALL", Color3.fromRGB(200, 0, 0), function()
	for _, p in pairs(game.Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Humanoid") then
			Fire(CurrentRemote, p.Character.Humanoid, "Health", 0)
		end
	end
end)
killBtn.Position = UDim2.new(0, 5, 0, 55)

local discoBtn = createBtn(ActionPanel, "DISCO MODE", Color3.fromRGB(200, 0, 200), function(b)
	DiscoOn = not DiscoOn
	b.Text = "DISCO: " .. (DiscoOn and "ON" or "OFF")
	if DiscoOn then
		task.spawn(function()
			while DiscoOn do
				local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
				Fire(CurrentRemote, game.Lighting, "Ambient", c)
				Fire(CurrentRemote, game.Lighting, "OutdoorAmbient", c)
				task.wait(0.2)
			end
		end)
	end
end)
discoBtn.Position = UDim2.new(0, 5, 0, 105)

local nightBtn = createBtn(ActionPanel, "NIGHT MODE", Color3.fromRGB(0, 0, 150), function()
	Fire(CurrentRemote, game.Lighting, "ClockTime", 0)
end)
nightBtn.Position = UDim2.new(0, 5, 0, 155)

local closeBtn = createBtn(ActionPanel, "CLOSE PANEL", Color3.fromRGB(50, 50, 50), function() ActionPanel.Visible = false end)
closeBtn.Position = UDim2.new(0, 5, 0, 205)

-- [[ 7. SILENT AI SCANNER ]] --
local function SmartAIAnalysis(rem)
	local name = rem.Name:lower()
	local captured = AI_Captured_Data[rem.Name]
	local vulnerabilityScore = 0
	
	if captured then vulnerabilityScore = vulnerabilityScore + 30 end
	if name:find("admin") or name:find("set") or name:find("give") or name:find("money") then vulnerabilityScore = vulnerabilityScore + 50 end
	if name:find("remote") or name:find("event") then vulnerabilityScore = vulnerabilityScore + 10 end
	if name:find("health") or name:find("damage") or name:find("kill") then vulnerabilityScore = vulnerabilityScore + 40 end

	if vulnerabilityScore >= 50 then return "VULN", Color3.fromRGB(0, 255, 120)
	elseif vulnerabilityScore >= 20 then return "WEAK", Color3.fromRGB(255, 255, 0)
	else return "SAFE", Color3.fromRGB(255, 50, 50) end
end

local function ScanRemotes()
	StatusLabel.Text = "AI Status: Deep Analyzing..."
	for _, v in pairs(ScanScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	
	local allRemotes = {}
	for _, v in pairs(game:GetDescendants()) do
		if v:IsA("RemoteEvent") then table.insert(allRemotes, v) end
	end

	for i, rem in ipairs(allRemotes) do
		local status, color = SmartAIAnalysis(rem)
		local prefix = "[" .. status .. "] "
		
		createBtn(ScanScroll, prefix .. rem.Name, color, function()
			if status ~= "SAFE" then 
				CurrentRemote = rem; ActionPanel.Visible = true; ActionTitle.Text = " TARGET: "..rem.Name
			else StatusLabel.Text = "Status: Remote is strictly protected." end
		end)
		
		if i % 150 == 0 then 
			StatusLabel.Text = "Analyzed: " .. i .. "/" .. #allRemotes
			task.wait(0.1) 
		end
	end
	StatusLabel.Text = "Scan Finished! Found " .. #allRemotes .. " targets."
end

local ScanBtn = createBtn(TabScan, "START SILENT SCAN", Color3.fromRGB(0, 150, 0), ScanRemotes)
ScanBtn.Position = UDim2.new(0, 0, 1, -55)

-- [[ 8. SPECTATOR LOGIC ]] --
local selectedPlayer = nil
local function RefreshPlayerList()
	for _, v in pairs(SpecScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= lp then
			local pBtn = createBtn(SpecScroll, p.Name, nil, function()
				selectedPlayer = p; SelectedPlayerLabel.Text = "Selected: " .. p.Name
			end)
			pBtn.Size = UDim2.new(1, -5, 0, 35)
		end
	end
end

local controlsFrame = Instance.new("Frame", TabSpectator)
controlsFrame.Size = UDim2.new(1, 0, 0, 110); controlsFrame.Position = UDim2.new(0, 0, 1, -110); controlsFrame.BackgroundTransparency = 1

createBtn(controlsFrame, "SPEC", Color3.fromRGB(0, 150, 255), function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid") then
		workspace.CurrentCamera.CameraSubject = selectedPlayer.Character.Humanoid
	end
end).Position = UDim2.new(0, 0, 0, 0)

createBtn(controlsFrame, "TELEPORT TO PLAYER", Color3.fromRGB(100, 0, 200), function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		lp.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
	end
end).Position = UDim2.new(0, 0, 0, 45)

createBtn(controlsFrame, "STOP SPEC", Color3.fromRGB(150, 0, 0), function()
	workspace.CurrentCamera.CameraSubject = lp.Character:FindFirstChild("Humanoid")
end).Position = UDim2.new(0, 0, 0, 90)

task.spawn(function() while true do RefreshPlayerList(); task.wait(5) end end)

-- [[ 9. CORE LOOPS ]] --
mouse.Button1Down:Connect(function()
	if ClickTP and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
		lp.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p) + Vector3.new(0, 3, 0)
	end
end)

runService.Stepped:Connect(function()
	if lp.Character then
		for _, v in pairs(lp.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = not (noclip or flingActive) end
		end
	end
end)

uis.JumpRequest:Connect(function()
	if infJumpActive and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid:ChangeState("Jumping")
	end
end)

print("--- NGOHI HYBRID FINAL ABSOLUTE LOADED WITH AI ---")
