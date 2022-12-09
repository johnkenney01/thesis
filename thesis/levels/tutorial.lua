require('miscellaneous/helpers')
Object = require('classes/classic')
local tutorial = {}


function tutorial.load()
    player1 = Player(300,200)
end 

function tutorial.draw()
    player1.draw(player1)
    font = love.graphics.newFont(18)
    love.graphics.setFont(font)
end 


function tutorial.update(dt)
    player1.update(player1, dt)
end 

return tutorial