require('miscellaneous/helpers')
Object = require('classes/classic')
local options = {}
--gameState 2
function options.load()
    backgroundOptions = createBackGroundImage('assets/intro.jpg')
end 

function options.draw()
    love.graphics.draw(backgroundOptions.image, 0,0,0,backgroundOptions.scaleX, backgroundOptions.scaleY)
end 

function options.update(dt)
    setImageFullScreen(backgroundOptions)
end 


-------------------------------
--BUTTON FUNCTIONS
function aboutButtonOP_functionToCall()
    gameState = 4
end 
function backButtonOP_functionToCall()
    gameState = 1
end 
function controlsButtonOP_functionToCall()
    gameState = 5
end 

return options