--!strict
-- StormAccount.lua — wrapper around the Storm Launcher local API
-- Safe to share/upload: no secret embedded. Caller must Account.SetKey(...)
-- before any endpoint that requires auth.

local HttpService = game:GetService("HttpService")

local BASE = "http://localhost:3030"
local KEY  = ""

local Account = {}
Account.__index = Account

local function urlencode(s)
    return (string.gsub(tostring(s), "[^%w%-%.%_%~]", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

local function http(method, path, body)
    local req = { Url = BASE .. path, Method = method }
    if body ~= nil then
        req.Headers = { ["Content-Type"] = "application/json" }
        req.Body    = HttpService:JSONEncode(body)
    end

    local ok, res = pcall(request, req)
    if not ok then
        return nil, "request threw: " .. tostring(res)
    end
    if type(res) ~= "table" then
        return nil, "request returned non-table"
    end

    local code = res.StatusCode or 0
    local rbody = res.Body or ""
    if code < 200 or code >= 300 then
        return nil, string.format("HTTP %d %s: %s",
            code, tostring(res.StatusMessage or ""), rbody)
    end
    return rbody, nil
end

function Account.new(Username)
    local self = setmetatable({}, Account)
    self.Username = Username
    return self
end

function Account.SetKey(key)
    KEY = key or ""
end

local function requireKey()
    assert(KEY ~= "", "StormAccount: call Account.SetKey(<key.txt>) first")
end

function Account:GetDescription()
    return http("GET", "/GetDescription?Account=" .. urlencode(self.Username))
end

function Account:Exists()
    local body, err = http("GET", "/GetAccount?Account=" .. urlencode(self.Username))
    if not body then return nil, err end
    return body == "true", nil
end

function Account:GetCookie()
    requireKey()
    return http("GET", "/GetCookie?Account=" .. urlencode(self.Username)
        .. "&Password=" .. urlencode(KEY))
end

function Account:GetCSRFToken()
    requireKey()
    return http("GET", "/GetCSRFToken?Account=" .. urlencode(self.Username)
        .. "&Password=" .. urlencode(KEY))
end

function Account.GetOnlines()
    requireKey()
    local body, err = http("GET", "/GetOnlines?Password=" .. urlencode(KEY))
    if not body then return nil, err end
    if body == "" then return {}, nil end
    return string.split(body, "\n"), nil
end

function Account:SetDescription(text)
    local _, err = http("PUT", "/api/accounts/description", {
        username    = self.Username,
        description = text,
    })
    if err then return nil, err end
    return true, nil
end

function Account:MarkFinished(description)
    local _, err = http("POST", "/api/accounts/finish", {
        username    = self.Username,
        description = description, -- optional
    })
    if err then return nil, err end
    return true, nil
end

function Account:SetCooldown(seconds, description)
    local _, err = http("POST", "/api/accounts/cooldown", {
        username    = self.Username,
        duration    = seconds,
        description = description, -- optional
    })
    if err then return nil, err end
    return true, nil
end

return Account
