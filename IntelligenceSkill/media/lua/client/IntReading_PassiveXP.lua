local IntXp
local function onAddXPLit (character, perk, xp)
	if not IntXp then
		if xp > 0 then
			local parent = perk:getParent():getId()
			local intXp
			if parent == "Crafting" then
				intXp = xp
			elseif parent == "Miscellaneous" then
				if perk:getId() == "Lockpicking" then
					intXp = xp
				end
			end

			if intXp then
				IntXp = true
				character:getXp():AddXP(Perks.Intelligence,intXp/ZombRand(1,3),true,false,false)
			end
		end
	else
		IntXp = false
	end
end

--mp should be everyhour for consistency and / or save last time updated
-- check halotext level up triggers, with level down off // character:getXp():setXPToLevel(perk,0)
local LevelDownOpt = false
--local multiplierDownOpt = 0.05
--local multiplierDownOpt = 0.05
--local maxLevel = 11
local function dailyXp()
	local PerkFactory = PerkFactory
	--do all players
	local player = getPlayer()
	--`if perk:getParent() ~= Perks.None then --[[...]] end` excludes the 'parent' perks Passiv, Combat, FireArm, Agility, Crafting, Survivalist
	for i=0, PerkFactory.PerkList:size() -1 do
		local perk = PerkFactory.PerkList:get(i)
		local level = player:getPerkLevel(perk)
		local TotalXpForLevel = perk:getTotalXpForLevel(level)
		local levelXp = player:getXp():getXP(perk) - TotalXpForLevel
		local xpDown = level + 1
		if levelXp > 0 or LevelDownOpt and level > 0 then
			if not LevelDownOpt and xpDown > levelXp then xpDown = levelXp end
				player:getXp():AddXPNoMultiplier(perk,-xpDown)
			if level == 10 then
				if player:getXp():getXP(perk) + 111 < perk:getTotalXpForLevel(level)  then player:LoseLevel(perk) end
			else
				if player:getXp():getXP(perk) < perk:getTotalXpForLevel(level) then player:LoseLevel(perk) end
			end
		end
		--local multiplier = player:getXp():getMultiplier(perk)
		--if multiplier > 0 and multiplierDownOpt > 0 then
		--	multiplier = multiplier > multiplierDownOpt and multiplier - multiplierDownOpt or 0
		--	player:getXp():addXpMultiplier(perk, multiplier, 1, 11) -- all levels
		--end
	end
end

Events.AddXP.Add(onAddXPLit)
Events.EveryDays.Add(dailyXp)
