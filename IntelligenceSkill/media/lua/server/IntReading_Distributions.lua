require 'Items/ProceduralDistributions'

local addLoot = function(targets,items)
    for _,target in ipairs(targets) do
        local targetItems = ProceduralDistributions["list"][target]["items"]
        for _,i in ipairs(items) do
            table.insert(targetItems,i)
        end
    end
end

addLoot({"BookstoreBooks", "CrateBooks", "LibraryBooks", "PostOfficeBooks"},
{
    "IntReading.BookReading1",0.1,
    "IntReading.BookReading2",0.5,
    "IntReading.BookReading3",1,
    "IntReading.BookReading4",0.5,
    "IntReading.BookReading5",0.2,
    "IntReading.BookReading6",0.01,
    "IntReading.BookStrength1",0.1,
    "IntReading.BookStrength2",0.5,
    "IntReading.BookStrength3",1,
    "IntReading.BookStrength4",0.5,
    "IntReading.BookStrength5",0.2,
    "IntReading.BookStrength6",0.01,
    "IntReading.BookFitness1",0.1,
    "IntReading.BookFitness2",0.5,
    "IntReading.BookFitness3",1,
    "IntReading.BookFitness4",0.5,
    "IntReading.BookFitness5",0.2,
    "IntReading.BookFitness6",0.01,
    "IntReading.BookLightfoot1",0.1,
    "IntReading.BookLightfoot2",0.5,
    "IntReading.BookLightfoot3",1,
    "IntReading.BookLightfoot4",0.5,
    "IntReading.BookLightfoot5",0.2,
    "IntReading.BookLightfoot6",0.01,
    "IntReading.BookNimble1",0.1,
    "IntReading.BookNimble2",0.5,
    "IntReading.BookNimble3",1,
    "IntReading.BookNimble4",0.5,
    "IntReading.BookNimble5",0.2,
    "IntReading.BookNimble6",0.01,
    "IntReading.BookSneak1",0.1,
    "IntReading.BookSneak2",0.5,
    "IntReading.BookSneak3",1,
    "IntReading.BookSneak4",0.5,
    "IntReading.BookSneak5",0.2,
    "IntReading.BookSneak6",0.01,
    "IntReading.BookSprinting1",0.1,
    "IntReading.BookSprinting2",0.5,
    "IntReading.BookSprinting3",1,
    "IntReading.BookSprinting4",0.5,
    "IntReading.BookSprinting5",0.2,
    "IntReading.BookSprinting6",0.01,
    "IntReading.BookMaintenance1",0.1,
    "IntReading.BookMaintenance2",0.5,
    "IntReading.BookMaintenance3",1,
    "IntReading.BookMaintenance4",0.5,
    "IntReading.BookMaintenance5",0.2,
    "IntReading.BookMaintenance6",0.01,
    "IntReading.BookAxe1",0.1,
    "IntReading.BookAxe2",0.5,
    "IntReading.BookAxe3",1,
    "IntReading.BookAxe4",0.5,
    "IntReading.BookAxe5",0.2,
    "IntReading.BookAxe6",0.01,
    "IntReading.BookSmallBlunt1",0.1,
    "IntReading.BookSmallBlunt2",0.5,
    "IntReading.BookSmallBlunt3",1,
    "IntReading.BookSmallBlunt4",0.5,
    "IntReading.BookSmallBlunt5",0.2,
    "IntReading.BookSmallBlunt6",0.01,
    "IntReading.BookBlunt1",0.1,
    "IntReading.BookBlunt2",0.5,
    "IntReading.BookBlunt3",1,
    "IntReading.BookBlunt4",0.5,
    "IntReading.BookBlunt5",0.2,
    "IntReading.BookBlunt6",0.01,
    "IntReading.BookSmallBlade1",0.1,
    "IntReading.BookSmallBlade2",0.5,
    "IntReading.BookSmallBlade3",1,
    "IntReading.BookSmallBlade4",0.5,
    "IntReading.BookSmallBlade5",0.2,
    "IntReading.BookSmallBlade6",0.01,
    "IntReading.BookLongBlade1",0.1,
    "IntReading.BookLongBlade2",0.5,
    "IntReading.BookLongBlade3",1,
    "IntReading.BookLongBlade4",0.5,
    "IntReading.BookLongBlade5",0.2,
    "IntReading.BookLongBlade6",0.01,
    "IntReading.BookSpear1",0.1,
    "IntReading.BookSpear2",0.5,
    "IntReading.BookSpear3",1,
    "IntReading.BookSpear4",0.5,
    "IntReading.BookSpear5",0.2,
    "IntReading.BookSpear6",0.01,
    "IntReading.BookAiming1",0.1,
    "IntReading.BookAiming2",0.5,
    "IntReading.BookAiming3",1,
    "IntReading.BookAiming4",0.5,
    "IntReading.BookAiming5",0.2,
    "IntReading.BookAiming6",0.01,
    "IntReading.BookReloading1",0.1,
    "IntReading.BookReloading2",0.5,
    "IntReading.BookReloading3",1,
    "IntReading.BookReloading4",0.5,
    "IntReading.BookReloading5",0.2,
    "IntReading.BookReloading6",0.01,
    "IntReading.BookTrapping6",0.012,
    "IntReading.BookFishing6",0.012,
    "IntReading.BookCarpentry6",0.012,
    "IntReading.BookMechanic6",0.012,
    "IntReading.BookFirstAid6",0.012,
    "IntReading.BookMetalWelding6",0.012,
    "IntReading.BookElectrician6",0.012,
    "IntReading.BookCooking6",0.012,
    "IntReading.BookFarming6",0.012,
    "IntReading.BookForaging6",0.012,
    "IntReading.BookTailoring6",0.012,
})

--addLoot({"LivingRoomShelf", "LivingRoomShelfNoTapes", "ClassroomMisc", "ClassroomShelves", "ShelfGeneric"},
--        {
--            "IntReading.BookTrapping6",0.01,
--            "IntReading.BookFishing6",0.01,
--            "IntReading.BookCarpentry6",0.01,
--            "IntReading.BookMechanic6",0.01,
--            "IntReading.BookFirstAid6",0.01,
--            "IntReading.BookMetalWelding6",0.01,
--            "IntReading.BookElectrician6",0.01,
--            "IntReading.BookCooking6",0.01,
--            "IntReading.BookFarming6",0.01,
--            "IntReading.BookForaging6",0.01,
--            "IntReading.BookTailoring6",0.01,
--        })
--
--addLoot({"CampingStoreBooks"},
--        {
--            "IntReading.BookTrapping6",0.5,
--            "IntReading.BookFishing6",0.5,
--            "IntReading.BookForaging6",0.1,
--        })
--
--addLoot({"Hunter"},
--        {
--            "IntReading.BookTrapping6",0.5,
--            "IntReading.BookForaging6",0.5,
--        })
--
--addLoot({"SurvivalGear"},
--        {
--            "IntReading.BookTrapping6",0.5,
--            "IntReading.BookFishing6",0.5,
--            "IntReading.BookFirstAid6",0.5,
--            "IntReading.BookForaging6",0.5,
--        })
--
--addLoot({"ToolStoreBooks"},
--        {
--            "IntReading.BookCarpentry6",0.5,
--            "IntReading.BookMechanic6",0.5,
--            "IntReading.BookMetalWelding6",0.5,
--            "IntReading.BookElectrician6",0.5,
--        })
--
--addLoot({"Trapper"},
--        {
--            "IntReading.BookTrapping6",0.5,
--        })
--
--addLoot({"MedicalOfficeBooks"},
--        {
--            "IntReading.BookFirstAid6",0.5,
--        })
--
--addLoot({"MechanicShelfBooks","MechanicSpecial"},
--        {
--            "IntReading.BookMechanic6",0.3,
--        })
--
--addLoot({"EngineerTools"},
--        {
--            "IntReading.BookElectrician6",0.5,
--        })
--
--addLoot({"FoodGourmet","KitchenBook"},
--        {
--            "IntReading.BookCooking6",0.5,
--        })
--
--addLoot({"GardenStoreMisc","GigamartFarming","Homesteading"},
--        {
--            "IntReading.BookCooking6",0.5,
--        })
--
--addLoot({"CrateFitnessWeights", "GymLockers"},
--{
--    "IntReading.BookStrength1",1,
--    "IntReading.BookStrength2",1,
--    "IntReading.BookStrength3",1,
--    "IntReading.BookStrength4",1,
--    "IntReading.BookStrength5",1,
--    "IntReading.BookStrength6",0.5,
--    "IntReading.BookFitness1",1,
--    "IntReading.BookFitness2",1,
--    "IntReading.BookFitness3",1,
--    "IntReading.BookFitness4",1,
--    "IntReading.BookFitness5",1,
--    "IntReading.BookFitness6",0.5,
--})
--
--addLoot({"ArmyStorageGuns"},
--{
--    "IntReading.BookAiming1",1,
--    "IntReading.BookAiming2",1,
--    "IntReading.BookAiming3",1,
--    "IntReading.BookAiming4",1,
--    "IntReading.BookAiming5",1,
--    "IntReading.BookAiming6",0.5,
--    "IntReading.BookReloading1",1,
--    "IntReading.BookReloading2",1,
--    "IntReading.BookReloading3",1,
--    "IntReading.BookReloading4",1,
--    "IntReading.BookReloading5",1,
--    "IntReading.BookReloading6",0.5,
--})
--
--addLoot({"ClassroomMisc", "ClassroomShelves"},
--        {
--            "IntReading.BookReading6",0.5,
--        })
--
--addLoot({"WardrobeMan", "WardrobeWoman"},
--        {
--            "IntReading.BookLightfoot6",0.01,
--            "IntReading.BookSneak6",0.01,
--        })
--
--addLoot({"BedroomSideTable"},
--        {
--            "IntReading.BookNimble6",0.01,
--            "IntReading.BookSprinting6",0.01,
--        })
--
--addLoot({"ToolStoreBooks"},
--        {
--            "IntReading.BookMaintenance6",0.05,
--            "IntReading.BookSmallBlunt6",0.05,
--            "IntReading.BookBlunt6",0.05,
--        })
--
--addLoot({"FoodGourmet","KitchenBook"},
--        {
--            "IntReading.BookSmallBlade6",0.05,
--            "IntReading.BookLongBlade6",0.05,
--        })
--
--addLoot({"SurvivalGear"},
--        {
--            "IntReading.BookAxe6",0.05,
--            "IntReading.BookSpear6",0.05,
--        })
--
--addLoot({"CrateComics"},
--        {
--            "IntReading.BookFantasy1",0.3,
--            "IntReading.BookFantasy2",0.5,
--            "IntReading.BookFantasy3",0.1,
--        })
