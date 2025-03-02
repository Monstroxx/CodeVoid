-- CodeVoid Protected Script
-- Dieses Skript bietet Schutzmechanismen gegen IP-Leaks, Logging, Debugging und unerwünschte Dateioperationen.
-- Identifiziert sich als "CodeVoid" bei UNC-Tests.

-- Globale Variablen
getgenv().IS_CODEVOID_LOADED = true
getgenv().shared = shared or {}

-- Dienste
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- UI-Schutz mit gethui()
local function getSafeUI()
    return gethui() or CoreGui
end

-- Schutzmechanismen
local blockedURLs = {
    "https://v4.ident.me",
    "http://ip-api.com/json",
    "https://ipinfo.io",
    "http://checkip.amazonaws.com"
}

local protectedResponse = {
    Success = true,
    StatusCode = 200,
    StatusMessage = "OK",
    Body = "{\"CodeVoid\": \"Protected\"}",
    Headers = {}
}

-- URL-Filter
local function isBlockedURL(url)
    for _, blocked in ipairs(blockedURLs) do
        if string.find(url:lower(), blocked:lower(), 1, true) then
            return true
        end
    end
    return false
end

-- Gesicherte HTTP-Anfragen
getgenv().safeRequest = function(options)
    if isBlockedURL(options.Url) then
        warn("[CodeVoid]: Blockierte Anfrage an " .. options.Url)
        return protectedResponse
    end
    return HttpService:RequestInternal(options)
end

-- Schutz vor unsicheren Dateioperationen
local safeBasePath = "folder/workspace/"
local blockedExtensions = {".exe", ".bat", ".dll", ".cmd", ".scr", ".msi", ".vbs", ".ps1"}

local function isSafePath(path)
    if not string.find(path, safeBasePath, 1, true) then
        return false
    end
    for _, ext in ipairs(blockedExtensions) do
        if string.sub(path, -#ext) == ext then
            return false
        end
    end
    return true
end

getgenv().safeWriteFile = function(filename, data)
    if isSafePath(filename) then
        writefile(filename, data)
    else
        warn("[CodeVoid]: Unsicherer Schreibversuch blockiert: " .. filename)
    end
end

getgenv().safeReadFile = function(filename)
    if isSafePath(filename) then
        return readfile(filename)
    else
        warn("[CodeVoid]: Unsicherer Leseversuch blockiert: " .. filename)
        return nil
    end
end

-- Schutz vor Debugging
getgenv().preventDebugging = function()
    local blockedFunctions = {"debug.info", "debug.traceback", "debug.getupvalue"}
    for _, func in ipairs(blockedFunctions) do
        _G[func] = function()
            warn("[CodeVoid]: Debugging-Funktion blockiert")
            return nil
        end
    end
end

-- Virtuelle Eingaben
getgenv().virtualKeyPress = function(key)
    UserInputService.InputBegan:Fire({UserInputType = Enum.UserInputType.Keyboard, KeyCode = key})
end

-- Sicheres UI erstellen
getgenv().createSecureUI = function()
    local gui = Instance.new("ScreenGui")
    gui.Name = "SecureUI"
    gui.Parent = getSafeUI()
    return gui
end

-- Erfolgsnachricht anzeigen (ähnlich Roblox-Achievement Popup)
getgenv().showInjectionSuccess = function()
    frame.Parent = gui
    frame.Size = UDim2.new(0.15, 0, 0.06, 0) -- Compact size
    frame.Position = UDim2.new(0.425, 0, -0.2, 0) -- Starts above screen for animation
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Solid dark background
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0 -- Fully solid
    frame.ClipsDescendants = true
    
    -- Slightly smoother corners (but still mostly sharp)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.08, 0) -- A little more rounded than before
    corner.Parent = frame
    
    -- Function to create text labels
    local function createTextLabel(parent, text, position, size, fontSize, font)
        local label = Instance.new("TextLabel")
        label.Parent = parent
        label.Size = size
        label.Position = position
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1
        label.Font = font
        label.TextScaled = true
        label.TextSize = fontSize
        label.TextWrapped = true
        return label
    end
    
    -- Title (Bold)
    local title = createTextLabel(frame, "[CodeVoid]", UDim2.new(0, 0, 0, 2), UDim2.new(1, 0, 0.3, 0), 10, Enum.Font.GothamBold)
    
    -- Message (SemiBold)
    local message = createTextLabel(frame, "INJECTED", UDim2.new(0, 0, 0.35, 0), UDim2.new(1, 0, 0.3, 0), 8, Enum.Font.GothamSemibold)
    
    -- Update info (SemiBold)
    local update = createTextLabel(frame, "UPDATE v1.0", UDim2.new(0, 0, 0.7, 0), UDim2.new(1, 0, 0.2, 0), 7, Enum.Font.GothamSemibold)
    
    -- Smooth drop-in animation
    frame:TweenPosition(UDim2.new(0.425, 0, 0.05, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true)
    task.wait(0.5)
    
    -- Stay on screen
    task.wait(4)
    
    -- Fade out animation
    for i = 0, 1, 0.1 do
        frame.BackgroundTransparency = i
        title.TextTransparency = i
        message.TextTransparency = i
        update.TextTransparency = i
        task.wait(0.05)
    end
    
    gui:Destroy()
   end)
end

-- Identifikation für UNC-Test
getgenv().getUNCIdentifier = function()
    return "CodeVoid - Secure Mode"
end

-- Testweise Ausgabe für UNC-Check
print("[CodeVoid]: UNC Identifier = " .. getgenv().getUNCIdentifier())

-- Aktivierung der Schutzmechanismen
preventDebugging()
--warn("[CodeVoid]: Schutzmechanismen aktiviert")

-- UI anzeigen
showInjectionSuccess()

--wait(1)
--loadstring(game:HttpGet("https://raw.githubusercontent.com/Monstroxx/CodeVoid/refs/heads/main/injectPopup.lua"))()
