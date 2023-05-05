require('miscellaneous/helpers')
wf = require("Love2OOD/externalLibraries/windfield")
Object = require('Love2OOD/classic')
local tutorial = {}
tutorial.font = love.graphics.newFont( 18)


function tutorial.load()

    tmp = {}
    enemy = {}
    tutorial.world = wf.newWorld(0,0)
    
    tutorial.world.name = "tut"

    -- player1 = Player(600,100, tutorial.world)
    for i = 1, 1 do 
        table.insert(enemy, Enemy(i *250, 100, "assets/spritesheets/wizardEnemy.png",tutorial.world, 2))
    end 
    tutorialMap = gameMap('assets/gameMaps/TestMap128.lua', tutorial.world)
    player1 = Player(600,100, tutorial.world)
    table.insert(tmp, player1)
    table.insert(tmp, tutorialMap)
    table.insert(tmp, enemy)
    tutorialLevel = Level(tmp, tutorial.world)
    
    
end 

function tutorial.draw() 
    tutorialLevel.draw(tutorialLevel)
end 


function tutorial.update(dt)
    tutorialLevel.update(tutorialLevel, dt)
end 


return tutorial 