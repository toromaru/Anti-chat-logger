if not game:IsLoaded() then
    game.Loaded:Wait()
end

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Icon = "rbxassetid://2541869220",
        Duration = 5
    })
end

local function ProtectGui(gui)
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    else
        gui.Parent = CoreGui
    end
end

pcall(function()
    if setfflag then
        setfflag("AbuseReportScreenshot", "False")
        setfflag("AbuseReportScreenshotPercentage", "0")
    end
end)
local function HookLegacyChat()
    local PlayerScripts = Player:WaitForChild("PlayerScripts")
    local ChatMain = PlayerScripts:FindFirstChild("ChatMain", true)

    if ChatMain then
        local PostMessage = require(ChatMain).MessagePosted
        if PostMessage then
            local OldFire
            OldFire = hookfunction(PostMessage.fire, function(self, message)
                if not checkcaller() and self == PostMessage then
                    return OldFire(self, message)
                end
                return OldFire(self, message)
            end)
            return true
        end
    end
    return false
end

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() and method == "SetCoreGuiEnabled" then
        if args[1] == Enum.CoreGuiType.Chat or args[1] == Enum.CoreGuiType.All then
            return 
        end
    end

    return OldNamecall(self, ...)
end)

task.spawn(function()
    local success = HookLegacyChat()
    if success then
        print("Legacy Chat Hooked Successfully.")
    else
        warn("Legacy Chat not found or using TextChatService.")
    end
    
    Notify("ACL Loaded", "修正版アンチチャットロガーが読み込まれました。")
end)
