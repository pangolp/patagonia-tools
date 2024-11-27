require "recipecode"

function Recipe.OnGiveXP.Mechanics1(recipe, ingredients, result, player)
    local xpBefore = player:getXp():getXP(Perks.Mechanics)
    player:getXp():AddXP(Perks.Mechanics, ((player:getPerkLevel(Perks.Mechanics) * 5)))
    local xpAfter = player:getXp():getXP(Perks.Mechanics)
    player:setHaloNote(string.format("Mechanics: %.2f", (xpAfter - xpBefore)))
end
