-- Game Map | This will manage all functions for imported game maps
Object = require('classes/classic')
require('miscellaneous/helpers')
gameMap = Object:extend()

function gameMap.new(self, pathToMap)
    self.pathToMap = pathToMap
    self.map = sti(self.pathToMap)
    self.scaleCoords={}
    
end 

function gameMap.draw(self)
    for layer = 1, #self.map.layers do
        self.map:drawLayer(self.map.layers[layer])
    end 
    
end 

function gameMap.update(self,dt)
    self.scaleD(self)
    self.map:update(dt)
end 

--==============================
--HELPER FUNCTIONS FOR GAME MAP=
--==============================

function gameMap.scaleD(self)
    -- self.scale.x = WINDOW_WIDTH / 1080
    -- self.scale.y = WINDOW_HEIGHT / 720
    love.graphics.scale(4,4)
end 