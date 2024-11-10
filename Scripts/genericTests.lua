---@diagnostic disable: need-check-nil

_G.Tests = {}

local lu = require("LuaUnit.luaunit")
local ueHelpers = require("UEHelpers")

local survivalPlayerCharacter = FindFirstOf("SurvivalPlayerCharacter")
local survivalGameplayStatics = StaticFindObject("/Script/Maine.Default__SurvivalGameplayStatics")

---@cast survivalPlayerCharacter ASurvivalPlayerCharacter
---@cast survivalGameplayStatics USurvivalGameplayStatics
local survivalGameModeManager = survivalGameplayStatics:GetSurvivalGameModeManager(ueHelpers.GetGameViewportClient())

local function getProperty(obj, property)
  if obj[property] == nil or not obj[property]:IsValid() then
    return nil
  end
  return obj[property]
end

local function assertObjectIsValid(objectName)
  local obj = FindFirstOf(objectName)
  lu.assertTrue(obj:IsValid())
end

function Tests:test_SurvivalPlayerCharacter()
  lu.assertTrue(survivalPlayerCharacter:IsValid())
end

function Tests:test_SurvivalGameplayStatics()
  lu.assertTrue(survivalGameplayStatics:IsValid())
end

function Tests:test_SurvivalGameModeManager()
  lu.assertTrue(survivalGameModeManager:IsValid())
end

function Tests:test_SurvivalGameState()
  lu.assertTrue(survivalGameplayStatics:GetSurvivalGameState(ueHelpers.GetGameViewportClient()):IsValid())
end

function Tests:test_GlobalItemData()
  lu.assertTrue(survivalGameplayStatics:GetGlobalItemData():IsValid())
end

function Tests:test_GameModeSettings()
  lu.assertTrue(survivalGameModeManager:GetGameModeSettings():IsValid())
end

function Tests:test_Bird()
  assertObjectIsValid("Bird")
end

function Tests:test_Building()
  assertObjectIsValid("Building")
end

function Tests:test_ProductionBuilding()
  assertObjectIsValid("ProductionBuilding")
end

function Tests:test_GlobalBuildingData()
  assertObjectIsValid("GlobalBuildingData")
end

function Tests:test_CharMovementComponent()
  lu.assertNotIsNil(getProperty(survivalPlayerCharacter, "CharMovementComponent"))
end

function Tests:test_ProximityInventoryComponent()
  lu.assertNotIsNil(getProperty(survivalPlayerCharacter, "ProximityInventoryComponent"))
end

function Tests:test_HaulingComponent()
  lu.assertNotIsNil(getProperty(survivalPlayerCharacter, "HaulingComponent"))
end

function Tests:test_BlockComponent()
  lu.assertNotIsNil(getProperty(survivalPlayerCharacter, "BlockComponent"))
end

return lu.LuaUnit.run()
