_G.__TestsMod = {}
_G.Tests = {} -- table for LuaUnit

local utils = require("lua-mods-libs.utils")

__CONFIG = utils.loadConfig()

if not string.find(__CONFIG.OPTIONS_FILES, "[\\/]tests?[\\/]") then
    print(__CONFIG.OPTIONS_FILES ..
        [[ are not in a "test" or "tests" folder. Tests will be ignored.]])
    return
end

local lu = require("LuaUnit.luaunit")

local function run()
    --#region generic tests
    print("Run generic tests.")

    local prefix = "#####"

    local modName = "TestsMod"
    local modsDirectory = debug.getinfo(1, "S").source:match("@?(.+\\Mods)\\")

    local msg = ""
    local result = 0
    local finalMsg = ""
    local finalResult = 0

    result, msg = dofile(string.format("%s\\%s\\Scripts\\genericTests.lua", modsDirectory, modName))
    finalResult = finalResult + result
    if msg ~= nil then
        finalMsg = finalMsg .. msg .. "\n"
    end
    --#endregion

    --#region hook tests
    print("Run hook tests in 'hookTests.lua'.")

    result, msg = dofile(string.format("%s\\%s\\Scripts\\hookTests.lua", modsDirectory, modName))
    finalResult = finalResult + result
    if msg ~= nil then
        finalMsg = finalMsg .. msg .. "\n"
    end
    --#endregion

    --#region tests
    local fileList = utils.getFileList(modsDirectory, "\\tests?\\test_runner.*[.]lua$")

    print(string.format("Run mods tests. %s file(s) found.", #fileList))

    for i, file in ipairs(fileList) do
        -- reset variables
        _G.Tests = {}

        local modNameToTest = file:match(".+\\Mods\\([^\\]+)")
        local enabledModsList = utils.getEnabledModsList()

        if enabledModsList[modNameToTest] then
            print("")
            print(prefix)
            print(string.format(prefix .. " Test %s/%s: [%s] %s", i, #fileList, modNameToTest,
                file:gsub(".+\\Mods\\", "")))
            print("")

            result, msg = dofile(file)
            finalResult = finalResult + result
            if msg ~= nil then
                finalMsg = finalMsg .. msg .. "\n"
            end
        end
    end
    --#endregion

    print("")
    print("")

    if finalMsg ~= "" then
        print(finalMsg)
        print("")
    end
    if (finalResult == 0) then
        print(prefix .. " Final result: ALL TESTS PASSED SUCCESSFULLY.")
    else
        print(string.format(prefix .. " Final result: %s faillure(s).", finalResult))
    end

    print(prefix)
    print("")
    print("")
end

---@param items table
---@param id string
---@param instances UObject[]
function _G.__TestsMod.testOptions(items, id, instances)
    ---@type table
    local options = items[id]

    lu.assertIsTrue(type(options) == "table",
        string.format("The item %q does not exist in the options file.", id))

    options = utils.flattenTable(options)

    lu.assertIsTrue(#instances > 0, string.format("No instance was found."))

    for instNum, instance in ipairs(instances) do
        print(string.format("Instance %i/%i", instNum, #instances))
        for key, value in pairs(options) do
            if type(value) == "number" then
                lu.assertAlmostEquals(instance[key], value, 0.01,
                    string.format("Tested key: %s.%s", id, key))
            elseif type(value) == "string" or type(value) == "boolean" then
                lu.assertEquals(instance[key], value,
                    string.format("Tested key: %s.%s", id, key))
            else
                error("Variable type is not supported for this test. Var type: " .. type(value) .. "\n")
            end
        end
    end
end

RegisterKeyBind(Key.F5, run)

print("")
print("> > > > >    PRESS F5 TO RUN TESTS MANUALLY    < < < < <")
print("")

local characterInstance = FindFirstOf("SurvivalPlayerCharacter")
if characterInstance and characterInstance:IsValid() then
    run()
end

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    ExecuteWithDelay(5000, function()
        run()
    end)
end)
