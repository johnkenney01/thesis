require('miscellaneous/helpers')
Object = require('classes/classic')
camera = require("externalLibraries/camera")
cam = camera()

Level = Object:extend()

function Level.new(self, contents)
    self.contents = contents
end 

function Level.draw(self)
    
    for i = 1, #self.contents do
        if self.contents[i].__type == "player" then 
            cam:attach()
                self.contents[i].draw(self.contents[i])
            cam:detach()
        else
            self.contents[i].draw(self.contents[i])
        end 
    end 
end 

function Level.update(self, dt)
    for i = 1, #self.contents do
        self.contents[i].update(self.contents[i], dt)
        if self.contents[i].__type == "player" then 
            cam:lookAt(self.contents[i].x, self.contents[i].y)
        end 
    end 
end 

function Level.getContents(self,dt)
    return self.contents
end 