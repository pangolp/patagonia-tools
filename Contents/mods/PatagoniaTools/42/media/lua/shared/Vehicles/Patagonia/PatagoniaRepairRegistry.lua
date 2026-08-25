PatagoniaRepair = PatagoniaRepair or {}
PatagoniaRepair.recipes = PatagoniaRepair.recipes or {}

function PatagoniaRepair.register(def)
    assert(def and def.id, "PatagoniaRepair.register: recipe needs an id")
    assert(def.partIds and #def.partIds > 0, "PatagoniaRepair.register: recipe needs partIds")
    PatagoniaRepair.recipes[def.id] = def
    return def
end

function PatagoniaRepair.getForPart(partId)
    for _, def in pairs(PatagoniaRepair.recipes) do
        for _, id in ipairs(def.partIds) do
            if id == partId then
                return def
            end
        end
    end
    return nil
end

return PatagoniaRepair
