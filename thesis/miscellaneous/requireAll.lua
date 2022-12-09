--requireAll.lua
--This will hold all the require statements and called all within one function so anytime we need a require module we can hold it here 
-- so there is one function call in main
--------------------------------



function getAllRequirements()
    require('graphics/graphics')
    require('intro/intro')
    require('intro/optionsScreen/options')
    require('levels/tutorial')
    require('intro/optionsScreen/controls')
    require('intro/optionsScreen/about')
    require('miscellaneous/helpers')
    require('classes/classic')
    require('classes/button')
    require('classes/headers')
    require('classes/player')
    
end 


function getObjectClass()
    Object = require('classes/classic')
end 

function getAllGameStates()
    intro = require('intro/intro') --gamestate 1
    options = require('intro/optionsScreen/options') --gamestate 2
    tutorial = require('levels/tutorial') --gamestate 3
    about = require('intro/optionsScreen/about')--gamestate 4
    controls = require('intro/optionsScreen/controls') --gamestate 5


    allGameStates = {}
    table.insert(allGameStates, intro)
    table.insert(allGameStates,options)
    table.insert(allGameStates,tutorial)
    table.insert(allGameStates,about)
    table.insert(allGameStates,controls)


    return allGameStates
end 




