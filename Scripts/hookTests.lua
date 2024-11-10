---@diagnostic disable: need-check-nil

_G.Tests = {}

local lu = require("LuaUnit.luaunit")

---@param funcName string
local function h(funcName)
    local preId, postId = RegisterHook(funcName, function() end)

    lu.assertIsTrue(type(preId) == "number")
    lu.assertIsTrue(type(postId) == "number")

    UnregisterHook(funcName, preId, postId)
end

function Tests:test_Hooks()
    h("/Script/Maine.InteractableInterface:IsInteractionEnabledForBuilder")
end

return lu.LuaUnit.run()
