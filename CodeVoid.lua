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
local safeBasePath = "/workspace/"
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

-- Identifikation für UNC-Test
getgenv().getUNCIdentifier = function()
    return "CodeVoid - Secure Mode"
end

-- Aktivierung der Schutzmechanismen
preventDebugging()
warn("[CodeVoid]: Schutzmechanismen aktiviert")
