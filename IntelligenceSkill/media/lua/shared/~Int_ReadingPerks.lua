local ProfessionLevels = { base = 5, engineer = 6, professor = 6}
local TraitLevels = { FastReader = 1, SlowReader = -1, Illiterate = -5, FastLearner = 2, SlowLearner = -2}
--local PerksParents = {}

local function doProfLevels()
    local professions = ProfessionFactory.getProfessions()
    for i = 1, professions:size() do
        local profession = professions:get(i - 1)
        local type = profession:getType()
        local level = ProfessionLevels[type]
        if not level then level = ProfessionLevels.base end
        profession:addXPBoost(Perks.Intelligence,level)
    end
end

local function doTraitLevels()
    for i,v in pairs(TraitLevels) do
        local trait = TraitFactory.getTrait(i)
        if trait then
            trait:addXPBoost(Perks.Intelligence, v)
        end
    end
end

--local function doParents()
--    for perkName, data in pairs(Skillbook) do
--
--    end
--end

--local function setBaseLevel(character)
--    --profdescriptor
--    local level = ProfessionLevels.base
--    local level = ProfessionLevels.engineer
--    if character:HasTrait("Illiterate") then
--        level = level - 5
--    elseif character:HasTrait("FastReader") then
--        level = level + 1
--    elseif character:HasTrait("SlowReader") then
--        level = level - 1 end
--    if character:HasTrait("FastLearner") then
--        level = level + 2
--    elseif character:HasTrait("SlowLearner") then
--        level = level - 1
--    end
--    level = level >= 0 and level or 0
--    character:level0(Perks.Intelligence)
--    character:getXp():setXPToLevel(Perks.Intelligence,0)
--    for i=1, level do
--        character:LevelPerk(Perks.Intelligence)
--    end
--    character:getXp():setXPToLevel(Perks.Intelligence,level) --move ahead?
--    local boost = level <= 3 and level or 3
--    character:getXp():setPerkBoost(Perks.Intelligence,boost)
--    --triggereventlevelperk(false)
--end

--local function checkLiteracy(playerindex, player)
--    --if player:getXp():getXP(Perks.Intelligence) == 0 then
--        setBaseLevel(player)
--    --end
--end

--local function checkTraits(playerindex, player)
--    if player:HasTrait("Illiterate") then
--        player:getTraits():remove("Illiterate")
--        player:getTraits():add("SlowReader")
--    end
--end

local function ReadLevelTraits(character,perk,level,levelup)
    if perk == Perks.Intelligence then
        if level >= 1 and character:HasTrait("Illiterate") then character:getTraits():remove("Illiterate"); character:getTraits():add("SlowReader"); end
        if level >= 5 and character:HasTrait("SlowLearner") then character:getTraits():remove("SlowLearner") end
        if level >= 4 and character:HasTrait("SlowReader") then character:getTraits():remove("SlowReader") end
        if level >= 7 and not character:HasTrait("FastReader") then character:getTraits():add("FastReader") end
        if level == 10 and not character:HasTrait("FastLearner") then character:getTraits():add("FastLearner") end

        --ISTimedActionQueue.clear(character) --if reading, change time and multiplier
    end
end

Events.OnGameBoot.Add(doProfLevels)
Events.OnGameBoot.Add(doTraitLevels)
--Events.OnGameBoot.Add(doParents)
--Events.OnCreatePlayer.Add(checkLiteracy) --for when you add mod
--Events.OnCreatePlayer.Add(checkTraits)
--Events.LevelPerk.Add(ReadLevelTraits)
