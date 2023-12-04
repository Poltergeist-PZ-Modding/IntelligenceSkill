require "TimedActions/ISReadABook"
local utils = require "IntReading_utils"

ISReadABookInt = ISReadABook:derive("ISReadABookInt")

--calculate based on multiple skills, when start reading?
--make multiplier on create based on multiple skills, change on level skill ?
--if reading, change book multiplier when level skill
local scalesWith = {
    --Carpentry = nil,
    --Cooking = nil,
    --Farming = nil,
    --Blacksmith = nil,
    --MetalWelding = nil,
    --FirstAid = nil,
    --Electricity = nil,
    --Mechanics = nil,
    --Tailoring = nil,
    --Fishing = nil,
    --Trapping = nil,
    --Foraging = nil,

    --Intelligence = nil,
    --Fitness = nil,
    --Strength = nil,
    Sprinting = { "Fitness" },
    --Sneak = { "Fitness" },
    Nimble = { "Fitness" },
    --Lightfoot = { "Fitness" },
    Blunt = { "Strength" },
    LongBlade = { "Strength" },
    Axe = { "Strength" },
    SmallBlunt = { "Strength" },
    SmallBlade = { "Cooking" },
    Spear = { "Strength" },
    Maintenance = { "Woodwork" },
    --Aiming = nil,
    --Reloading = nil,
    Lockpicking = { "Intelligence" },
}
local function CalcMaxMultiplier(character,item)
    local intLevel = character:getPerkLevel(Perks.Intelligence)
    local perkName = item:getSkillTrained()

    local maxMultiplier = SkillBook[perkName]["maxMultiplier" .. item:getMaxLevelTrained()/2] or 1
    maxMultiplier = maxMultiplier * (perkName == "Intelligence" and 1 or intLevel > 5 and 1 + (intLevel - 5) * 0.04 or intLevel * 0.2)
    if scalesWith[perkName] then
        local base = 0.9
        local step = 0.02
        maxMultiplier = maxMultiplier * (base + character:getPerkLevel(Perks[scalesWith[perkName]]) * step)
    end

    if maxMultiplier < 1.1 then maxMultiplier = 1.1 end
    return maxMultiplier
end

--local function CalcMaxMultiplier(character,item)
--    local readlevel = character:getPerkLevel(Perks.Intelligence)
--    local skillMultiplierBonus, maxMultiplier
--    local step = 0.05
--    if item:getSkillTrained() == "Intelligence" then
--        skillMultiplierBonus = 1
--    else
--        if readlevel > 5 then
--            skillMultiplierBonus = 1 + character:getPerkLevel(Perks.Intelligence) * 0.1
--        else
--            skillMultiplierBonus = character:getPerkLevel(Perks.Intelligence) * 0.2
--        end
--    end
--
--    if item:getLvlSkillTrained() == 0 then
--        maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier5 * skillMultiplierBonus;
--    else
--        if item:getLvlSkillTrained() == 1 then
--            maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier1 * skillMultiplierBonus;
--        elseif item:getLvlSkillTrained() == 3 then
--            maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier2 * skillMultiplierBonus;
--        elseif item:getLvlSkillTrained() == 5 then
--            maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier3 * skillMultiplierBonus;
--        elseif item:getLvlSkillTrained() == 7 then
--            maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier4 * skillMultiplierBonus;
--        elseif item:getLvlSkillTrained() == 9 then
--            maxMultiplier = SkillBook[item:getSkillTrained()].maxMultiplier5 * skillMultiplierBonus;
--        else
--            maxMultiplier = 1
--            print('ERROR: book has unhandled skill level ' .. item:getLvlSkillTrained())
--        end
--    end
--
--    if (not maxMultiplier) or (maxMultiplier < 1.1) then maxMultiplier = 1.1 end
--    return maxMultiplier
--end


local function ReadForget(character,item,maxMultiplier)
    local rp = character:getAlreadyReadPages(item:getFullType())
    local np = item:getNumberOfPages()
    if rp >= np then
        if maxMultiplier then
            local perk = SkillBook[item:getSkillTrained()].perk
            if character:getPerkLevel(perk) < item:getMaxLevelTrained() then
                local cm = character:getXp():getMultiplier(perk)
                if maxMultiplier - cm > 0.001 then
                    local setPages = math.floor(np * cm / maxMultiplier)
                    character:setAlreadyReadPages(item:getFullType(), setPages)
                    character:Say("I didn't know that!")
                    return setPages
                end
            end
        elseif not (item:getTeachedRecipes() and not item:getTeachedRecipes():isEmpty()) then
            character:Say("I've read this recipe literature")
            return false
        else
            character:setAlreadyReadPages(item:getFullType(), 0)
            return 0
        end
        character:Say("I've read this already")
        return false
    end
end

--local function calcPages(character,item)
--    local itemPages = item:getNumberOfPages()
--    local alreadyReadPages = character:getAlreadyReadPages(item:getFullType())
--    if itemPages <= -1 and item:canBeWrite() == false then itemPages = utils.BetLitCalcPages(item) end
--    if itemPages < 0 then itemPages = 5 end
--
--    local maxMultiplier = SkillBook[item:getSkillTrained()] and CalcMaxMultiplier(character,item)
--    --itemPages, alreadyReadPages = resetPages(itemPages, alreadyReadPages, character, item)
--    itemPages = ReadForget(character, item, maxMultiplier) or itemPages -- if read already
--
--end

local function StateSpeed(state, character)
    local readspeed
    if state == "Sit" then
        readspeed = 0.9
    elseif state == "Move"  then
        local readlevel = character:getPerkLevel(Perks.Intelligence)
        if readlevel < 10 then
            readspeed = 3 - 0.4 * math.floor(readlevel/2)
        else
            readspeed = 1
        end
    else
        readspeed = 1
    end
    return readspeed
end

local function isCharacterState(character)
    if character:isSitOnGround() then
        return "Sit"
    elseif character:isPlayerMoving()  then
        return "Move"
    else
        return "Other"
    end
end

local function checkTime(self)
    local currentState = isCharacterState(self.character)
    if currentState ~= self.characterState then
        local newSpeed = StateSpeed(currentState, self.character)
        local newTime = self.baseTime * newSpeed
        self.action:setTime(newTime)
        self.action:setCurrentTime(newTime * self.action:getJobDelta())
        self.characterState = currentState
    end
end

function ISReadABookInt:isValid()
    local valid = ISReadABook.isValid(self)
    if valid then checkTime(self) end
    return valid
    --return (ISReadABook.isValid(self,...) and isCharacterState(self.character) == self.characterState)
end

function ISReadABookInt:update()
    self.pageTimer = self.pageTimer + getGameTime():getMultiplier()
    self.item:setJobDelta(self:getJobDelta());

    if self.item:getNumberOfPages() > 0 then
        local pagesRead = math.floor(self.item:getNumberOfPages() * self:getJobDelta())
        self.item:setAlreadyReadPages(pagesRead);
        if self.item:getAlreadyReadPages() > self.item:getNumberOfPages() then
            self.item:setAlreadyReadPages(self.item:getNumberOfPages());
        end

        --IntReading add xp
        local itemPages = self.item:getAlreadyReadPages()
        local characterPages = self.character:getAlreadyReadPages(self.item:getFullType())
        if characterPages < itemPages and self.character:getPerkLevel(Perks.Intelligence) < 10 then
            self.character:getXp():AddXP(Perks.Intelligence, (itemPages - characterPages) * SandboxVars.ReadingSkill.BaseEXP,true,true,true)
            --self.pageXP = currentPage
        end
        --self.prevDelta = self:getJobDelta()

        self.character:setAlreadyReadPages(self.item:getFullType(), itemPages)
    end
    if SkillBook[self.item:getSkillTrained()] then
        if self.item:getLvlSkillTrained() > self.character:getPerkLevel(SkillBook[self.item:getSkillTrained()].perk) + 1 or self.character:HasTrait("Illiterate") then
            if self.pageTimer >= 200 then
                self.pageTimer = 0;
                local txtRandom = ZombRand(3);
                if txtRandom == 0 then
                    self.character:Say(getText("IGUI_PlayerText_DontGet"));
                elseif txtRandom == 1 then
                    self.character:Say(getText("IGUI_PlayerText_TooComplicated"));
                else
                    self.character:Say(getText("IGUI_PlayerText_DontUnderstand"));
                end
                if self.item:getNumberOfPages() > 0 then
                    self.character:setAlreadyReadPages(self.item:getFullType(), 0)
                    self:forceStop()
                end
            end
        elseif self.item:getMaxLevelTrained() < self.character:getPerkLevel(SkillBook[self.item:getSkillTrained()].perk) + 1 then
            if self.pageTimer >= 200 then
                self.pageTimer = 0;
                local txtRandom = ZombRand(2);
                if txtRandom == 0 then
                    self.character:Say(getText("IGUI_PlayerText_KnowSkill"));
                else
                    self.character:Say(getText("IGUI_PlayerText_BookObsolete"));
                end
            end
        else
            --IntReading use self
            self:checkMultiplier()
        end
    end

    -- Playing with longer day length reduces the effectiveness of morale-boosting
    -- literature, like Comic Book.
    local bodyDamage = self.character:getBodyDamage()
    local stats = self.character:getStats()
    if self.stats and (self.item:getBoredomChange() < 0.0) then
        if bodyDamage:getBoredomLevel() > self.stats.boredom then
            bodyDamage:setBoredomLevel(self.stats.boredom)
        end
    end
    if self.stats and (self.item:getUnhappyChange() < 0.0) then
        if bodyDamage:getUnhappynessLevel() > self.stats.unhappyness then
            bodyDamage:setUnhappynessLevel(self.stats.unhappyness)
        end
    end
    if self.stats and (self.item:getStressChange() < 0.0) then
        if stats:getStress() > self.stats.stress then
            stats:setStress(self.stats.stress)
        end
    end

end

--function ISReadABookInt:checkMultiplier()
--    local trainedStuff = SkillBook[self.item:getSkillTrained()];
--    if trainedStuff then
--        -- every 10% we add 10% of the max multiplier
--        local readPercent = (self.item:getAlreadyReadPages() / self.item:getNumberOfPages()) * 100;
--        if readPercent > 100 then
--            readPercent = 100;
--        end
--        -- apply the multiplier to the skill
--        local multiplier = (math.floor(readPercent/10) * (self.maxMultiplier/10));
--        if multiplier > self.character:getXp():getMultiplier(trainedStuff.perk) then
--            --self.character:getXp():addXpMultiplier(trainedStuff.perk, multiplier, self.item:getLvlSkillTrained(), self.item:getMaxLevelTrained());
--
--            --tweak levels
--            self.character:getXp():addXpMultiplier(trainedStuff.perk, multiplier, 1, 11) -- all levels, xp of 11 is same as 10 so it will be removed
--            --self.character:getXp():addXpMultiplier(trainedStuff.perk, multiplier, 1, self.item:getMaxLevelTrained() + 1) -- xp of 11 is same as 10 so it will be removed
--        end
--    end
--end

--function ISReadABookInt:start()
--    if self.startPage then
--        self:setCurrentTime(self.maxTime * (self.startPage / self.item:getNumberOfPages()))
--    end
--    self.item:setJobType(getText("ContextMenu_Read") ..' '.. self.item:getName());
--    self.item:setJobDelta(0.0);
--    --self.character:SetPerformingAction(GameCharacterActions.Reading, nil, self.item)
--    if (self.item:getType() == "Newspaper") then
--        self:setAnimVariable("ReadType", "newspaper")
--    else
--        self:setAnimVariable("ReadType", "book")
--    end
--    self:setActionAnim(CharacterActionAnims.Read);
--    self:setOverrideHandModels(nil, self.item);
--    self.character:setReading(true)
--
--    self.character:reportEvent("EventRead");
--
--    if not SkillBook[self.item:getSkillTrained()] then
--        self.stats = {}
--        self.stats.boredom = self.character:getBodyDamage():getBoredomLevel()
--        self.stats.unhappyness = self.character:getBodyDamage():getUnhappynessLevel()
--        self.stats.stress = self.character:getStats():getStress()
--    end
--
--    if SkillBook[self.item:getSkillTrained()] then
--        self.character:playSound("OpenBook")
--    else
--        self.character:playSound("OpenMagazine")
--    end
--end

--function ISReadABookInt:start(...)
--    if self.prevDelta == 0 then return ISReadABook.start(self,...) end
--    self:setCurrentTime(self.maxTime * self.prevDelta)
--    --self.item:setJobType(getText("ContextMenu_Read") ..' '.. self.item:getName());
--    --self.item:setJobDelta(0.0);
--    if (self.item:getType() == "Newspaper") then
--        self:setAnimVariable("ReadType", "newspaper")
--    else
--        self:setAnimVariable("ReadType", "book")
--    end
--    self:setActionAnim(CharacterActionAnims.Read);
--    self:setOverrideHandModels(nil, self.item);
--    self.character:setReading(true)
--    self.character:reportEvent("EventRead");
--    if not SkillBook[self.item:getSkillTrained()] then
--        self.stats = {}
--        self.stats.boredom = self.character:getBodyDamage():getBoredomLevel()
--        self.stats.unhappyness = self.character:getBodyDamage():getUnhappynessLevel()
--        self.stats.stress = self.character:getStats():getStress()
--    end
--end

--function ISReadABookInt:stop(...)
--    if isCharacterState(self.character) == self.characterState then return ISReadABook.stop(self,...) end
--    local delta = self:getJobDelta()
--    if delta < self.prevDelta then delta = self.prevDelta end --switching fast between states will return 0 delta
--    ISBaseTimedAction.stop(self)
--    ISTimedActionQueue.add(ISReadABookInt:new(self.character, self.item, self.initialTime, delta))
--end

--function ISReadABookInt:stop()
--    if self.item:getNumberOfPages() > 0 and self.item:getAlreadyReadPages() >= self.item:getNumberOfPages() then
--        self.item:setAlreadyReadPages(self.item:getNumberOfPages());
--    end
--    self.character:setReading(false);
--    self.item:setJobDelta(0.0);
--    if SkillBook[self.item:getSkillTrained()] then
--        self.character:playSound("CloseBook")
--    else
--        self.character:playSound("CloseMagazine")
--    end
--    ISBaseTimedAction.stop(self);
--end

local multiplierDownOpt = 0.02
local maxPagesLowered = 0.4
function ISReadABookInt:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = false
    o.stopOnRun = true;

    local numPages = item:getNumberOfPages()
    local alreadyReadPages = character:getAlreadyReadPages(item:getFullType())
    --print("zx debug",numPages,alreadyReadPages)
    if numPages <= -1 and item:canBeWrite() == false then numPages = utils.BetLitCalcPages(item) end
    if numPages < 0 then numPages = 8 end
    local skillBook = SkillBook[item:getSkillTrained()]
    local maxMultiplier = skillBook and CalcMaxMultiplier(character,item)
    --numPages, alreadyReadPages = resetPages(numPages, alreadyReadPages, character, item)

    --set alreadyReadPages pages
    --if we would get higher multiplier from reading instantly then lower pages, don't lower below 1 multiplier
    if maxMultiplier then
        if character:getPerkLevel(skillBook.perk) < item:getMaxLevelTrained() then
            local readPercent = math.min(1,alreadyReadPages/numPages)
            local pagesMultiplier = math.floor(readPercent*10) / 10 * maxMultiplier
            local currentMultiplier = character:getXp():getMultiplier(skillBook.perk)
            if pagesMultiplier > currentMultiplier + 1e-6 then
                local pages = math.floor(numPages * math.max(1,currentMultiplier) / maxMultiplier)

                if pages < alreadyReadPages then print("lowering pages ",pagesMultiplier,currentMultiplier,pages,alreadyReadPages) end

                if pages < alreadyReadPages then alreadyReadPages = pages end
            end
            --local pages = 0
            --if numPages <= alreadyReadPages then
            --        local cm = character:getXp():getMultiplier(skillBook.perk)
            --        local percent = cm/maxMultiplier
            --        if percent < 0.99999 then
            --            alreadyReadPages = math.floor(numPages * (1 -  maxPagesLowered * (1 - percent)))
            --        end
            --        --[[
            --        local dif = maxMultiplier - cm
            --        if dif > 0.00001 then
            --            local pagesForMultiplier = math.floor( numPages - dif / multiplierDownOpt * downPagesPerDay )
            --            if pagesForMultiplier < alreadyReadPages then alreadyReadPages = math.max(pagesForMultiplier,0) end
            --            --if maxMultiplier * 80 < numPages then
            --            --    alreadyReadPages = math.floor(numPages - dif / 0.1 * 8 )
            --            --else
            --            --    alreadyReadPages = math.floor(numPages * cm / maxMultiplier)
            --            --end
            --        end
            --        --alreadyReadPages = numPages - 8
            --    end
            --        --]]
            --
            --end
        end

    elseif numPages <= alreadyReadPages then
        if not (item:getTeachedRecipes() and not item:getTeachedRecipes():isEmpty()) then
            alreadyReadPages = numPages - 8
        else
            alreadyReadPages = 0
        end
    --elseif maxMultiplier then -- lower pages if not read today? - stop instant 90%
    end
    character:setAlreadyReadPages(item:getFullType(), alreadyReadPages)
    item:setAlreadyReadPages(alreadyReadPages)
    o.startPage = alreadyReadPages

    --print("zx debug 2",character:getAlreadyReadPages(item:getFullType()))
    if isClient() then
        o.minutesPerPage = getServerOptions():getFloat("MinutesPerPage") or 1.0
        if o.minutesPerPage < 0.0 then o.minutesPerPage = 1.0 end
    else
        o.minutesPerPage = 2.0
    end
    local f = 1 / getGameTime():getMinutesPerDay() / 2
    time = numPages * o.minutesPerPage / f

    if(character:HasTrait("FastReader")) then
        time = time * 0.7;
    end
    if(character:HasTrait("SlowReader")) then
        time = time * 1.3;
    end
    time = time * (1.15 - 0.03 * character:getPerkLevel(Perks.Intelligence))
    o.baseTime = time;
    o.characterState = isCharacterState(character)
    time = time * StateSpeed(o.characterState, character)

    o.ignoreHandsWounds = true;
    o.maxTime = time; --used for start action
    o.caloriesModifier = 0.5;
    o.pageTimer = 0;
    o.forceProgressBar = true;
    o.maxMultiplier = maxMultiplier
    if character:isTimedActionInstant() then
        o.maxTime = 1;
    end

    return o
end
