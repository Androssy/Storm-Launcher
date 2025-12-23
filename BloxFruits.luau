repeat
    task.wait()
until game:IsLoaded()
local a, b, c = game:GetService("HttpService"), game:GetService("Players"), game:GetService("ReplicatedStorage")
local d = b.LocalPlayer
local e = d:WaitForChild("Data")
local f = 3030
local g = request
local h = function(i, ...)
    return c.Remotes.CommF_:InvokeServer(i, ...)
end
local j = function(k)
    pcall(function()
        g({
            Url = string.format("http://localhost:%d/api/accounts/description", f),
            Method = "PUT",
            Headers = { ["Content-Type"] = "application/json" },
            Body = a:JSONEncode({ username = d.Name, description = k }),
        })
    end)
end
local l = function(m)
    local n = d:FindFirstChild("Backpack")
    if not n then
        return false
    end
    if n:FindFirstChild(m) then
        return true
    end
    local o = d.Character and d.Character:FindFirstChildOfClass("Tool")
    if o and o.Name == m then
        return true
    end
    for _, p in pairs(h("getInventory") or {}) do
        if tostring(p.Name) == m then
            return true
        end
    end
    return false
end
local q = function()
    local r = tostring(e.Race.Value)
    if e.Race:FindFirstChild("Evolved") then
        r = r .. " [V2]"
    end
    if h("Wenlocktoad", "info") == -2 then
        r = r .. " [V3]"
    end
    if d.Character and d.Character:FindFirstChild("RaceTransformed") then
        r = r .. " [V4]"
        local _, s = h("UpgradeRace", "Check")
        r = r .. " [T" .. tostring(s) .. "]"
    end
    return r
end
local t = function(u)
    u = tonumber(u)
    if not u then
        return "0"
    end
    if u >= 1e9 then
        return (string.format("%.1fb", u / 1e9):gsub("%.0", ""))
    elseif u >= 1e6 then
        return (string.format("%.1fm", u / 1e6):gsub("%.0", ""))
    elseif u >= 1e3 then
        return (string.format("%.1fk", u / 1e3):gsub("%.0", ""))
    else
        return tostring(u)
    end
end
local v = function()
    return tostring(e.Fragments.Value), tostring(e.Beli.Value)
end
local w = function(x, y)
    local n = d:FindFirstChild("Backpack")
    if not n then
        return false
    end
    if n:FindFirstChild(x) then
        return true
    end
    local o = d.Character and d.Character:FindFirstChildOfClass("Tool")
    if o and o.Name == x then
        return true
    end
    x = x:gsub(" ", "")
    if y then
        return false
    end
    local z = (x == "DragonClaw") and h("BlackbeardReward", "DragonClaw", "1") or h("Buy" .. tostring(x), true)
    return (z == 1 or z == 2) or false
end
local A = function()
    local n = d:FindFirstChild("Backpack")
    if not n then
        return {}
    end
    local B = {}
    local function C(D)
        for _, E in ipairs(D:GetChildren()) do
            if E:IsA("Tool") and E.ToolTip == "Blox Fruit" and E:FindFirstChild("AwakenedMoves") then
                for _, F in ipairs(E.AwakenedMoves:GetChildren()) do
                    table.insert(B, F.Name)
                end
            end
        end
    end
    C(n)
    if d.Character then
        C(d.Character)
    end
    return B
end
local G = function()
    local H = e.DevilFruit.Value
    if H == "" then
        return "None"
    end
    local I = A()
    if #I > 0 then
        return H .. " | Awakened Moves: " .. table.concat(I, ", ")
    end
    return H
end
local J = { "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman", "Sanguine Art" }
local K = function()
    local L = 0
    for _, M in ipairs(J) do
        if w(M, false) then
            L += 1
        end
    end
    local N, O = v()
    local P = string.format(
        "🏆 Level: %s | 🥊 Melee [%d/%d] | 💰 Beli: %s | 💎 Fragments: %s | 🧬 Race: %s | 🪞 Mirror: %s | 👑 Valkyrie: %s | ⚙️ Lever: %s | 🍏 Fruit: %s",
        tostring(e.Level.Value),
        L,
        #J,
        t(O),
        t(N),
        q(),
        l("Mirror Fractal") and "✅" or "❌",
        l("Valkyrie Helm") and "✅" or "❌",
        h("CheckTempleDoor") and "✅" or "❌",
        G()
    )
    j(P)
end
local _ = 0
while true do
    local Q = pcall(K)
    if not Q then
        task.wait(5)
    end
    task.wait(10)
end
