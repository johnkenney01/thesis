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

    player1 = Player(400,300, tutorial.world)
    for i = 1, 10 do 
        table.insert(enemy, Enemy(i *250, 100, "assets/spritesheets/wizardEnemy.png",tutorial.world, 2))
    end 
    tutorialMap = gameMap('assets/gameMaps/TestMap128.lua', tutorial.world)
    
    table.insert(tmp, player1)
    table.insert(tmp, tutorialMap)
    table.insert(tmp, enemy)
    tutorialLevel = Level(tmp, tutorial.world)
end 

function tutorial.draw() 
    tutorialLevel.draw(tutorialLevel)
    --love.graphics.print((enemy[1].collider:getY()-(enemy[1].h/2)/2).."\n"..enemy[1].y - enemy[1].h/2,100,100)
    love.graphics.print(enemy[1].h,0,0)
end 


function tutorial.update(dt)
    tutorialLevel.update(tutorialLevel, dt)
end 

return tutorial 