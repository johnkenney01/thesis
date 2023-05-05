require('miscellaneous/helpers')
Object = require('Love2OOD/classic')

Enemy = Object:extend()

function Enemy.new(self,x,y,spritesheet,world, scale)
    self.__type = "enemy"
    self.spritesheet = love.graphics.newImage(spritesheet)
    self.world = world 

    self.x = x 
    self.y = y 
    self.w = 32
    self.h = 64
    self.timeSinceLastFrame = 0
    self.frameDelay = 0.20
    self.attackTimer = 0
    self.isAttacking = false 
    self.inRangeToAttack = false
    self.inRangeToBeAttacked = false
    self.getQuads(self)
    self.direction = "left"
    self.state = "idle"
    self.speed = 2.5
    self.vx = 0
    self.vy = 0 
    self.scale = scale
    -- Health and Health Bar
    self.initHealthProp(self)
    -- Collider
    self.getWorldSpecificCollider(self)
    -- Gen Hitbox 
    self.initHitboxProp(self)
    -- Quad 
    self.quadNum = 1
    self.time = 0
    -- Detection Circle
    self.initDetectionCirlce(self)
end 

function Enemy.draw(self)
    love.graphics.setColor(1,0,0,1)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line', self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
    love.graphics.rectangle('line', self.body.x, self.body.y, self.body.w, self.body.h)
    self.DrawHealthBar(self)
    self.drawSpecificQuad(self)
    -- love.graphics.draw(self.spritesheet, self.quads[self.quadNum], self.x ,self.y,0,2)
    self.drawDetectionCircle(self)
    love.graphics.print(tostring(self.playerInCircle), self.x - 200, self.y)

end 

function Enemy.update(self,dt)
    self.time = self.time + dt
    self.updateCollider(self,dt)
    self.updateHealthBarSpecs(self,dt)
    self.updateHealth(self,dt)
    self.updateHitBox(self)
    self.setQuads(self,dt)
    self.updateDetectCircle(self,dt)
    self.checkDetectionCircle(self)
    self.movement(self,dt)
    self.checkAttackRange(self,dt)
    self.attackPlayer(self, dt)
    self.gettingAttacked(self,dt)
    self.getAttacked(self,dt)
    self.isDead(self)
end 

-- HELPER FUNCTIONS

--=========HEALTH RELATED FUNCTIONS====================
function Enemy.initHealthProp(self)
    -- Init enemy healh properties 
    -- Incldes Health stats & Health Bar

    self.health = {}
    self.health.maxHealth = 100
    self.health.currentHealth = 100
    self.isAlive = true
    self.isBeingAttacked = false
    -- Health bar will be above enemy head 
    self.health.healthBar = {}
    self.health.healthBar.outerBar = {}
    self.health.healthBar.outerBar.x = self.x
    self.health.healthBar.outerBar.y = self.y - 10
    self.health.healthBar.outerBar.w = self.w
    self.health.healthBar.outerBar.h = self.h * .10
    self.health.healthBar.outerBar.color = {1,0,0,1} -- Red
    -- Inner Health Bar
    self.health.healthBar.innerBar = {}
    self.health.healthBar.innerBar.maxWidth = self.health.healthBar.outerBar.w * 0.9
    self.health.healthBar.innerBar.currentWidth = self.health.healthBar.innerBar.maxWidth
    self.health.healthBar.innerBar.h = self.health.healthBar.outerBar.h * 0.75
    self.health.healthBar.innerBar.x = self.health.healthBar.outerBar.x + (self.health.healthBar.outerBar.w * .05)
    self.health.healthBar.innerBar.y = self.health.healthBar.outerBar.y
    self.health.healthBar.innerBar.color = {0,1,0,1} -- Green
end 

function Enemy.DrawHealthBar(self)
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

function Enemy.updateHealthBarSpecs(self,dt)
    self.health.healthBar.outerBar.w = self.w
    self.health.healthBar.outerBar.h = self.h * .10
    self.health.healthBar.outerBar.x = self.x - self.w/2
    self.health.healthBar.outerBar.y = self.y - self.h - 10
    self.health.healthBar.innerBar.h = self.health.healthBar.outerBar.h * 0.75
    self.health.healthBar.innerBar.maxWidth =  self.health.healthBar.outerBar.w * 0.95
    self.health.healthBar.innerBar.currentWidth = self.updateInnerHealthBarWidth(self,dt)
    self.health.healthBar.innerBar.x = self.health.healthBar.outerBar.x + self.updateInnerHealthBarXPos(self, dt)
    self.health.healthBar.innerBar.y = self.health.healthBar.outerBar.y + self.health.healthBar.outerBar.h / 8
end 

function Enemy.updateInnerHealthBarXPos(self, dt)
    local tmp = {}
    -- x point of the end of outer bar
    tmp.maxOuterX = self.health.healthBar.outerBar.x + self.health.healthBar.outerBar.w
    -- distance between max width of inner & outer bar
    tmp.distanceOfBars = tmp.maxOuterX - (self.health.healthBar.innerBar.x + self.health.healthBar.innerBar.maxWidth)
    -- half of distance between bars
    tmp.centralVar = tmp.distanceOfBars * 0.5

    return tmp.centralVar
end 

function Enemy.updateInnerHealthBarWidth(self,dt)
    -- The percentage of current health to max health 
    self.health.healthBar.innerBar.percentageChange = self.health.currentHealth / self.health.maxHealth
    self.health.healthBar.innerBar.currentWidth = self.health.healthBar.innerBar.percentageChange * self.health.healthBar.innerBar.maxWidth
    return self.health.healthBar.innerBar.currentWidth
end 

function Enemy.updateHealth(self,dt)
    if love.keyboard.isDown('k') then 
        self.health.currentHealth = self.health.currentHealth - 10
        if self.health.currentHealth <= 0 then 
            self.health.currentHealth = 0
        end 

    end
end 

--=============HITBOX RELATED FUNCTIONS==============
function Enemy.initHitboxProp(self)
    self.hitbox = {}
    self.hitbox.x = self.x + self.w *self.scale 
    self.hitbox.y = self.y 
    self.hitbox.w = self.w * (2/3)
    self.hitbox.h = self.h * self.scale
end 

function Enemy.updateHitBox(self,dt)
    if self.direction == "right" then 
        self.hitbox.x = self.x + self.w 
        self.hitbox.y = self.y
        self.hitbox.w = self.w * (2/3)
        self.hitbox.h = self.h * self.scale
    elseif self.direction == "left" then 
        self.hitbox.x = self.x -  self.hitbox.w
        self.hitbox.y = self.y 
        self.hitbox.w = self.w * (2/3)
        self.hitbox.h = self.h * self.scale
    end 
end 

--==========COLLIDER RELATED FUNCTIONS============
function Enemy.getWorldSpecificCollider(self)

    -- COLLIDER WITH RECTANGLES
    self.body = {}
    self.body.x = self.x 
    self.body.y = self.y 
    self.body.w = self.w 
    self.body.h = self.h 
    self.body.startW = self.w
end 

function Enemy.updateCollider(self, dt)
    -- NEW COLLIDER STUFF
    self.body.x = self.x 
    self.body.y = self.y 
    self.body.w = self.w 
    self.body.h = self.h * self.scale
end 

--==============QUADS===============
function Enemy.getQuads(self)
    self.quads = {}
    local w = 32
    local h = 64
    
    local columns = 30
    local rows = 1 
    for row = 0, rows - 1  do
        for column = 0, columns - 1 do
            local x = column * w 
            local y = row * h 
            self.quad = love.graphics.newQuad(x,y, self.w,self.h,self.spritesheet:getDimensions())
            table.insert(self.quads, self.quad)
        end 
    end 

    self.currentFrame = 1
    self.attackQuad = {self.quads[1],self.quads[2],self.quads[3],self.quads[4],self.quads[5],self.quads[6],self.quads[7]}
    self.maxAttackQuads = #self.attackQuad 

    self.idleQuad = {self.quads[8],self.quads[9],self.quads[10],self.quads[11],self.quads[12],self.quads[13]}
    self.maxIdleQuad = #self.idleQuad 

    self.runningQuad = {self.quads[14],self.quads[15],self.quads[16],self.quads[17],self.quads[18],self.quads[19],self.quads[20], self.quads[21]}
    self.maxRunningQuad = #self.runningQuad 

    self.dyingQuad = {self.quads[22],self.quads[23],self.quads[24],self.quads[25],self.quads[26]}
    self.maxDyingQuad = #self.dyingQuad 

    self.hitQuad = {self.quads[28],self.quads[29],self.quads[30]}
    self.maxHitQuad = #self.hitQuad 

end 

function Enemy.setQuads(self,dt)
    
    self.timeSinceLastFrame = self.timeSinceLastFrame + dt

    if self.timeSinceLastFrame > self.frameDelay then
        self.timeSinceLastFrame = 0
        if self.state == "idle" then 
            if self.currentFrame >= self.maxIdleQuad then 
                self.currentFrame = 1
            else
                self.currentFrame = self.currentFrame + 1
            end 
        end 

    end 


end 

function Enemy.drawSpecificQuad(self)
    if self.state == "idle" then 
        if self.direction == "right" then 
            love.graphics.print(self.direction, 100,100)
            love.graphics.draw(self.spritesheet, self.idleQuad[self.currentFrame], self.x - self.w/2, self.y, 0, self.scale,self.scale,0)
        elseif self.direction == "left" then
            love.graphics.draw(self.spritesheet, self.idleQuad[self.currentFrame], self.x + self.w *1.5, self.y, 0, -self.scale,self.scale,0)
        end 
    elseif self.state == "running" then 
        if self.direction == "left" then 
            love.graphics.draw(self.spritesheet, self.runningQuad[self.currentFrame], self.x + self.w *1.5, self.y, 0, -self.scale,self.scale,0)
        elseif self.direction == "right" then 
            love.graphics.draw(self.spritesheet, self.runningQuad[self.currentFrame], self.x, self.y, 0, self.scale,self.scale,0)
        end 
    elseif self.state == 'attacking' then 
        if self.direction == "left" then 
            love.graphics.draw(self.spritesheet, self.attackQuad[self.currentFrame], self.x+ self.w *1.5, self.y, 0, -self.scale,self.scale,0)
        elseif self.direction == 'right' then 
            love.graphics.draw(self.spritesheet, self.attackQuad[self.currentFrame], self.x, self.y, 0, self.scale,self.scale,0)
        end 
    elseif self.state == "hit" then 
        if self.direction == "left" then 
            love.graphics.draw(self.spritesheet, self.hitQuad[self.currentFrame], self.x, self.y, 0, self.scale,self.scale,0)
        elseif self.direction == 'right' then 
            love.graphics.draw(self.spritesheet, self.hitQuad[self.currentFrame], self.x, self.y, 0, self.scale,self.scale,0)
        end 
    end 

end 
--============MOVEMENT==============
function Enemy.movement(self,dt)
    
    
    self.detectCircle.distanceToPlayerX = self.world.player.x - self.x
    self.detectCircle.distanceToPlayerY = self.world.player.y - self.y
    if self.playerInCircle then 
        self.state = "running"
        if self.detectCircle.distanceToPlayerX < 0 then 
            self.vx =  -1
            self.direction = "left"
        elseif self.detectCircle.distanceToPlayerX > 0 then 
            self.vx = 1
            self.direction = "right"
        else 
            self.vx = 0
        end 

        if self.detectCircle.distanceToPlayerY < 0 then 
            
            self.vy = -1
        elseif self.detectCircle.distanceToPlayerY > 1 then
             
            self.vy = 1
        else
            self.vy = 0
        end 
    else
        self.vx = 0
        self.vy = 0
        self.state = "idle"
    end 
    -- This ensures when the enemy is moving diagonal the enemy does not go faster than the desired speed
    self.magnitude = math.sqrt(self.vx^2 + self.vy^2)
    if self.magnitude > 0 then 
        self.vx = self.vx / self.magnitude 
        self.vy = self.vy / self.magnitude 
    end
    
    if self.inRangeToAttack == true then 
        self.vx = 0
        self.vy = 0
    end 

    self.x = self.x + (self.vx * self.speed)
    self.y = self.y + (self.vy * self.speed)

    
end 

--=======DETECTION CIRLCE===========
function Enemy.initDetectionCirlce(self)
    self.detectCircle = {}
    self.detectCircle.x = self.x + self.w/2
    self.detectCircle.y = self.y + self.h/2
    self.detectCircle.radius = self.w * 6
    self.detectCircle.distanceToPlayer = nil
    self.playerInCircle = false
    self.detectCircle.distanceToPlayerX = 0
    self.detectCircle.distanceToPlayerY = 0
    self.inRangeOfPlayer = false
end 

function Enemy.drawDetectionCircle(self)
    love.graphics.circle("line", self.detectCircle.x, self.detectCircle.y, self.detectCircle.radius)
end 

function Enemy.updateDetectCircle(self,dt)
    self.detectCircle.x = self.x + self.w/2
    self.detectCircle.y = self.y + ((self.h/2) * self.scale)
end 

function Enemy.checkDetectionCircle(self)
    self.detectCircle.distanceToPlayer = math.sqrt((self.world.player.x - self.detectCircle.x)^2 + (self.world.player.y - self.detectCircle.y)^2)
    if self.detectCircle.distanceToPlayer <= self.detectCircle.radius then 
        self.playerInCircle = true
        
    else
        self.playerInCircle = false
    end 
end 

--======ENEMY IN RANGE OF ATTACK=====
function Enemy.checkAttackRange(self,dt)
    if self.playerInCircle == true then 
        -- Case 1: the player is on the left side of the enemy 
        if (self.hitbox.x < (self.world.player.body.x + self.world.player.body.w)  and 
            self.hitbox.x > self.world.player.x) and 
            self.detectCircle.distanceToPlayerY > -30 and  self.detectCircle.distanceToPlayerY < 30 then 
                self.inRangeToAttack = true
                self.state = 'attacking'
        -- Case 2: the player is on the right side of the enemy
        elseif ((self.hitbox.x + self.hitbox.w > self.world.player.x) and self.hitbox.x < self.world.player.x) and self.detectCircle.distanceToPlayerY > -30 and  self.detectCircle.distanceToPlayerY < 30 then
            self.inRangeToAttack = true
            self.state = 'attacking'
        else 
            self.inRangeToAttack = false
            self.state = 'running'
        end 
    end 
end 


function Enemy.attackPlayer(self,dt)
    
    if self.state == "attacking" then 
        self.attackTimer = self.attackTimer + dt
        if self.attackTimer > .5 then 
            self.world.player.isAttacked(self.world.player)
            self.attackTimer = 0
        end 
    end 
end 

function Enemy.gettingAttacked(self, dt)
    local player = self.world.player
    -- case 1: Player is on the left 
    if ((self.world.player.hitbox.x + self.world.player.hitbox.w) > self.x) and (self.world.player.hitbox.x < self.x) and self.detectCircle.distanceToPlayerY < 30 and self.detectCircle.distanceToPlayerY > -30 then 
        self.inRangeToBeAttacked = true
    -- case 2: player is on the right
    elseif (self.world.player.hitbox.x < (self.x + self.w) and (self.world.player.hitbox.x + self.world.player.hitbox.w) > self.x + self.w) and self.detectCircle.distanceToPlayerY < 30 and self.detectCircle.distanceToPlayerY > -30 then
        self.inRangeToBeAttacked = true 
    else
        self.inRangeToBeAttacked = false
    end 
end 

function Enemy.getAttacked(self,dt)
    if self.world.player.state == 'attack'  and self.inRangeToBeAttacked == true then 
        self.attackTimer = self.attackTimer + dt
        if self.attackTimer > .50 then 
            self.health.currentHealth = self.health.currentHealth - 15
            self.attackTimer = 0
            
        end 
    end 
end 

function Enemy.isDead(self)
    if self.health.currentHealth <= 0 then 
        self.health.currentHealth = 0 
        self.x = -100000000
    end 
end 