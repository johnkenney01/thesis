require('miscellaneous/helpers')
Object = require('Love2OOD/classic')
-- require("Love2OOD/physics")
wf = require("Love2OOD/externalLibraries/windfield")

Player = Object:extend()

function Player.new(self,x,y,world)
    -- LUA x and Y by default are top left
    self.__type = "player"
    self.world = world
    
    self.spritesheet = love.graphics.newImage("assets/spritesheets/playerSpriteSheet.png")
    self.xTop = x 
    self.yTop = y
    self.w = WINDOW_WIDTH * 0.05
    self.h = WINDOW_HEIGHT * 0.10
    self.x = self.xTop - (self.w/2)
    self.y = self.yTop - (self.h/2)
    self.direction = "right"
    self.state = "idle"
    self.movingVertical = false
    self.movingHorizontal = false
    self.speed = 5
    self.vx = 0
    self.vy = 0
    self.attackTimer = 0
    
    -- Init Health & Healthbar variables
    self.initHealth(self)
    
    -- Init hit box variables
    self.generateHitBox(self)
    
    -- QUAD STUFF
    self.getQuad(self)
    self.currentFrame = 1 
    self.scaleX = self.w/21 --Was 21
    self.scaleY = self.h/31
    self.timeSinceLastFrame = 0
    self.frameDelay = 0.20
    self.attackTimer = 0
    self.isAttacking = false

    self.getWorldSpecificCollider(self)

    self.attackType = 1
    self.colliding = false
    return self
end 

-- This should only include the actual players stuff not including HUD or Health bar
function Player.draw(self)
    self.drawSpecificQuad(self)  
    love.graphics.rectangle('line',self.x,self.y,self.w,self.h)   
    self.drawHitbox(self)  
    love.graphics.print(tostring(self.colliding), self.x, self.y - 75)
end 


function Player.update(self, dt)
    self.ConfigDimensions(self)
    self.updateCollider(self,dt)
    self.movement(self,dt)
    self.updateHitBox(self,dt)
    self.setQuads(self,dt)
    self.updateHealthBarSpecs(self,dt)
    self.updateHealth(self,dt)
    self.isDead(self,dt)
    self.detectBorders(self,dt)
end 



----------------------------------------------------------------
------------------HELPER FUNCTIONS FOR PLAER--------------------
----------------------------------------------------------------
function Player.drawHUDThings(self)
    self.DrawHealthBar(self)
end 

function Player.ConfigDimensions(self)
    self.w = WINDOW_WIDTH * 0.02
    self.h = WINDOW_HEIGHT * 0.07 -- was 0.20
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
                            self.health.healthBar.innerBar.currentWidth,
                            self.health.healthBar.innerBar.h)

    setColor(1,1,1,1)
    
    
end 

-- Dynamically Resizes the inner health bar based on screen res & current health
function Player.updateHealthBarSpecs(self,dt)
    self.health.healthBar.outerBar.w = WINDOW_WIDTH * 0.25
    self.health.healthBar.outerBar.h = WINDOW_HEIGHT * 0.02
    self.health.healthBar.innerBar.h = self.health.healthBar.outerBar.h * 0.75
    self.health.healthBar.innerBar.maxWidth =  self.health.healthBar.outerBar.w * 0.95
    self.health.healthBar.innerBar.currentWidth = self.updateInnerHealthBarWidth(self,dt)
    self.health.healthBar.innerBar.x = self.health.healthBar.outerBar.x + self.updateInnerHealthBarXPos(self, dt)
    self.health.healthBar.innerBar.y = self.health.healthBar.outerBar.y + self.health.healthBar.outerBar.h / 8

    self.healthFont = love.graphics.newFont(self.health.healthBar.innerBar.maxWidth / self.health.healthBar.innerBar.h)

end 

-- Dynamically places the inner bars x pos center in the outer bar
function Player.updateInnerHealthBarXPos(self, dt)
    local tmp = {}
    -- x point of the end of outer bar
    tmp.maxOuterX = self.health.healthBar.outerBar.x + self.health.healthBar.outerBar.w
    -- distance between max width of inner & outer bar
    tmp.distanceOfBars = tmp.maxOuterX - (self.health.healthBar.innerBar.x + self.health.healthBar.innerBar.maxWidth)
    -- half of distance between bars
    tmp.centralVar = tmp.distanceOfBars * 0.5

    return tmp.centralVar
end 

function Player.updateInnerHealthBarWidth(self,dt)
    -- The percentage of current health to max health 
    self.health.healthBar.innerBar.percentageChange = self.health.currentHealth / self.health.maxHealth
    self.health.healthBar.innerBar.currentWidth = self.health.healthBar.innerBar.percentageChange * self.health.healthBar.innerBar.maxWidth
    return self.health.healthBar.innerBar.currentWidth
end 

-- Handles the health changes
function Player.updateHealth(self,dt)
    if love.keyboard.isDown('l') then 
        self.health.currentHealth = self.health.currentHealth - 10
        if self.health.currentHealth <= 0 then 
            self.health.currentHealth = 0
        end 

    end
end 


-- Generate Hitbox based on init variables
function Player.generateHitBox(self)
    self.hitbox = {}
    self.hitbox.x = self.x + self.w 
    self.hitbox.y = self.y
    self.hitbox.w = self.w * (2/3)
    self.hitbox.h = self.h
    self.hitbox.startH = self.h
    

    return self.hitbox
end 

function Player.drawHitbox(self)
    love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y,self.hitbox.w,self.hitbox.h)
end 

-- Updates Player Movement Vars, called in update
function Player.movement(self,dt)

        --========VERTICAL MOVEMENT=========
        --Up 
    if love.keyboard.isDown('w') then 
        self.movingVertical = true
        self.state = "running"
        self.vy = -1
        
    --Down
    elseif love.keyboard.isDown('s') then 
        self.movingVertical = true
        self.state = "running"
        self.vy = 1
    else
        self.movingVertical = false
        self.vy = 0
    end
    
    --=======HORIZONTAL MOVEMENT========
    --Left
    if love.keyboard.isDown('a') then
        self.movingHorizontal = true
        self.state = "running" 
        self.direction = "left"
        self.vx = -1

    --Right
    elseif love.keyboard.isDown('d') then 
        self.movingHorizontal = true
        self.direction = "right"
        self.state = "running"
        self.vx = 1
    else 
        self.movingHorizontal = false
        self.vx = 0
    end 

    if self.movingHorizontal == false and self.movingVertical == false then 
        self.vx = 0
        self.vy = 0
        self.state = 'idle'
    end 
    

    --=======ATTACKING==========
    if love.keyboard.isDown('space') then 
        self.state = "attack" 
        self.isAttacking = true
        self.vx, self.vy = 0,0
        self.attackTimer = self.attackTimer + dt
        if self.attackTimer > .5 then 
            self.isAttacking = false
        end 

    else
        self.attackTimer = 0
        self.isAttacking = false
        self.currentAttack1Frame = 1
    end
    -- This ensures when the player is moving diagonal the player does not go faster
    self.magnitude = math.sqrt(self.vx^2 + self.vy^2)
    if self.magnitude > 0 then 
        self.vx = self.vx / self.magnitude 
        self.vy = self.vy / self.magnitude 
    end 
    if self.colliding == false then 
        self.x = self.x + (self.vx * self.speed)
        self.y = self.y + (self.vy * self.speed)
    else
        self.x = self.x 
        self.y = self.y
    end 
    
    
end 

-- Love.keyreleased callback
function Player.switchAttack(self,key)
    if gameIsPaused == false then 
        if key == "1" then
            self.attackType = 1 --Standard Attack

        elseif key == "2" then 
            self.attackType = 2 --Long range attack
        end 

    end 
end 


-- Updates the position variables for the hitbox
function Player.updateHitBox(self, dt)
    self.hitbox.x = self.x + self.w 
    self.hitbox.y = self.y
    self.hitbox.w = self.w * (2/3)
    self.hitbox.h = self.h
    if self.direction == "right" then 
        self.hitbox.x = self.x + self.w 
    elseif self.direction == "left" then 
        self.hitbox.x = self.x - self.hitbox.w 
    end
    self.hitbox.y = self.y 
end 

-- Loads all the different Player quads
function Player.getQuad(self)
    self.idleQuad ={}
    self.currentIdleFrame = 1
    self.idleQuad[1] = love.graphics.newQuad(13,6,21,30,self.spritesheet)
    self.idleQuad[2] = love.graphics.newQuad(63,6,19,30,self.spritesheet)
    self.idleQuad[3] = love.graphics.newQuad(113,6,19,30,self.spritesheet)
    self.idleQuad[4] = love.graphics.newQuad(163,6,21,30,self.spritesheet)

    self.runningQuad = {}
    self.currentRunningFrame = 1
    self.runningQuad[1] = love.graphics.newQuad(66, 45, 29, 28, self.spritesheet)
    self.runningQuad[2] = love.graphics.newQuad(116, 45, 29, 28,self.spritesheet)
    self.runningQuad[3] = love.graphics.newQuad(165, 45, 29, 28,self.spritesheet)
    self.runningQuad[4] = love.graphics.newQuad(216, 45, 29, 28,self.spritesheet)
    self.runningQuad[5] = love.graphics.newQuad(264, 45, 29, 28,self.spritesheet)
    self.runningQuad[6] = love.graphics.newQuad(315, 45, 29, 28,self.spritesheet)

    self.attackQuad1 = {}
    self.currentAttack1Frame = 1
    self.attackQuad1[1] = love.graphics.newQuad(7,222,32,36,self.spritesheet)
    self.attackQuad1[2] = love.graphics.newQuad(58,222,31,36,self.spritesheet)
    self.attackQuad1[3] = love.graphics.newQuad(111,222,37,36,self.spritesheet)
    self.attackQuad1[4] = love.graphics.newQuad(161,222,33,36,self.spritesheet)
    self.attackQuad1[5] = love.graphics.newQuad(211,222,28,36,self.spritesheet)
    self.attackQuad1[6] = love.graphics.newQuad(258,222,32,36,self.spritesheet)
    self.attackQuad1[7] = love.graphics.newQuad(311,222,26,36,self.spritesheet)




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
            love.graphics.draw(self.spritesheet, self.idleQuad[self.currentIdleFrame], self.x, self.y,0, self.scaleX, self.scaleY,0)
            
        elseif self.direction == 'left' then 
            love.graphics.draw(self.spritesheet, self.idleQuad[self.currentIdleFrame], self.x, self.y,0, -self.scaleX, self.scaleY, self.w/2)
        end 
    elseif self.state == 'running' then 
        if self.direction == 'right' then 
            love.graphics.draw(self.spritesheet, self.runningQuad[self.currentRunningFrame], self.x, self.y,0, self.scaleX, self.scaleY, 0)
        elseif self.direction == 'left' then 
            love.graphics.draw(self.spritesheet, self.runningQuad[self.currentRunningFrame], self.x, self.y,0, -self.scaleX, self.scaleY, self.w/2)
        end 
    elseif self.state == "attack" then 
        if self.direction == "right" then 
            love.graphics.draw(self.spritesheet, self.attackQuad1[self.currentAttack1Frame],self.x, self.y , 0, self.scaleX, self.scaleY, 0,5)
            
        elseif self.direction =='left' then 
            love.graphics.draw(self.spritesheet, self.attackQuad1[self.currentAttack1Frame], self.x, self.y, 0, -self.scaleX, self.scaleY, self.w/2, 5)
        end 
    end 
end 




function Player.getWorldSpecificCollider(self)

    -- NEW COLLIDER WITHOUT PHYSICS
    self.body = {}
    self.body.x = self.x
    self.body.y = self.y 
    self.body.w = self.w 
    self.body.h = self.h 
    self.body.startW = self.w
     
end 




function Player.updateCollider(self,dt)
    -- NEW COLLIDER WITHOUT PHYSICS
    self.body.x = self.x
    self.body.y = self.y 
    self.body.w = self.w 
    self.body.h = self.h 
    
end 


function Player.isDead(self, dt)
    -- Chekcing to see if the player's health is 0
    if self.health.currentHealth == 0 then 
        self.isAlive = False
        gameState = 1
        love.load()
    end 

end


function Player.initHealth(self)
    --Player Health & Healthbar
    self.health = {}
    self.health.maxHealth = 100
    self.health.currentHealth = 100
    self.isAlive = true
    self.isBeingAttacked = false
    -- All HealthBar Vars
    self.health.healthBar = {}
    -- Outer Health Bar
    self.health.healthBar.outerBar = {}
    self.health.healthBar.outerBar.x = 0 + (WINDOW_WIDTH * 0.02)
    self.health.healthBar.outerBar.y = 0 + (WINDOW_HEIGHT * 0.02)
    self.health.healthBar.outerBar.w = WINDOW_WIDTH * 0.35
    self.health.healthBar.outerBar.h = WINDOW_HEIGHT * 0.05
    self.health.healthBar.outerBar.color = {1,0,0,1} -- Red
    -- Inner Health Bar
    self.health.healthBar.innerBar = {}
    self.health.healthBar.innerBar.maxWidth = self.health.healthBar.outerBar.w * 0.75
    self.health.healthBar.innerBar.currentWidth = self.health.healthBar.innerBar.maxWidth
    self.health.healthBar.innerBar.h = self.health.healthBar.outerBar.h * 0.75
    self.health.healthBar.innerBar.x = self.health.healthBar.outerBar.x
    self.health.healthBar.innerBar.y = self.health.healthBar.outerBar.y
    self.health.healthBar.innerBar.color = {0,1,0,1} -- Green
end 


function Player.longRangeAttack(self)
    if self.attackType == 2 then 
        
    end 
end 



function Player.detectBorders(self,dt)
    
end 

function Player.isAttacked(self)
    self.health.currentHealth = self.health.currentHealth - 10 
    if self.health.currentHealth <= 0 then 
        self.health.currentHealth = 0
    end 
end 