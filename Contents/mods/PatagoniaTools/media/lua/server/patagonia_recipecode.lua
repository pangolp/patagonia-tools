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
