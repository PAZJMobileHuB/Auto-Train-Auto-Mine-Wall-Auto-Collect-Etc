-- Mine Per Click - Auto Clicker with Rayfield GUI
-- Roblox Game Automation Script

-- Rayfield Library Integration
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "⛏️ Mine Per Click Auto Clicker",
    LoadingTitle = "Loading Auto Clicker...",
    LoadingSubtitle = "by PAZJMobileHuB",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RayfieldConfig",
        FileName = "MinePerClickConfig"
    },
    IntroEnabled = true,
    IntroText = "Welcome to Mine Per Click Auto Clicker!",
    IntroIcon = "rbxassetid://4483345998",
    CloseCallback = function()
        print("Auto Clicker window closed")
    end,
})

-- Define local variables for settings
local Settings = {
    AutoClickerEnabled = false,
    ClickSpeed = 0.1,
    ClickMode = "Single", -- Single, Double, Triple, Continuous
    TargetDistance = 50,
    AutoSearchTarget = true,
    ShowNotifications = true,
    ClickCount = 0,
    SessionStartTime = os.time()
}

-- Create Main Tab
local MainTab = Window:CreateTab("🎮 Auto Clicker", 4483345998)

-- Toggle for Auto Clicker
MainTab:CreateToggle({
    Name = "Enable Auto Clicker",
    CurrentValue = false,
    Flag = "AutoClickerToggle",
    Callback = function(Value)
        Settings.AutoClickerEnabled = Value
        if Value then
            if Settings.ShowNotifications then
                Rayfield:Notify({
                    Title = "✅ Auto Clicker Enabled",
                    Content = "Click speed: " .. Settings.ClickSpeed .. "s",
                    Duration = 2,
                    Image = 4483345998,
                })
            end
        else
            if Settings.ShowNotifications then
                Rayfield:Notify({
                    Title = "❌ Auto Clicker Disabled",
                    Content = "Total clicks: " .. Settings.ClickCount,
                    Duration = 2,
                    Image = 4483345998,
                })
            end
        end
    end,
})

-- Click Speed Slider
MainTab:CreateSlider({
    Name = "Click Speed (Seconds)",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.1,
    Flag = "ClickSpeedSlider",
    Callback = function(Value)
        Settings.ClickSpeed = Value
    end,
})

-- Click Mode Dropdown
MainTab:CreateDropdown({
    Name = "Click Mode",
    Options = {"Single", "Double", "Triple", "Continuous"},
    CurrentOption = {"Single"},
    MultipleOptions = false,
    Flag = "ClickModeDropdown",
    Callback = function(Options)
        Settings.ClickMode = Options[1]
    end,
})

-- Target Distance Slider
MainTab:CreateSlider({
    Name = "Target Search Distance",
    Range = {10, 200},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 50,
    Flag = "TargetDistanceSlider",
    Callback = function(Value)
        Settings.TargetDistance = Value
    end,
})

-- Auto Search Toggle
MainTab:CreateToggle({
    Name = "Auto Search for Targets",
    CurrentValue = true,
    Flag = "AutoSearchToggle",
    Callback = function(Value)
        Settings.AutoSearchTarget = Value
    end,
})

-- Statistics Tab
local StatsTab = Window:CreateTab("📊 Statistics", 6026568198)

local ClickCountLabel = StatsTab:CreateLabel("Total Clicks: 0")
local ClickSpeedLabel = StatsTab:CreateLabel("Current Speed: 0.1s")
local SessionTimeLabel = StatsTab:CreateLabel("Session Time: 0s")
local TargetStatusLabel = StatsTab:CreateLabel("Target Status: Waiting...")

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 7734068982)

SettingsTab:CreateToggle({
    Name = "Show Notifications",
    CurrentValue = true,
    Flag = "NotificationsToggle",
    Callback = function(Value)
        Settings.ShowNotifications = Value
    end,
})

SettingsTab:CreateButton({
    Name = "Reset Click Counter",
    Callback = function()
        Settings.ClickCount = 0
        Settings.SessionStartTime = os.time()
        if Settings.ShowNotifications then
            Rayfield:Notify({
                Title = "✅ Counter Reset",
                Content = "Click counter has been reset to 0",
                Duration = 2,
                Image = 4483345998,
            })
        end
    end,
})

SettingsTab:CreateButton({
    Name = "Clear Config",
    Callback = function()
        -- Clear saved configuration
        if Settings.ShowNotifications then
            Rayfield:Notify({
                Title = "✅ Config Cleared",
                Content = "Configuration has been reset",
                Duration = 2,
                Image = 4483345998,
            })
        end
    end,
})

-- Helper Functions
local function GetNearestTarget()
    local character = game.Players.LocalPlayer.Character
    if not character then return nil end
    
    local playerPos = character:FindFirstChild("HumanoidRootPart")
    if not playerPos then return nil end
    
    local nearestTarget = nil
    local nearestDistance = Settings.TargetDistance
    
    -- Search for clickable objects (adjust based on your game)
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:match("Mine") or part.Name:match("Rock") or part.Name:match("Ore") then
            if not part:IsDescendantOf(character) then
                local distance = (part.Position - playerPos.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestTarget = part
                end
            end
        end
    end
    
    return nearestTarget
end

local function PerformClick(target)
    if not target then return end
    
    local mousePos = game:GetService("RunService").Stepped:Wait()
    local camera = workspace.CurrentCamera
    local screenPos, onScreen = camera:WorldToScreenPoint(target.Position)
    
    if onScreen then
        -- Get mouse and simulate click
        local mouse = game.Players.LocalPlayer:GetMouse()
        mouse.Target = target
        mouse.Hit = target.CFrame
        
        -- Trigger click events
        game:GetService("UserInputService"):SendKeyEvent(true, Enum.KeyCode.E, false)
        game:GetService("UserInputService"):SendKeyEvent(false, Enum.KeyCode.E, false)
        
        Settings.ClickCount = Settings.ClickCount + 1
    end
end

local function ExecuteClickMode()
    if not Settings.AutoClickerEnabled then return end
    
    local target = Settings.AutoSearchTarget and GetNearestTarget() or workspace:FindFirstChild("Mine")
    
    if not target then
        TargetStatusLabel:Set("Target Status: No target found")
        return
    end
    
    TargetStatusLabel:Set("Target Status: Clicking " .. target.Name)
    
    if Settings.ClickMode == "Single" then
        PerformClick(target)
    elseif Settings.ClickMode == "Double" then
        PerformClick(target)
        wait(0.05)
        PerformClick(target)
    elseif Settings.ClickMode == "Triple" then
        PerformClick(target)
        wait(0.05)
        PerformClick(target)
        wait(0.05)
        PerformClick(target)
    elseif Settings.ClickMode == "Continuous" then
        PerformClick(target)
    end
end

-- Main Loop
local lastUpdateTime = os.time()
game:GetService("RunService").Heartbeat:Connect(function()
    if Settings.AutoClickerEnabled then
        ExecuteClickMode()
        wait(Settings.ClickSpeed)
    end
    
    -- Update statistics every second
    local currentTime = os.time()
    if currentTime - lastUpdateTime >= 1 then
        ClickCountLabel:Set("Total Clicks: " .. Settings.ClickCount)
        ClickSpeedLabel:Set("Current Speed: " .. Settings.ClickSpeed .. "s")
        SessionTimeLabel:Set("Session Time: " .. (currentTime - Settings.SessionStartTime) .. "s")
        lastUpdateTime = currentTime
    end
end)

-- Notification on load
Rayfield:Notify({
    Title = "✅ Auto Clicker Loaded",
    Content = "Ready to start mining! Enable Auto Clicker to begin.",
    Duration = 3,
    Image = 4483345998,
})

print("Mine Per Click Auto Clicker loaded successfully!")
