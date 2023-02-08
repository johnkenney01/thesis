require('miscellaneous/helpers')
Object = require('classes/classic')

Level = Object:extend()

function Level.new(self, contents)
    self.contents = contents
end 

function Level.draw(self)
    for i = 1, #self.contents do
        self.contents[i].draw(self.contents[i])
    end 
end 

function Level.update(self, dt)
    for i = 1, #self.contents do
        self.contents[i].update(self.contents[i], dt)
    end 
end 