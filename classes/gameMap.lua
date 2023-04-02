-- Game Map | This will manage all functions for imported game maps
Object = require('classes/classic')
require('miscellaneous/helpers')
require("classes/levels")
gameMap = Object:extend()

function gameMap.new(self, pathToMap, world)
    self.pathToMap = pathToMap
    self.map = sti(self.pathToMap)
    self.world = world
    self.walls = {}
    
    if self.map.layers["Object"] then 
        for i, obj in pairs(self.map.layers["Object"].objects) do
            self.wall = self.world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            self.wall:setType('static')
            table.insert(self.walls, wall)
        end 
    end 
    
end 

function gameMap.draw(self)
    for layer = 1, #self.map.layers do
        if  self.map.layers[layer].name ~= "Object" then 
            self.map:drawLayer(self.map.layers[layer])   
        end 
    end 
    self.world:draw()
end 

function gameMap.update(self,dt)
    
    self.world:update(dt)
    self.map:update(dt)
end 

--==============================
--HELPER FUNCTIONS FOR GAME MAP=
--==============================


