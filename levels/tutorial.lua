require('miscellaneous/helpers')

Object = require('classes/classic')
local tutorial = {}
tutorial.font = love.graphics.newFont( 18)


function tutorial.load()
    tmp = {}
    player1 = Player(400,300)
    tutorialMap = gameMap('assets/gameMaps/thesis2TutMap.lua')
    table.insert(tmp, player1)
    table.insert(tmp, tutorialMap)
    tutorialLevel = Level(tmp)
end 

function tutorial.draw()
    tutorialLevel.draw(tutorialLevel)
    -- love.graphics.setFont(tutorial.font)
end 


function tutorial.update(dt)
    tutorialLevel.update(tutorialLevel, dt)
end 

return tutorial