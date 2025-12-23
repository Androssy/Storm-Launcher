# Storm Launcher - User API Guide

The API runs on `http://localhost:3030`

---

## Setting a Description

Want to add a note to an account? Maybe show what zone they're in or what task they're doing? Use this.

**How to use:**

```lua
local HttpService = game:GetService("HttpService")

-- Set description for current account
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

You can identify the account by:
- `username` - the player's display name
- `account_id` - the account number (starts from 0)

The description shows up in the Storm Launcher UI next to the account.

---

## Marking an Account as Finished

Done with an account? This marks it as finished and closes the Roblox window.

**How to use:**

```lua
local HttpService = game:GetService("HttpService")

-- Mark account as finished
request({
    Url = "http://localhost:3030/api/accounts/finish",
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = HttpService:JSONEncode({
        username = "YourUsername"
    })
})
```

You can identify the account by:
- `username` - the player's display name
- `account_id` - the account number
- `pid` - the process ID (optional, auto-detected)

This will:
1. Kill the Roblox process
2. Mark the account as "Finished" in the UI
3. Remove it from the active pool

---

## Tips

- Use `username` when you know the player name (most common)
- Use `account_id` when working with account indexes
- Descriptions are great for debugging - you can see what each account is doing at a glance
