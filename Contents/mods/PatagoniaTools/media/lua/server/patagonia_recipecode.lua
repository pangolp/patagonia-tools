require "recipecode"

function Recipe.OnGiveXP.PatagoniaMechanics(recipe, ingredients, result, player)
    local _mechanicSkill = player:getPerkLevel(Perks.Mechanics)
    if _mechanicSkill == 10 then return end

    local xpBefore = player:getXp():getXP(Perks.Mechanics)
    local experienceMultiplier = 0

    if (_mechanicSkill < 2) then
        experienceMultiplier = 3
    elseif (_mechanicSkill < 4) then
        experienceMultiplier = 5
    elseif (_mechanicSkill < 6) then
        experienceMultiplier = 8
    elseif (_mechanicSkill < 8) then
        experienceMultiplier = 12
    else
        experienceMultiplier = 16
    end

    player:getXp():AddXP(Perks.Mechanics, _mechanicSkill * experienceMultiplier)
    local xpAfter = player:getXp():getXP(Perks.Mechanics)
    player:setHaloNote(string.format(getText("IGUI_Mechanics"), (xpAfter - xpBefore)))
end

function Recipe.OnGiveXP.PatagoniaMetalWelding(recipe, ingredients, result, player)
    local _metalWeldingSkill = player:getPerkLevel(Perks.MetalWelding)
    if _metalWeldingSkill == 10 then return end

    local xpBefore = player:getXp():getXP(Perks.MetalWelding)
    local experienceMultiplier = 0

    if (_metalWeldingSkill < 2) then
        experienceMultiplier = 3
    elseif (_metalWeldingSkill < 4) then
        experienceMultiplier = 5
    elseif (_metalWeldingSkill < 6) then
        experienceMultiplier = 8
    elseif (_metalWeldingSkill < 8) then
        experienceMultiplier = 12
    else
        experienceMultiplier = 16
    end

    player:getXp():AddXP(Perks.MetalWelding, _metalWeldingSkill * experienceMultiplier)
    local xpAfter = player:getXp():getXP(Perks.MetalWelding)
    player:setHaloNote(string.format(getText("IGUI_MetalWelding"), (xpAfter - xpBefore)))
end

function Recipe.OnGiveXP.PatagoniaElectricity(recipe, ingredients, result, player)
    local _electricitySkill = player:getPerkLevel(Perks.Electricity)
    if _electricitySkill == 10 then return end

    local xpBefore = player:getXp():getXP(Perks.Electricity)
    local experienceMultiplier = 0

    if (_electricitySkill < 2) then
        experienceMultiplier = 3
    elseif (_electricitySkill < 4) then
        experienceMultiplier = 5
    elseif (_electricitySkill < 6) then
        experienceMultiplier = 8
    elseif (_electricitySkill < 8) then
        experienceMultiplier = 12
    else
        experienceMultiplier = 16
    end

    player:getXp():AddXP(Perks.Electricity, _electricitySkill * experienceMultiplier)
    local xpAfter = player:getXp():getXP(Perks.Electricity)
    player:setHaloNote(string.format(getText("IGUI_Electricity"), (xpAfter - xpBefore)))
end

function Recipe.GetItemTypes.BrokenGlassCustom(scriptItems)
    local itemNames = {
        "Base.brokenglass_1_1",
        "Base.brokenglass_1_2",
        "Base.brokenglass_1_3"
    }

    for _, itemName in ipairs(itemNames) do
        local item = ScriptManager.instance:getItem(itemName)
        if item then
            scriptItems:add(item)
        end
    end
end

function Recipe.GetItemTypes.RecipeBrokenGlassCustom(scriptItems)
    local itemNames = {
        "Base.brokenglass_1_0",
        "SmashedBottle"
    }

    for _, itemName in ipairs(itemNames) do
        local item = ScriptManager.instance:getItem(itemName)
        if item then
            scriptItems:add(item)
        end
    end
end

-- Como el freezer, tiene 2 partes, añadimos una en el result
-- Y la otra se añade de esta forma. Asi obtiene las 2 partes.
-- Tuvimos que crear el item, en server/patagonia_recipecode.lua
function Recipe.OnCreate.FreezerIceCreamCustom(items, result, player)
    player:getInventory():AddItem("Base.mov_appliances_refrigeration_01_21")
end
