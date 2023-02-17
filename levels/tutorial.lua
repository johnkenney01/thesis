require('miscellaneous/helpers')

Object = require('classes/classic')
local tutorial = {}
tutorial.font = love.graphics.newFont( 18)


function tutorial.load()
    tmp = {}
    player1 = Player(400,300)

    table.insert(tmp, player1)
    tutorialLevel = Level(tmp)
end 

function tutorial.draw()
    tutorialLevel.draw(tutorialLevel)
    -- love.graphics.setFont(tutorial.font)
    love.graphics.print(tostring(player1.health.healthBar.innerBar.startW.."\n"..player1.health.healthBar.innerBar.currentW), WINDOW_WIDTH - WINDOW_WIDTH/5, 100)
end 


function tutorial.update(dt)
    tutorialLevel.update(tutorialLevel, dt)
end 

return tutorial