require('miscellaneous/helpers')
Object = require('classes/classic')
camera = require("externalLibraries/camera")
sti = require("externalLibraries/sti")
wf = require("externalLibraries/windfield")
Level = Object:extend()

function Level.new(self, contents)
    -- Large Data Dump of all contents
    self.contents = contents
    -- Eventually will be all non player objects
    self.nonPlayerContents = {}
    -- Will be player, passed from level to level
    self.player = nil
    -- Camera for each level
    self.cam = camera()
    -- Game Map
    self.gameMap = sti('assets/gameMaps/thesis2TutMap.lua')
    -- Sorts and stores objects passed in to correct table
    for object = 1, #self.contents do
        if self.contents[object].__type == "player" then 
            self.player = self.contents[object]
        else
            table.insert(self.nonPlayerContents, self.contents[object])
        end 
    end 
     
end 

function Level.draw(self)
    -- Everything will be seen through the camera's POV that is within cam:attach() and cam:Detach()
    self.gameMap.resize(2)
    love.graphics.scale(WINDOW_WIDTH, WINDOW_HEIGHT)
    self.cam:attach()
        -- self.gameMap:drawLayer(self.gameMap.layers["Ground"])
        for i = 1, #self.gameMap.layers do 
            if self.gameMap.layers[i].name ~= "Object Layer 1" then 
                self.gameMap:drawLayer(self.gameMap.layers[i])
            end 
        end 
        for object = 1, #self.nonPlayerContents do 
            self.nonPlayerContents[object].draw(self.nonPlayerContents[object])
        end 
        self.player.draw(self.player)
    self.cam:detach()

    -- HUD THINGS etc.
    self.player.drawHUDThings(self.player)
    

end 

function Level.update(self, dt)
    self.gameMap:update(dt)
    self.cam:lookAt(self.player.x, self.player.y)
    self.player.update(self.player,dt)
    for i = 1, #self.nonPlayerContents do
        self.nonPlayerContents[i].update(self.nonPlayerContents[i], dt)
    end 
end 

--===============================================
--==========HELPERS FUNCTIONS FOR LEVELS========
--===============================================

function Level.getContents(self,dt)
    return self.contents
end 

function Level.genNewWorld(self)

end 
