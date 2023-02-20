require 'Items/ProceduralDistributions'

CEP = CEP or {};

CEP.tab_addMagProcedural_items  = function(x, count)
  ProceduralDistributions = ProceduralDistributions or {};
  ProceduralDistributions.list = ProceduralDistributions.list or {};
  ProceduralDistributions.list[x] = ProceduralDistributions.list[x] or {};
  ProceduralDistributions.list[x].items = ProceduralDistributions.list[x].items or {};
  table.insert(ProceduralDistributions.list[x].items, "CraftEngineParts.TheMachinist");
  table.insert(ProceduralDistributions.list[x].items, count);
end

CEP.tab_addMagProcedural_items("BookstoreBooks", 0.5);
CEP.tab_addMagProcedural_items("CrateMagazines", 0.5);
CEP.tab_addMagProcedural_items("ElectronicStoreMagazines", 0.5);

CEP.tab_addMagProcedural_items("LibraryBooks", 0.5);
CEP.tab_addMagProcedural_items("LivingRoomShelf", 0.5);

CEP.tab_addMagProcedural_items("MagazineRackMixed", 0.5);
CEP.tab_addMagProcedural_items("PostOfficeMagazines", 0.5);
