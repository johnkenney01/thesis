--requireAll.lua
--This will hold all the require statements and called all within one function so anytime we need a require module we can hold it here 
-- so there is one function call in main
--------------------------------



function getAllRequirements()
    require('graphics/graphics')
    require('Love2OOD/levels')
    require('intro/intro')
    require('intro/optionsScreen/options')
    require('levels/tutorial')
    require('intro/optionsScreen/controls')
    require('intro/optionsScreen/about')
    require('miscellaneous/helpers')
    require('Love2OOD/classic')
    require('Love2OOD/button')
    require('Love2OOD/headers')
    require('Love2OOD/player')
    require("Love2OOD/externalLibraries/camera")
    require("Love2OOD/nonLevelState")
    require("Love2OOD/externalLibraries/sti")
    require("Love2OOD/externalLibraries/windfield")
    require("Love2OOD/gameMap")
    require("Love2OOD/enemy")
    
    
end 


function getObjectClass()
    Object = require('Love2OOD/classic')
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




