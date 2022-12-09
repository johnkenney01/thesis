--main.lua
--This is the main part of the game, everything will run from this screen and what levels and states are are control
-- and contained within this page
---------------------
--This gets all the required Modules In the entire program
require('miscellaneous/requireAll')
getAllRequirements()
-- love._openConsole()

gameState = 1
--------------------
-- This table allGameStates, will hold all the tables which are essentially all the levels of the game
allGameStates = getAllGameStates()

-----------------------------------------
function love.load()
    intializeGraphics()
    for i = 1, #allGameStates do
        allGameStates[i].load()
    end 
end -- end of love.load()
-----------------------------------------

-----------------------------------------
function love.draw()
    allGameStates[gameState].draw()
    print(gameState)
end -- end of love.draw()
-----------------------------------------

-----------------------------------------
function love.update(dt)
    allGraphics(dt) --Updates the graphics, if we were to switch out of full screen 
    allGameStates[gameState].update(dt)
end -- end of love.update(dt)
-----------------------------------------