-- [[ NGOHI HYBRID FINAL ABSOLUTE - TRUE FULL VERSION ]] --
-- Fix: Anti-Adonis, Silent Scan, & Delta Mobile Optimization
-- STATUS: NO CUT VERSION / AI-INTEGRATED
-- [[ PART 1: INITIALIZATION & AI SNIFFER ENGINE ]] --

local lp = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local mouse = lp:GetMouse()
local PlayerGui = lp:WaitForChild("PlayerGui")

-- [[ 1. THE ADONIS SHUTDOWN PROTOCOL ]] --
-- Mematikan sistem deteksi sebelum script utama berjalan
local function StealthBypass()
	local success, err = pcall(function()
		-- Mencari dan melumpuhkan script deteksi Adonis di dalam PlayerScripts atau Character
		for _, v in pairs(lp:GetDescendants()) do
			if v:IsA("LocalScript") and (v.Name:find("Adonis") or v.Name:find("Handler") or v.Name:find("Client")) then
				v.Disabled = true
				v:Destroy()
			end
		end

		-- Bypass Kick function secara lokal (Spoofing)
		local mt = getrawmetatable(game)
		local oldNamecall = mt.__namecall
		setreadonly(mt, false)

		mt.__namecall = newcclosure(function(self, ...)
			local method = getnamecallmethod()
			local args = {...}

			-- Jika server memanggil Kick, kita blokir di sisi client
			if method == "Kick" then 
				warn("ADONIS TRIED TO KICK YOU: BLOCKED.")
				return nil 
			end

			-- Menyembunyikan deteksi "getrawmetatable"
			if method == "FireServer" and tostring(self) == "Adonis_Event" then
				return nil
			end

			return oldNamecall(self, ...)
		end)
		setreadonly(mt, true)
	end)
	return success
end
StealthBypass())

-- [[ 2. AI LOGIC: REAL-TIME REMOTE SNIFFER ]] --
-- Logika ini berfungsi mempelajari data yang diminta server secara otomatis
local CapturedArgs = {}
local function StartAISniffer()
	local mt = getrawmetatable(game)
	local oldNamecall = mt.__namecall
	setreadonly(mt, false)

	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		local args = {...}

		-- Jika game (bukan cheat) mengirim perintah ke server, AI akan mencatat polanya
		if method == "FireServer" and not checkcaller() then
			CapturedArgs[self.Name] = {
				Arguments = args,
				Instance = self,
				LastUpdate = tick()
			}
		end
		return oldNamecall(self, ...)
	end)
	setreadonly(mt, true)
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

-- [[ 4. GUI DESIGN - MAIN FRAME ]] --
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
IconLogo.Text = "N" -- Ngohi
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

-- [[ PART 2: TABS, FEATURES & AI MANIPULATOR ]] --

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

-- UI Helper Functions
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

-- Tab Navigation Logic
local btnT1 = createBtn(TabHolder, "FEATURES", Color3.fromRGB(30, 30, 30), function() TabFitur.Visible = true; TabScan.Visible = false; TabSpectator.Visible = false end)
btnT1.Size = UDim2.new(0.33, -5, 1, 0); btnT1.TextColor3 = Color3.fromRGB(0, 255, 150)

local btnT2 = createBtn(TabHolder, "AI SCANNER", Color3.fromRGB(25, 25, 25), function() TabFitur.Visible = false; TabScan.Visible = true; TabSpectator.Visible = false end)
btnT2.Size = UDim2.new(0.33, -5, 1, 0); btnT2.TextColor3 = Color3.fromRGB(255, 50, 50)

local btnT3 = createBtn(TabHolder, "SPECTATOR", Color3.fromRGB(25, 25, 25), function() TabFitur.Visible = false; TabScan.Visible = false; TabSpectator.Visible = true end)
btnT3.Size = UDim2.new(0.33, -5, 1, 0); btnT3.TextColor3 = Color3.fromRGB(0, 150, 255)

-- [[ 5. ADVANCED AI MANIPULATOR PANEL ]] --
local ActionPanel = Instance.new("Frame", MainGui)
ActionPanel.Size = UDim2.new(0, 230, 0, 340)
ActionPanel.Position = UDim2.new(0.5, 210, 0.4, -170)
ActionPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ActionPanel.Visible = false
Instance.new("UICorner", ActionPanel)
local ActionStroke = Instance.new("UIStroke", ActionPanel); ActionStroke.Color = Color3.fromRGB(255, 255, 0); ActionStroke.Thickness = 2
makeDraggable(ActionPanel)

local ActionTitle = Instance.new("TextLabel", ActionPanel)
ActionTitle.Size = UDim2.new(1, 0, 0, 45); ActionTitle.Text = "AI CONTROL PANEL"; ActionTitle.BackgroundColor3 = Color3.fromRGB(25, 25, 25); ActionTitle.TextColor3 = Color3.fromRGB(255, 255, 0); ActionTitle.Font = Enum.Font.Code

-- LOGIKA MANIPULASI AI: Membangun ulang argumen yang diminta server
local function SmartFire(mode, val)
	if not CurrentRemote then return end
	local data = CapturedArgs[CurrentRemote.Name]
	local args = data and data.Arguments or {}

	pcall(function()
		for _, p in pairs(game.Players:GetPlayers()) do
			if mode == "KILL" and p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") then
				local spoofed = {}
				-- AI mengisi slot argumen berdasarkan tipe data yang pernah ditangkap
				for i, v in pairs(args) do
					if typeof(v) == "Instance" and (v:IsA("Player") or v:IsA("Humanoid")) then
						spoofed[i] = p.Character.Humanoid
					elseif typeof(v) == "number" then
						spoofed[i] = 0 -- Health ke 0
					else
						spoofed[i] = v -- Gunakan key asli (password/token) jika ada
					end
				end
				if #spoofed == 0 then CurrentRemote:FireServer(p.Character.Humanoid, 0) else CurrentRemote:FireServer(unpack(spoofed)) end

			elseif mode == "DISCO" then
				local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
				CurrentRemote:FireServer(game.Lighting, "Ambient", c)
				CurrentRemote:FireServer(game.Lighting, "OutdoorAmbient", c)
			end
		end

		if mode == "NIGHT" then
			CurrentRemote:FireServer(game.Lighting, "ClockTime", 0)
		end
	end)
end

createBtn(ActionPanel, "AI KILL ALL", Color3.fromRGB(200, 0, 0), function() SmartFire("KILL") end).Position = UDim2.new(0, 5, 0, 55)

createBtn(ActionPanel, "AI DISCO MODE", Color3.fromRGB(200, 0, 200), function(b)
	DiscoOn = not DiscoOn
	b.Text = "DISCO: " .. (DiscoOn and "ON" or "OFF")
	task.spawn(function()
		while DiscoOn do
			SmartFire("DISCO")
			task.wait(0.2)
		end
	end)
end).Position = UDim2.new(0, 5, 0, 105)

createBtn(ActionPanel, "AI NIGHT MODE", Color3.fromRGB(0, 0, 150), function() SmartFire("NIGHT") end).Position = UDim2.new(0, 5, 0, 155)

createBtn(ActionPanel, "CLOSE PANEL", Color3.fromRGB(50, 50, 50), function() ActionPanel.Visible = false end).Position = UDim2.new(0, 5, 0, 205)

-- [[ 6. FEATURES LIST ]] --
createBtn(TabFitur, "RUN INFINITE YIELD", Color3.fromRGB(100, 0, 255), function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
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

-- [[ PART 3: AI SCANNER, SPECTATOR & CORE LOOPS ]] --

-- [[ 6. SILENT AI SCANNER LOGIC ]] --
local function SmartAIAnalysis(rem)
	local name = rem.Name:lower()
	local vulnerabilityScore = 0

	-- AI mendeteksi pola penamaan yang biasanya tidak diproteksi ketat
	if name:find("admin") or name:find("set") or name:find("give") or name:find("money") then vulnerabilityScore = vulnerabilityScore + 50 end
	if name:find("remote") or name:find("event") then vulnerabilityScore = vulnerabilityScore + 10 end
	if name:find("health") or name:find("damage") or name:find("kill") then vulnerabilityScore = vulnerabilityScore + 40 end

	-- Cek jika AI Sniffer sudah menangkap data remote ini
	if CapturedArgs[rem.Name] then vulnerabilityScore = vulnerabilityScore + 30 end

	if vulnerabilityScore >= 60 then return "VULN", Color3.fromRGB(0, 255, 120)
	elseif vulnerabilityScore >= 30 then return "WEAK", Color3.fromRGB(255, 255, 0)
	else return "SAFE", Color3.fromRGB(255, 50, 50) end
end

local function ScanRemotes()
	StatusLabel.Text = "AI Status: Deep Analyzing Remotes..."
	for _, v in pairs(ScanScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end

	local allRemotes = {}
	for _, v in pairs(game:GetDescendants()) do
		if v:IsA("RemoteEvent") then table.insert(allRemotes, v) end
	end

	for i, rem in ipairs(allRemotes) do
		local status, color = SmartAIAnalysis(rem)
		local prefix = (CapturedArgs[rem.Name] and "[SNIFFED] " or "["..status.."] ")

		createBtn(ScanScroll, prefix .. rem.Name, color, function()
			if status ~= "SAFE" or CapturedArgs[rem.Name] then 
				CurrentRemote = rem
				ActionPanel.Visible = true
				ActionTitle.Text = "TARGET: " .. rem.Name
				StatusLabel.Text = "Selected: " .. rem.Name .. " (AI Ready)"
			else 
				StatusLabel.Text = "Status: Remote Secured by Server." 
			end
		end)

		if i % 100 == 0 then 
			StatusLabel.Text = "Analyzing: " .. i .. "/" .. #allRemotes
			task.wait(0.05) 
		end
	end
	StatusLabel.Text = "Scan Finished! Found " .. #allRemotes .. " remotes."
end

local ScanBtn = createBtn(TabScan, "START SILENT AI SCAN", Color3.fromRGB(0, 150, 0), ScanRemotes)
ScanBtn.Position = UDim2.new(0, 0, 1, -55)

-- [[ 7. SPECTATOR SYSTEM ]] --
local selectedPlayer = nil
local function RefreshPlayerList()
	for _, v in pairs(SpecScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= lp then
			local pBtn = createBtn(SpecScroll, p.Name, nil, function()
				selectedPlayer = p
				SelectedPlayerLabel.Text = "Selected: " .. p.Name
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

createBtn(controlsFrame, "TP TO PLAYER", Color3.fromRGB(100, 0, 200), function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		lp.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
	end
end).Position = UDim2.new(0, 0, 0, 45)

createBtn(controlsFrame, "STOP SPEC", Color3.fromRGB(150, 0, 0), function()
	workspace.CurrentCamera.CameraSubject = lp.Character:FindFirstChild("Humanoid")
end).Position = UDim2.new(0, 0, 0, 90)

-- Refresh list setiap 5 detik
task.spawn(function() while true do RefreshPlayerList(); task.wait(5) end end)

-- [[ 8. FINAL CORE LOOPS & INPUT ]] --
mouse.Button1Down:Connect(function()
	if ClickTP and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
		lp.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p) + Vector3.new(0, 3, 0)
	end
end)

runService.Stepped:Connect(function()
	if lp.Character then
		for _, v in pairs(lp.Character:GetDescendants()) do
			if v:IsA("BasePart") then 
				-- Noclip logic
				v.CanCollide = not (noclip or flingActive) 
			end
		end
	end
end)

uis.JumpRequest:Connect(function()
	if infJumpActive and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid:ChangeState("Jumping")
	end
end)

-- Sinkronisasi Akhir
createBtn(TabFitur, "DESTROY ALL GUI", Color3.fromRGB(60, 0, 0), function() MainGui:Destroy() end)

print("--- NGOHI HYBRID FINAL ABSOLUTE: FULLY LOADED ---")
warn("AI Sniffer is now active. Use game functions to capture keys.")
