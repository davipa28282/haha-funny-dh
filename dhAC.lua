if game.PlaceId ~= 2788229376 then
    return
end

-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Vars
local MainEvent = ReplicatedStorage:WaitForChild("MainEvent")

-- // Configuration
local Flags = {
    "CHECKER_1",
    "TeleportDetect",
    "OneMoreTime"
}

-- // namecall hook
local namecall
namecall = hookmetamethod(game, "__namecall", function(...)
    local args = {...}
    local method = getnamecallmethod()

    if not checkcaller() and method == "FireServer" then
        local self = args[1]
        local flag = args[2]

        if self == MainEvent then
            for _, v in ipairs(Flags) do
                if flag == v then
                    return
                end
            end
        end
    end

    -- // Anti Crash
    if not checkcaller() then
        local env = getfenv(2)
        if env and rawget(env, "crash") then
            env.crash = function() end
            setfenv(2, env)
        end
    end

    return namecall(unpack(args))
end)

-- // newindex hook (stops game from setting ws/jp)
local newindex
newindex = hookmetamethod(game, "__newindex", function(t, k, v)
    if not checkcaller()
        and typeof(t) == "Instance"
        and t:IsA("Humanoid")
        and (k == "WalkSpeed" or k == "JumpPower") then
        return
    end

    return newindex(t, k, v)
end)
