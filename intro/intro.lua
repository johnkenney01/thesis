require('miscellaneous/helpers')
Object = require('classes/classic')
local intro = {}

header1 = "Forge On"
titleColor = {1,1,0.3,1}

function intro.load()
    titleHeader = Header(header1,WINDOW_WIDTH/50, WINDOW_HEIGHT/3,1,1, WINDOW_WIDTH*.30,titleColor, true )
    startButton = Button('Start Game', "start", 2, 1.5, 300, 50,WINDOW_WIDTH*.045)
    loadButton = Button('Load Game', 'load', 2, 1.3, 200, 50,WINDOW_WIDTH*.045)
    optionsButton = Button('Options', "options", 2, 1.1, 300, 50,WINDOW_WIDTH*.045)
    quitButton = Button('Quit', "quit", 2, 1.22, 300, 50,WINDOW_WIDTH*.045)
    backgroundMainMenu = createBackGroundImage('assets/intro.jpg')
end 

function intro.draw()
    love.graphics.draw(backgroundMainMenu.image, 0,0,0,backgroundMainMenu.scaleX, backgroundMainMenu.scaleY)
    titleHeader.draw(titleHeader)
    startButton.draw(startButton)
    quitButton.draw(quitButton)
    optionsButton.draw(optionsButton)
    loadButton.draw(loadButton)
end 

function intro.update(dt)
    setImageFullScreen(backgroundMainMenu)
    startButton.update(startButton, dt, startButton_functionToCall)
    quitButton.update(quitButton, dt, quitButton_functionToCall)
    optionsButton.update(optionsButton, dt, optionsButton_functionToCall)
    loadButton.update(loadButton, dt)
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


