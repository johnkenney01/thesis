require('miscellaneous/helpers')
Object = require('Love2OOD/classic')
nonLevelState = Object:extend()
-- 
--     This class is a container class for all non level modules.
--     Some examples are intro level,  death screen etc. Things that do 
--     not have players.
-- 

function nonLevelState.new(self, contents)
    self.contents = contents
end 

function nonLevelState.draw(self)
    for object = 1, #self.contents do
        self.contents[object].draw(self.contents[object])
    end 
end 

function nonLevelState.update(self, dt)
    for object = 1,  #self.contents do 
        self.contents[object].update(self.contents[object], dt)
    end 
end 