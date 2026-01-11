# Storm Launcher - User API Guide

The API runs on `http://localhost:3030`

---

## Setting a Description

Want to add a note to an account? Show what zone they're in or what task they're doing.

```lua
local HttpService = game:GetService("HttpService")

request({
    Url = "http://localhost:3030/api/accounts/description",
    Method = "PUT",
    Headers = { ["Content-Type"] = "application/json" },
    Body = HttpService:JSONEncode({
        username = "YourUsername",
        description = "Farming Zone 3"
    })
})
```

The description shows up next to the account in the UI.

---

## Marking as Finished

Done with an account? This closes Roblox and marks it finished.

```lua
local HttpService = game:GetService("HttpService")

request({
    Url = "http://localhost:3030/api/accounts/finish",
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = HttpService:JSONEncode({
        username = "YourUsername"
    })
})
```

The account won't run again until you manually requeue it.

---

## Putting on Cooldown

Need a break but want to run again later? Use cooldown. The account closes, waits, then auto-joins back.

```lua
local HttpService = game:GetService("HttpService")

request({
    Url = "http://localhost:3030/api/accounts/cooldown",
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = HttpService:JSONEncode({
        username = "YourUsername",
        duration = 300  -- seconds (300 = 5 minutes)
    })
})
```

**What happens:**
1. Roblox closes
2. Account waits for the timer
3. When time's up, it goes to the front of the queue
4. Launches again automatically

Great for rate limits, daily resets, or giving accounts a break.

---

## Quick Reference

| What you want       | Endpoint                    | Key field               |
| ------------------- | --------------------------- | ----------------------- |
| Add a note          | `/api/accounts/description` | `description`           |
| Stop for good       | `/api/accounts/finish`      | `username`              |
| Stop + auto-restart | `/api/accounts/cooldown`    | `username` + `duration` |

**Identify accounts by:**
- `username` - player's display name (easiest)
- `account_id` - account number starting from 0
