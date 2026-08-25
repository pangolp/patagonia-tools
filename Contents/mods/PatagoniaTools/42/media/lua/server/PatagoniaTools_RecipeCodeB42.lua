-- Build 42 recipe-code for Patagonia Tools.
-- Ports the old B41 scaled-XP helpers (Recipe.OnGiveXP.Patagonia*) to the
-- Build 42 craftRecipe "OnCreate" hook, whose signature is (craftRecipeData, character).
-- Referenced from scripts/*.txt as: OnCreate = PatagoniaRecipe.give<Skill>XP

PatagoniaRecipe = PatagoniaRecipe or {}

-- Reproduces the original scaling: award (level * multiplier) XP, with a halo note,
-- capped out at level 10. Kept identical to the B41 behaviour on purpose.
local function giveScaledXP(character, perk, noteKey)
    if not character then return end

    local level = character:getPerkLevel(perk)
    if level == 10 then return end

    local xpBefore = character:getXp():getXP(perk)

    local multiplier
    if level < 2 then
        multiplier = 3
    elseif level < 4 then
        multiplier = 5
    elseif level < 6 then
        multiplier = 8
    elseif level < 8 then
        multiplier = 12
    else
        multiplier = 16
    end

    character:getXp():AddXP(perk, level * multiplier)

    local xpAfter = character:getXp():getXP(perk)
    character:setHaloNote(string.format(getText(noteKey), (xpAfter - xpBefore)))
end

function PatagoniaRecipe.giveMechanicsXP(craftRecipeData, character)
    giveScaledXP(character, Perks.Mechanics, "IGUI_Mechanics")
end

function PatagoniaRecipe.giveMetalWeldingXP(craftRecipeData, character)
    giveScaledXP(character, Perks.MetalWelding, "IGUI_MetalWelding")
end

function PatagoniaRecipe.giveElectricityXP(craftRecipeData, character)
    giveScaledXP(character, Perks.Electricity, "IGUI_Electricity")
end

-- The popsicle freezer is a two-tile object: the craftRecipe output gives the bottom
-- tile (Base.Mov_PopsicleFreezer / sprite appliances_refrigeration_01_20) and this
-- OnCreate hook adds the top tile (Base.mov_appliances_refrigeration_01_21, defined in
-- scripts/Items/patagonia_items.txt). Ported from the old B41 Recipe.OnCreate.FreezerIceCreamCustom.
function PatagoniaRecipe.addFreezerSecondPart(craftRecipeData, character)
    if not character then return end
    character:getInventory():AddItem("Base.mov_appliances_refrigeration_01_21")
end
