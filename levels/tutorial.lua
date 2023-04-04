require('miscellaneous/helpers')
wf = require("externalLibraries/windfield")
Object = require('classes/classic')
local tutorial = {}
tutorial.font = love.graphics.newFont( 18)


function tutorial.load()

    tmp = {}
    enemy = {}
    tutorial.world = wf.newWorld(0,0)
    tutorial.world.name = "tut"

    player1 = Player(400,300, tutorial.world)
    for i = 1, 10 do 
        table.insert(enemy, Enemy(i *250, 100, "assets/spritesheets/wizardEnemy.png",tutorial.world))
    end 
    tutorialMap = gameMap('assets/gameMaps/TestMap128.lua', tutorial.world)
    
    table.insert(tmp, player1)
    table.insert(tmp, tutorialMap)
    table.insert(tmp, enemy)
    tutorialLevel = Level(tmp, tutorial.world)
end 

function tutorial.draw() 
    tutorialLevel.draw(tutorialLevel)
    print("tut: "..tutorial.world.name)
    print("Playa: "..player1.world.name)
end 


function tutorial.update(dt)
    tutorialLevel.update(tutorialLevel, dt)
end 

return tutorial 