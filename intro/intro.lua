require('miscellaneous/helpers')
Object = require('Love2OOD/classic')
local intro = {}

header1 = "Love 2OOD"
titleColor = {1,1,0.3,1}

function intro.load()
    intro.contents = {}
    titleHeader = Header(header1,WINDOW_WIDTH/50, WINDOW_HEIGHT/3,1,1, WINDOW_WIDTH*.20,titleColor, false, intro.contents )
    -- BUTTONS --
    startButton = Button('Test Engine', "start", 2, 2, 0.025, startButton_functionToCall, intro.contents)
    loadButton = Button('Test Button 1', 'load', 2, 1.75,  0.025, nil,  intro.contents )
    optionsButton = Button('Test Button 2', "options", 2, 1.53125, 0.025, optionsButton_functionToCall, intro.contents)
    quitButton = Button('Quit', "quit", 2, 1.33984375,  0.025, quitButton_functionToCall, intro.contents)
    --------------
    introLevel = nonLevelState(intro.contents)

    backgroundMainMenu = createBackGroundImage('assets/intro.jpg')
end 

function intro.draw()
    love.graphics.draw(backgroundMainMenu.image, 0,0,0,backgroundMainMenu.scaleX, backgroundMainMenu.scaleY)
    introLevel.draw(introLevel)
end 

function intro.update(dt)
    setImageFullScreen(backgroundMainMenu)
    introLevel.update(introLevel, dt)
end 


------------------------------------------
-- BUTTON FUNCTIONS, Button Specific Functions to do when clicked
function optionsButton_functionToCall()
    gameState = 2
end 
function startButton_functionToCall()
    gameState = 3
end 
function quitButton_functionToCall()
    love.event.quit()
end 

------------------------------------------

return intro


