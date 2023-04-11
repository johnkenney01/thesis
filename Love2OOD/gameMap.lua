-- Game Map | This will manage all functions for imported game maps
Object = require('Love2OOD/classic')
require('miscellaneous/helpers')
require("Love2OOD/levels")
gameMap = Object:extend()

function gameMap.new(self, pathToMap, world)
    self.pathToMap = pathToMap
    self.map = sti(self.pathToMap)
    self.mapWidth, self.mapHeight = self.map.width * self.map.tilewidth, self.map.height * self.map.tileheight
    self.world = world
    self.walls = {}
    
    if self.map.layers["Object"] then 
        for i, obj in pairs(self.map.layers["Object"].objects) do
            self.wall = self.world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            self.wall:setType('static')
            table.insert(self.walls, wall)
        end 
    end 
    
    self.initBorders(self)
    
end 

function gameMap.draw(self)
    for layer = 1, #self.map.layers do
        if  self.map.layers[layer].name ~= "Object" then 
            self.map:drawLayer(self.map.layers[layer])   
        end 
    end 
end 

function gameMap.update(self,dt)
    
    self.world:update(dt)
    self.map:update(dt)
end 

--==============================
--HELPER FUNCTIONS FOR GAME MAP=
--==============================
function gameMap.initBorders(self)
    -- This function creates borders specific to the map's dimensions
    self.world:addCollisionClass("Border")
    self.border = {}
    self.border.w = 1

    self.border.top = self.world:newRectangleCollider(0,0,self.mapWidth, self.border.w)
    self.border.top:setType('static')
    self.border.top:setCollisionClass("Border")

    self.border.bottom = self.world:newRectangleCollider(0, self.mapHeight - self.border.w, self.mapWidth, self.border.w)
    self.border.bottom:setType("static")
    self.border.bottom:setCollisionClass("Border")

    self.border.left = self.world:newRectangleCollider(0, 0, self.border.w, self.mapHeight)
    self.border.left:setType("static")
    self.border.left:setCollisionClass("Border")

    self.border.right = self.world:newRectangleCollider(self.mapWidth - self.border.w, 0,   self.border.w, self.mapHeight)
    self.border.right:setType("static")
    self.border.right:setCollisionClass("Border")
end 

