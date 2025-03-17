require "recipecode"

function Recipe.OnGiveXP.Mechanics1(recipe, ingredients, result, player)
    local xpBefore = player:getXp():getXP(Perks.Mechanics)
    player:getXp():AddXP(Perks.Mechanics, ((player:getPerkLevel(Perks.Mechanics) * 5)))
    local xpAfter = player:getXp():getXP(Perks.Mechanics)
    player:setHaloNote(string.format("Mechanics: %.2f", (xpAfter - xpBefore)))
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
