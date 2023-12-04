local utils = {}

function utils.BetLitCalcPages(item)
    local pages

    --***********************************************************
    --Literacy skill section. If a book has zero pages, we'll give it pages
    local testVariableThree = item:getTeachedRecipes();

    -- if testVariableThree is not nil, then the book has recipies. Page count will then be decided based off how many recipes it teaches you.
    -- if it is nil, we'll base page count off how many stats it heals
    if testVariableThree == nil then

        -- Get the amount of boredom the book heals. we then multiply it by -1 so we get a positive number
        local boredomHeal = item:getBoredomChange() * -1;

        -- get the amount of stress the book heals. note: the stress healed is in a decimal format. IE a -20 stress book in code is -0.20
        -- So we take the stress (-0.2) and multiply it by 100 to get -20
        -- however there is some trail of the decimal places somehow, so we floor it.
        -- doing this however leads us to be one higher than the display value, so we add one to it
        -- we finally multiply it by -1 to get a positive number
        local stressHeal = (math.floor(item:getStressChange() * 100)+1) * -1;

        -- Get the amount of unhappyHeal the book heals. we then multiply it by -1 so we get a positive number
        local unhappyHeal = item:getUnhappyChange() * -1;

        -- We take the boredom, unhappyness, and stress healed and add them together. Each page has two sides, so we divied that number by 2.
        -- books, magazines, and newspapers are printed in sheets of 4, 8, or 12. newspapers and magazines are always 8 or 12. So for this mod I picked 8.
        -- So we need to get the page count "(boredomHeal + stressHeal + unhappyHeal)/2" to the nearest multiple of 8. to do this we divide the page count by 8
        local pagesInitial = ((boredomHeal + stressHeal + unhappyHeal)/2)/8;

        -- We then floor this number (instead of normal rounding or ceiling. no need to increase time read randomly)
        local pagesFloor = math.floor(pagesInitial);

        -- Then we take the page count and multiply it by 8, to get a whole number that is a multiple of 8 based off the amount of stats healed.
        -- Finally set the number of pages to this number
        pages = pagesFloor * 8

        -- Added in a check to see if  the value is -8 (a book with no stats and no recipes), if so set it to 8
    else
        -- Set a variable to count
        local testVariableFour = 0;

        -- Go through the array, and for each entry, increase the count variable by 1
        for index=0, testVariableThree:size() -1 do
            testVariableFour = testVariableFour + 1;
        end
        -- take how many times the loop happened with testVariableFour and multiply it by 8 to get the final page number of the recipe books
        pages = testVariableFour * 8
    end
    --***********************************************************

    if pages < 8 then pages = 8 end
    item:setNumberOfPages(pages)
    return pages
end

return utils