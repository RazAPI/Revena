--[[
    File.: Fling GUI.luau
    Author.: scuba#0001 (original), rewritten by Raz
    Description.: Fling GUI script optimized & designed for Revena.
]]

--// Services
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--// Aliases
local Heartbeat = RunService.Heartbeat
local LocalPlayer = Players.LocalPlayer

--// Executor / environment check
local RevenaUserDirectory = CoreGui:FindFirstChild("RobloxGui").Modules.Shell.Components.Overscan

do
    local ExecutorName = (getexecutorname and getexecutorname()) or (identifyexecutor and identifyexecutor())

    if ExecutorName ~= "Revena" or RevenaUserDirectory:FindFirstChild("REVENA_MAIN_SCRIPT_DIR") == nil then
        return "Unsupported Script"
    end
end

--// Helpers
local function GetTarget(String)
    if String == "" then
        return {}
    end

    local Lowered = String:lower()
    local AllPlayers = Players:GetPlayers()
    local Found = {}

    local Predicate
    --// simplifying this because the old code was so long
    if Lowered == "all" then
        Predicate = function() return true end
    elseif Lowered == "others" then
        Predicate = function(Player) return Player ~= LocalPlayer end
    elseif Lowered == "me" then
        Predicate = function(Player) return Player == LocalPlayer end
    else
        Predicate = function(Player)
            return Player.Name:lower():sub(1, #Lowered) == Lowered
        end
    end

    for Numberof, Player in AllPlayers do
        if Predicate(Player) then
            Found[#Found + 1] = Player
        end
    end

    return Found
end

local function Notify(String, Duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Fling Gui",
            Text = String,
            Icon = "rbxassetid://2005276185",
            Duration = Duration or 3
        })
    end)
end

local function NewObject(Class, Properties)
    local Object = Instance.new(Class)

    for Key, Value in Properties do
        Object[Key] = Value
    end

    return Object
end

--// UI
local Loader = os.clock()

local FlingGui = NewObject("ScreenGui", {
    Name = "FlingGui",
    Parent = RevenaUserDirectory:FindFirstChild("REVENA_MAIN_SCRIPT_DIR"),
    IgnoreGuiInset = true,
    DisplayOrder = 50,
    ResetOnSpawn = false
})

local Main = NewObject("ImageLabel", {
    Name = "Main",
    Parent = FlingGui,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    Position = UDim2.new(0.174545452, 0, 0.459574461, 0),
    Size = UDim2.new(0, 454, 0, 218),
    Image = "rbxassetid://2005276185"
})

local DragDetector = NewObject("UIDragDetector", { Parent = Main })

local Top = NewObject("Frame", {
    Name = "Top",
    Parent = Main,
    BackgroundColor3 = Color3.fromRGB(57, 57, 57),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 454, 0, 44)
})

local Title = NewObject("TextLabel", {
    Name = "Title",
    Parent = Top,
    BackgroundColor3 = Color3.fromRGB(49, 49, 49),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0.295454562, 0),
    Size = UDim2.new(0, 454, 0, 30),
    Font = Enum.Font.SourceSans,
    Text = "Yeet GUI",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextScaled = true,
    TextSize = 14,
    TextWrapped = true
})

local TextBox = NewObject("TextBox", {
    Name = "TargetBox",
    Parent = Main,
    BackgroundColor3 = Color3.fromRGB(49, 49, 49),
    BorderSizePixel = 0,
    Position = UDim2.new(0.0704845786, 0, 0.270642221, 0),
    Size = UDim2.new(0, 388, 0, 62),
    Font = Enum.Font.SourceSans,
    Text = "",
    PlaceholderText = "Who Do I Destroy(can be shortened)",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextScaled = true,
    TextSize = 14,
    TextWrapped = true
})

local TextButton = NewObject("TextButton", {
    Name = "CheeseButton",
    Parent = Main,
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(49, 49, 49),
    Position = UDim2.new(0.10352423, 0, 0.596330225, 0),
    Size = UDim2.new(0, 359, 0, 50),
    Font = Enum.Font.SourceSans,
    Text = "Cheese Em'",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextScaled = true,
    TextSize = 14,
    TextWrapped = true
})

--// Fling logic
TextButton.MouseButton1Click:Connect(function()
    local Target = GetTarget(TextBox.Text)[1]

    if not Target then
        Notify("Player Not Found", 1.5)
        return
    end

    local LocalPlayerChar = LocalPlayer.Character
    local TargetChar = Target.Character

    if not LocalPlayerChar or not TargetChar or not LocalPlayerChar:FindFirstChild("HumanoidRootPart") or not TargetChar:FindFirstChild("HumanoidRootPart") then
        Notify("Failed to find Humanoid\n(because you, or the player may be dead)")
        return
    end

    local Thrust = NewObject("BodyThrust", { Name = "YEET!", Parent = LocalPlayerChar.HumanoidRootPart, Force = Vector3.new(9999, 9999, 9999) })

    repeat
        LocalPlayerChar = LocalPlayer.Character
        TargetChar = Target.Character

        if not LocalPlayerChar or not TargetChar then
            break
        end

        local LocalPlayerRoot = LocalPlayerChar.HumanoidRootPart
        local TargetRoot = TargetChar.HumanoidRootPart

        if not LocalPlayerRoot or not TargetRoot then
            break
        end

        LocalPlayerRoot.CFrame = TargetRoot.CFrame
        Thrust.Location = TargetRoot.Position

        Heartbeat:Wait()
    until not TargetChar or not TargetChar.Head
    Thrust:Destroy()
end)

--// Loaded
Notify("Loaded in " .. (os.clock() - Loader) * 1000 .. "ms")
