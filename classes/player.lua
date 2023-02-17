require('miscellaneous/helpers')
Object = require('classes/classic')

Player = Object:extend()

function Player.new(self,x,y)
    -- LUA x and Y by default are top left
    self.spritesheet = love.graphics.newImage("assets/spritesheets/playerSpriteSheet.png")
    self.xTop = x 
    self.yTop = y
    self.w = WINDOW_WIDTH * 0.1
    self.h = WINDOW_HEIGHT * 0.20
    self.x = self.xTop - (self.w/2)
    self.y = self.yTop - (self.h/2)
    self.direction = "right"
    self.state = "idle"

    --Player Health & Healthbar
    self.health = {}
    self.health.maxHealth = 100
    self.health.currentHealth = 100

    self.health.healthBar = {}

    self.health.healthBar.outerBar = {}
    self.health.healthBar.outerBar.x = 0 + (WINDOW_WIDTH * 0.02)
    self.health.healthBar.outerBar.y = 0 + (WINDOW_HEIGHT * 0.02)
    self.health.healthBar.outerBar.w = WINDOW_WIDTH * 0.25
    self.health.healthBar.outerBar.h = WINDOW_HEIGHT * 0.05
    self.health.healthBar.outerBar.color = {1,0,0,1}

    self.health.healthBar.innerBar = {}
    self.health.healthBar.innerBar.startW = self.health.healthBar.outerBar.w / 1.05
    self.health.healthBar.innerBar.currentW = self.health.healthBar.innerBar.startW

    self.health.healthBar.innerBar.h = self.health.healthBar.outerBar.h / 1.5
    self.health.healthBar.innerBar.x = 0
    self.health.healthBar.innerBar.y = self.health.healthBar.outerBar.y
    self.health.healthBar.innerBar.color = {0,1,0,1}

    
    self.tmp0 = (self.health.healthBar.outerBar.x + self.health.healthBar.outerBar.w)
    self.tmp1 = self.tmp0 - (self.health.healthBar.innerBar.x + self.health.healthBar.innerBar.startW)
    self.tmp2 = self.health.healthBar.outerBar.x +(self.tmp1/2)
    self.health.healthBar.innerBar.x = (self.tmp2)

    self.tmp00 = (self.health.healthBar.outerBar.y + self.health.healthBar.outerBar.h)
    self.tmp01 = self.tmp00 - (self.health.healthBar.innerBar.y + self.health.healthBar.innerBar.h)
    self.tmp02 = self.health.healthBar.outerBar.y +(self.tmp01/2)

    self.hitbox = self.generateHitBox(self)
    
    -- QUAD STUFF
    self.getQuad(self)
    self.currentFrame = 1 
    self.scaleX = self.w/21 --Was 21
    self.scaleY = self.h/31
    self.timeSinceLastFrame = 0
    self.frameDelay = 0.10
    self.attackTimer = 0
    self.isAttacking = false

end 

function Player.draw(self)
    self.DrawHealthBar(self)
    setColor(1,0,0,1)
    -- love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
    setColor(1,1,1,1)
    love.graphics.rectangle('line', self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
    -- love.graphics.draw(self.spritesheet, self.idleQuad[self.currentFrame], self.x, self.y+7,0, self.scaleX, self.scaleY, 1)
    self.drawSpecificQuad(self)
       
end 

function Player.update(self, dt)
    self.ConfigDimensions(self)
    self.movement(self,dt)
    self.updateHitBox(self,dt)
    self.setQuads(self,dt)
    self.updateHealthBarSpecs(self,dt)
    -- self.updateHealth(self,dt)
end 



----------------------------------------------------------------
------------------HELPER FUNCTIONS FOR PLAER--------------------
----------------------------------------------------------------
function Player.ConfigDimensions(self)
    self.w = 0.1 * WINDOW_WIDTH
    self.h = 0.20 * WINDOW_HEIGHT
    self.scaleX = self.w/21 --Was 21
    self.scaleY = self.h/31
    self.hitbox.w = self.w * (2/3)
    self.hitbox.h = self.h
end 

-- Draws Health bar
function Player.DrawHealthBar(self)
    setColor(self.health.healthBar.outerBar.color)
    love.graphics.rectangle("fill",self.health.healthBar.outerBar.x,
                            self.health.healthBar.outerBar.y,
                            self.health.healthBar.outerBar.w,
                            self.health.healthBar.outerBar.h)
    setColor(self.health.healthBar.innerBar.color)
    love.graphics.rectangle("fill",
                            self.health.healthBar.innerBar.x,
                            self.health.healthBar.innerBar.y,
                            self.health.healthBar.innerBar.currentW,
                            self.health.healthBar.innerBar.h)

    setColor(1,0,0,1)
    
    love.graphics.print(self.health.currentHealth.."/"..self.health.maxHealth,
                        (self.health.healthBar.innerBar.x + self.health.healthBar.innerBar.currentW)/3,
                        self.health.healthBar.innerBar.y,
                        r,
                        sx,
                        sy,
                        ox,
                        oy)
end 

function Player.updateHealthBarSpecs(self,dt)
    self.health.healthBar.outerBar.w = WINDOW_WIDTH * 0.25
    self.health.healthBar.outerBar.h = WINDOW_HEIGHT * 0.05
    self.health.healthBar.innerBar.startW = self.health.healthBar.outerBar.w / 1.05
    self.updateHealth(self)
    self.health.healthBar.innerBar.h = self.health.healthBar.outerBar.h / 1.25
    
    
    self.health.healthBar.outerBar.x = 0 + (WINDOW_WIDTH * 0.02)
    self.health.healthBar.outerBar.y = 0 + (WINDOW_HEIGHT * 0.02)

    self.tmp0 = (self.health.healthBar.outerBar.x + self.health.healthBar.outerBar.w)
    self.tmp1 = self.tmp0 - (self.health.healthBar.innerBar.x + self.health.healthBar.innerBar.startW)
    self.tmp2 = self.health.healthBar.outerBar.x +(self.tmp1/2)
    self.health.healthBar.innerBar.x = (self.tmp2)

    self.tmp00 = (self.health.healthBar.outerBar.y + self.health.healthBar.outerBar.h)
    self.tmp01 = self.tmp00 - (self.health.healthBar.innerBar.y + self.health.healthBar.innerBar.h)
    self.tmp02 = self.health.healthBar.outerBar.y +(self.tmp01/2) 
    self.health.healthBar.innerBar.y = self.tmp02
end 

function Player.updateHealth(self,dt)
    if love.keyboard.isDown('p') then 
        self.health.currentHealth = self.health.currentHealth - 10
        self.health.healthBar.innerBar.currentW = self.health.healthBar.innerBar.currentW -  (self.health.healthBar.innerBar.startW * .10)

    else
        self.health.healthBar.innerBar.currentW = self.health.healthBar.innerBar.currentW
    end
end 


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
    elseif love.keyboard.isDown("space") and self.attackTimer < 1 then 
        self.state = "attack"
    else 
        self.state = 'idle'
    end 

    if love.keyboard.isDown('space') then 
        self.state = "attack" 
        self.isAttacking = true
        self.attackTimer = self.attackTimer + dt
        if self.attackTimer > .5 then 
            self.isAttacking = false
        end 

    else
        self.attackTimer = 0
        self.isAttacking = false
        self.currentAttack1Frame = 1

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

    self.attackQuad1 = {}
    self.currentAttack1Frame = 1
    self.attackQuad1[1] = love.graphics.newQuad(7,222,32,36,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.attackQuad1[2] = love.graphics.newQuad(58,222,31,36,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.attackQuad1[3] = love.graphics.newQuad(111,222,37,36,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.attackQuad1[4] = love.graphics.newQuad(161,222,33,36,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.attackQuad1[5] = love.graphics.newQuad(211,222,28,36,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.attackQuad1[6] = love.graphics.newQuad(258,222,32,36,self.spritesheet:getWidth(),self.spritesheet:getHeight())
    self.attackQuad1[7] = love.graphics.newQuad(311,222,26,36,self.spritesheet:getWidth(),self.spritesheet:getHeight())

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
        elseif self.state == "attack" then 
            if self.currentAttack1Frame >= 7 then 
                self.currentAttack1Frame = 1
            else
                self.currentAttack1Frame = self.currentAttack1Frame + 1
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
    elseif self.state == "attack" then 
        if self.direction == "right" then 
            love.graphics.draw(self.spritesheet, self.attackQuad1[self.currentAttack1Frame], self.x, self.y - 25 , 0, self.scaleX, self.scaleY, 1)
        elseif self.direction =='left' then 
            love.graphics.draw(self.spritesheet, self.attackQuad1[self.currentAttack1Frame], self.x + self.w, self.y - 25, 0, -self.scaleX, self.scaleY, 1)
        end 
    end 
end 