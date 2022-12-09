require('miscellaneous/helpers')
Object = require('classes/classic')

Player = Object:extend()

function Player.new(self,x,y)
    -- LUA x and Y by default are top left
    self.spritesheet = love.graphics.newImage("assets/spritesheets/playerSpriteSheet.png")
    self.xTop = x 
    self.yTop = y
    self.w = 250
    self.h = 350
    self.x = self.xTop - (self.w/2)
    self.y = self.yTop - (self.h/2)
    self.direction = "right"
    self.state = "idle"

    self.hitbox = self.generateHitBox(self)
    
    -- QUAD STUFF
    self.getQuad(self)
    self.currentFrame = 1 
    self.scaleX = self.w/21
    self.scaleY = self.h/31
    self.timeSinceLastFrame = 0
    self.frameDelay = 0.17

end 

function Player.draw(self)
    setColor(1,0,0,1)
    -- love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
    setColor(1,1,1,1)
    love.graphics.rectangle('line', self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
    -- love.graphics.draw(self.spritesheet, self.idleQuad[self.currentFrame], self.x, self.y+7,0, self.scaleX, self.scaleY, 1)
    self.drawSpecificQuad(self)
    love.graphics.print('Time Since Last Frame: '..self.timeSinceLastFrame
                        ..'\n'
                        ..'Current State: '..self.state
                        ..'\n',0,0)
    love.graphics.print('Player Hitbox', self.hitbox.x + 10, self.hitbox.y + self.hitbox.h/2)
end 

function Player.update(self, dt)
    self.movement(self,dt)
    self.updateHitBox(self,dt)
    self.setQuads(self,dt)
end 



----------------------------------------------------------------
------------------HELPER FUNCTIONS FOR PLAER--------------------
----------------------------------------------------------------


-- Generate Hitbox based on init variables
function Player.generateHitBox(self)
    self.hitbox = {}
    self.hitbox.x = self.x + self.w 
    self.hitbox.y = self.y
    self.hitbox.w = self.w * (2/3)
    self.hitbox.h = self.h

    return self.hitbox
end 

-- Updates Player Movement Vars, called in update
function Player.movement(self,dt)
    --Up 
    if love.keyboard.isDown('w') then 
        self.state = "running"
        self.y = self.y - 15
        self.hitbox.y = self.hitbox.y - 15
    --Left
    elseif love.keyboard.isDown('a') then
        self.state = "running" 
        self.direction = "left"
        self.x = self.x - 15
        self.hitbox.x = self.hitbox.x - 15
    --Down
    elseif love.keyboard.isDown('s') then 
        self.state = "running"
        self.y = self.y + 15
        self.hitbox.y = self.hitbox.y + 15
    --Right
    elseif love.keyboard.isDown('d') then 
        self.direction = "right"
        self.state = "running"
        self.x = self.x + 15
        self.hitbox.x = self.hitbox.x + 15
    else 
        self.state = 'idle'
    end 
end 

-- Updates the position variables for the hitbox
function Player.updateHitBox(self, dt)
    if self.direction == "right" then 
        self.hitbox.x = self.x + self.w 
        self.hitbox.y = self.y 
    elseif self.direction == "left" then 
        self.hitbox.x = (self.x - (self.hitbox.w))
        self.hitbox.y = self.y
    end 
end 

-- Loads all the different Player quads
function Player.getQuad(self)
    self.idleQuad ={}
    self.currentIdleFrame = 1
    self.idleQuad[1] = love.graphics.newQuad(13,6,21,30,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.idleQuad[2] = love.graphics.newQuad(63,6,19,30,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.idleQuad[3] = love.graphics.newQuad(113,6,19,30,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.idleQuad[4] = love.graphics.newQuad(163,6,21,30,self.spritesheet:getWidth(),self.spritesheet:getHeight())

    self.runningQuad = {}
    self.currentRunningFrame = 1
    self.runningQuad[1] = love.graphics.newQuad(66, 45, 29, 28, self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.runningQuad[2] = love.graphics.newQuad(116, 45, 29, 28,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.runningQuad[3] = love.graphics.newQuad(165, 45, 29, 28,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.runningQuad[4] = love.graphics.newQuad(216, 45, 29, 28,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.runningQuad[5] = love.graphics.newQuad(264, 45, 29, 28,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.runningQuad[6] = love.graphics.newQuad(315, 45, 29, 28,self.spritesheet:getWidth(),self.spritesheet:getHeight())

end 

-- Depending on the state of the player sets the quad frames 
function Player.setQuads(self, dt)
    self.timeSinceLastFrame = self.timeSinceLastFrame + dt

    -- Checking if the frame should switch
    if self.timeSinceLastFrame > self.frameDelay then
        self.timeSinceLastFrame = 0
        -- Setting fram for each state
        if self.state == 'idle' then 
            if self.currentIdleFrame >= 4 then --IF its the last frame in the quad reset
                self.currentIdleFrame = 1
            else
                self.currentIdleFrame = self.currentIdleFrame + 1
            end 
        elseif self.state == 'running' then 
            if self.currentRunningFrame >= 6 then 
                self.currentRunningFrame = 1
            else
                self.currentRunningFrame = self.currentRunningFrame + 1
            end 
        end  
    end 
end 

-- Depending on the state of player determines which quad is rendered to screen
function Player.drawSpecificQuad(self)
    if self.state == 'idle' then 
        if self.direction == 'right' then 
            love.graphics.draw(self.spritesheet, self.idleQuad[self.currentIdleFrame], self.x, self.y+7,0, self.scaleX, self.scaleY, 1)
        elseif self.direction == 'left' then 
            love.graphics.draw(self.spritesheet, self.idleQuad[self.currentIdleFrame], self.x+self.w, self.y+7,0, -self.scaleX, self.scaleY, 1)
        end 
    elseif self.state == 'running' then 
        if self.direction == 'right' then 
            love.graphics.draw(self.spritesheet, self.runningQuad[self.currentRunningFrame], self.x, self.y+28,0, self.scaleX, self.scaleY, 1)
        elseif self.direction == 'left' then 
            love.graphics.draw(self.spritesheet, self.runningQuad[self.currentRunningFrame], self.x+self.w, self.y+28,0, -self.scaleX, self.scaleY, 1)
        end 
        
    end 
end 