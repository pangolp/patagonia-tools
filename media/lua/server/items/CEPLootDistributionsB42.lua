require 'Items/ProceduralDistributions'

CG = CG or {};

CG.tab_addMagGenerator  = function(x, count)
  ProceduralDistributions = ProceduralDistributions or {};
  ProceduralDistributions.list = ProceduralDistributions.list or {};
  ProceduralDistributions.list[x] = ProceduralDistributions.list[x] or {};
  ProceduralDistributions.list[x].items = ProceduralDistributions.list[x].items or {};
  table.insert(ProceduralDistributions.list[x].items, "CraftGenerator.TheMachinistGenerator");
  table.insert(ProceduralDistributions.list[x].items, count);
end

CG.tab_addMagGenerator("BookstoreBooks", 0.5);
CG.tab_addMagGenerator("CrateMagazines", 0.5);
CG.tab_addMagGenerator("ElectronicStoreMagazines", 0.5);

CG.tab_addMagGenerator("LibraryBooks", 0.5);
CG.tab_addMagGenerator("LivingRoomShelf", 0.5);

CG.tab_addMagGenerator("MagazineRackMixed", 0.5);
CG.tab_addMagGenerator("PostOfficeMagazines", 0.5);
