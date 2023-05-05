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
    self.world.map = self.map
    
    self.walls = {}
    self.__type = "game map"
    
    if self.map.layers["Object"] then 
        for i, obj in pairs(self.map.layers["Object"].objects) do

            --NEW WALLS 
            self.wall = {}
            self.wall.name = "WALLS"
            self.wall.x = obj.x 
            self.wall.y = obj.y 
            self.wall.w = obj.width
            self.wall.h = obj.height
            table.insert(self.walls, self.wall)
        end 
    end 
    self.world.walls = self.walls
    self.initBorders(self)
    
end 

function gameMap.draw(self)
    for layer = 1, #self.map.layers do
        if  self.map.layers[layer].name ~= "Object" then 
            self.map:drawLayer(self.map.layers[layer])   
        end 
    end 
    for i = 1, #self.walls do 
        love.graphics.rectangle("line", self.walls[i].x, self.walls[i].y, self.walls[i].w,self.walls[i].h)
    end
    
    for i = 1, #self.border do
        
        love.graphics.rectangle('line', self.border[i].x,self.border[i].y,self.border[i].w,self.border[i].h)
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
    
    self.border = {}
    self.w = 10


    self.top = {}
    self.top.x, self.top.y = 0, 0
    self.top.w, self.top.h = self.mapWidth, self.w
    table.insert(self.border, self.top)
    

    -- self.bottom = self.world:newRectangleCollider(0, self.mapHeight - self.w, self.mapWidth, self.w)
    -- self.bottom:setType("static")
    -- self.bottom:setCollisionClass(")

    self.bottom = {}
    self.bottom.x, self.bottom.y = 0, self.mapHeight - 10
    self.bottom.w, self.bottom.h = self.mapWidth, self.w
    table.insert(self.border, self.bottom)


    -- self.left = self.world:newRectangleCollider(0, 0, self.w, self.mapHeight)
    -- self.left:setType("static")
    -- self.left:setCollisionClass(")

    self.left = {}
    self.left.x, self.left.y = 0, 0
    self.left.w, self.left.h =  self.w,self.mapWidth
    table.insert(self.border, self.left)
    -- self.right = self.world:newRectangleCollider(self.mapWidth - self.w, 0,   self.w, self.mapHeight)
    -- self.right:setType("static")
    -- self.right:setCollisionClass(")
    -- print(self.right.collision_class)

    self.right = {}
    self.right.x, self.right.y = self.mapWidth-10,0
    self.right.w, self.right.h = self.w, self.mapHeight
    table.insert(self.border, self.right)
    print('YURT: '..self.right.x.." "..self.right.w.." "..self.right.h)
end 

