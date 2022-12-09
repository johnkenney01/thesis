require('miscellaneous/helpers')
Object = require('classes/classic')
local controls = {}
--Gam State  5
function controls.load()
    controls = {}
    table.insert(controls, 'Move   = W,A,S,D')
    table.insert(controls, 'Attack = Space Bar')
    table.insert(controls, 'Switch Attack Type = E')
    table.insert(controls, 'Pick Up Item  = F')
    table.insert(controls, 'Open Inventory = I')
    table.insert(controls, 'toggle Full screen = F1')
    backButtonCONTROL = Button('Back', 'back',2,1.3,300,50,50 )
    backgroundControls = createBackGroundImage('assets/intro.jpg')
end 

function controls.draw()
    love.graphics.draw(backgroundControls.image, 0,0,0,backgroundControls.scaleX, backgroundControls.scaleY)
    for i=1,  #controls do 
        love.graphics.setColor(1,1,0.3,1)
        love.graphics.printf(controls[i], 0, i*100, WINDOW_WIDTH - 50, 'center' )
    end 
    backButtonCONTROL.draw(backButtonCONTROL)
end 

function controls.update(dt)
    setImageFullScreen(backgroundControls)
    backButtonCONTROL.update(backButtonCONTROL,dt, backButtonCONTROL_functionToCall)
end 
function backButtonCONTROL_functionToCall()
    gameState = 2
end 


return controls