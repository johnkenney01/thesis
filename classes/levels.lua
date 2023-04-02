require('miscellaneous/helpers')
Object = require('classes/classic')
camera = require("externalLibraries/camera")
sti = require("externalLibraries/sti")
wf = require("externalLibraries/windfield")
Level = Object:extend()

function Level.new(self, contents, world)
    -- new world for phyics, params 0,0 for 0 gravity 
    self.world = world
    -- Large Data Dump of all contents
    self.contents = contents
    -- Eventually will be all non player objects
    self.nonPlayerContents = {}
    -- Will be player, passed from level to level
    self.player = nil
    -- Camera for each level
    self.cam = camera(0,0)
    -- Game Map
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
    self.cam:zoomTo(WINDOW_WIDTH/1920)
    -- Everything will be seen through the camera's POV that is within cam:attach() and cam:Detach()
    self.cam:attach()
        for object = 1, #self.nonPlayerContents do 
            self.nonPlayerContents[object].draw(self.nonPlayerContents[object])
        end 
        self.player.draw(self.player)
    self.cam:detach()

    -- HUD THINGS etc.
    self.player.drawHUDThings(self.player)
    

end 

function Level.update(self, dt)
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

function Level.getWorld(self)
    return self.world
end 
