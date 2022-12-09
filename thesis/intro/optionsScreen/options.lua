require('miscellaneous/helpers')
Object = require('classes/classic')
local options = {}
--gameState 2
function options.load()
    aboutButtonOP = Button('About', 'about', 2,1.5,300,50,50)
    controlsButtonOP = Button('Controls', 'controls', 2,1.3, 300, 50,50)
    backButtonOP = Button('Back', 'back', 2,1.2,300,50,50)
    backgroundOptions = createBackGroundImage('assets/intro.jpg')
end 

function options.draw()
    love.graphics.draw(backgroundOptions.image, 0,0,0,backgroundOptions.scaleX, backgroundOptions.scaleY)
    aboutButtonOP.draw(aboutButtonOP)
    controlsButtonOP.draw(controlsButtonOP)
    backButtonOP.draw(backButtonOP)
end 

function options.update(dt)
    setImageFullScreen(backgroundOptions)
    aboutButtonOP.update(aboutButtonOP, dt, aboutButtonOP_functionToCall)
    controlsButtonOP.update(controlsButtonOP, dt, controlsButtonOP_functionToCall)
    backButtonOP.update(backButtonOP,dt, backButtonOP_functionToCall)
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