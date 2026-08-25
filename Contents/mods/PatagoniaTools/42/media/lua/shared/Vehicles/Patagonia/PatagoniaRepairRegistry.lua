PatagoniaRepair = PatagoniaRepair or {}
PatagoniaRepair.recipes = PatagoniaRepair.recipes or {}

function PatagoniaRepair.register(def)
    assert(def and def.id, "PatagoniaRepair.register: recipe needs an id")
    assert(def.partIds and #def.partIds > 0, "PatagoniaRepair.register: recipe needs partIds")
    PatagoniaRepair.recipes[def.id] = def
    return def
end

function PatagoniaRepair.recipeCoversPart(recipe, partId)
    for _, id in ipairs(recipe.partIds) do
        if id == partId then
            return true
        end
    end
    return false
end

function PatagoniaRepair.appliesTo(recipe, part)
    return recipe.appliesTo == nil or recipe.appliesTo(part)
end

function PatagoniaRepair.getApplicableForPart(part)
    local partId = part:getId()
    local matches = {}
    for _, recipe in pairs(PatagoniaRepair.recipes) do
        if PatagoniaRepair.recipeCoversPart(recipe, partId) and PatagoniaRepair.appliesTo(recipe, part) then
            table.insert(matches, recipe)
        end
    end
    return matches
end

return PatagoniaRepair
