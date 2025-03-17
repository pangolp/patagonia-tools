require "recipecode"

function Recipe.OnGiveXP.PatagoniaMechanics(recipe, ingredients, result, player)
    if player:getPerkLevel(Perks.Mechanics) < 10 then
        local xpBefore = player:getXp():getXP(Perks.Mechanics)
        if player:getPerkLevel(Perks.Mechanics) < 2 then
            local experienceMultiplier = 3
        elseif player:getPerkLevel(Perks.Mechanics) < 4 then
            local experienceMultiplier = 5
        elseif player:getPerkLevel(Perks.Mechanics) < 6 then
            local experienceMultiplier = 7
        elseif player:getPerkLevel(Perks.Mechanics) < 8 then
            local experienceMultiplier = 9
        elseif player:getPerkLevel(Perks.Mechanics) < 10 then
            local experienceMultiplier = 11
        end
        player:getXp():AddXP(Perks.Mechanics, ((player:getPerkLevel(Perks.Mechanics) * experienceMultiplier)))
        local xpAfter = player:getXp():getXP(Perks.Mechanics)
        player:setHaloNote(string.format(getText("IGUI_Mechanics"), (xpAfter - xpBefore)))
    end
end

function Recipe.OnGiveXP.PatagoniaMetalWelding(recipe, ingredients, result, player)
    if player:getPerkLevel(Perks.MetalWeldings) < 10 then
        local xpBefore = player:getXp():getXP(Perks.MetalWeldings)
        if player:getPerkLevel(Perks.MetalWeldings) < 2 then
            local experienceMultiplier = 3
        elseif player:getPerkLevel(Perks.MetalWeldings) < 4 then
            local experienceMultiplier = 5
        elseif player:getPerkLevel(Perks.MetalWeldings) < 6 then
            local experienceMultiplier = 7
        elseif player:getPerkLevel(Perks.MetalWeldings) < 8 then
            local experienceMultiplier = 9
        elseif player:getPerkLevel(Perks.MetalWeldings) < 10 then
            local experienceMultiplier = 11
        end
        player:getXp():AddXP(Perks.MetalWeldings, ((player:getPerkLevel(Perks.MetalWeldings) * experienceMultiplier)))
        local xpAfter = player:getXp():getXP(Perks.MetalWeldings)
        player:setHaloNote(string.format(getText("IGUI_MetalWelding"), (xpAfter - xpBefore)))
    end
end

function Recipe.OnGiveXP.PatagoniaElectricity(recipe, ingredients, result, player)
    if player:getPerkLevel(Perks.Electricity) < 10 then
        local xpBefore = player:getXp():getXP(Perks.Electricity)

        if player:getPerkLevel(Perks.Electricity) < 2 then
            local experienceMultiplier = 3
        elseif player:getPerkLevel(Perks.Electricity) < 4 then
            local experienceMultiplier = 5
        elseif player:getPerkLevel(Perks.Electricity) < 6 then
            local experienceMultiplier = 7
        elseif player:getPerkLevel(Perks.Electricity) < 8 then
            local experienceMultiplier = 9
        elseif player:getPerkLevel(Perks.Electricity) < 10 then
            local experienceMultiplier = 11
        end

        player:getXp():AddXP(Perks.Electricity, ((player:getPerkLevel(Perks.Electricity) * experienceMultiplier)))
        local xpAfter = player:getXp():getXP(Perks.Electricity)
        player:setHaloNote(string.format(getText("IGUI_Electricity"), (xpAfter - xpBefore)))
    end
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
