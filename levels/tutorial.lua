require('miscellaneous/helpers')
wf = require("externalLibraries/windfield")
Object = require('classes/classic')
local tutorial = {}
tutorial.font = love.graphics.newFont( 18)


function tutorial.load()
    tmp = {}
    tutorial.world = wf.newWorld(0,0)
    player1 = Player(400,300, tutorial.world)
    tutorialMap = gameMap('assets/gameMaps/TestMap128.lua', tutorial.world)
    table.insert(tmp, player1)
    table.insert(tmp, tutorialMap)
    tutorialLevel = Level(tmp)
end 

function tutorial.draw()
    tutorialLevel.draw(tutorialLevel)
    love.graphics.print(player1.w.."\n"..player1.colliderWidthStart.."\n"..player1.attackType,100,100)
end 


function tutorial.update(dt)
    tutorialLevel.update(tutorialLevel, dt)
end 

return tutorial 