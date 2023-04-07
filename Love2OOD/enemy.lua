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
    self.getQuads(self)
    self.direction = "left"
    self.state = "idle"
    self.speed = 175 
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
    self.DrawHealthBar(self)
    love.graphics.draw(self.spritesheet, self.quads[self.quadNum], self.collider:getX() - (self.w) ,self.collider:getY() - (self.h),0,2)
    self.drawDetectionCircle(self)
    love.graphics.print(tostring(self.inRangeOfPlayer), self.x, self.y)

end 

function Enemy.update(self,dt)
    self.time = self.time + dt
    self.updateCollider(self,dt)
    self.updateHealthBarSpecs(self,dt)
    self.updateHealth(self,dt)
    self.updateHitBox(self)
    self.updateDetectCircle(self,dt)
    self.checkDetectionCircle(self)
    
    if self.time > 0.2 and self.quadNum < 30  then 
        self.quadNum = self.quadNum + 1
        self.time = 0
    elseif self.time > 0.2 and self.quadNum >= 30 then
        self.quadNum = 1
        self.time = 0 
    end
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
        self.hitbox.y = self.collider:getY() - self.h
        self.hitbox.w = self.w * (2/3)
        self.hitbox.h = self.h * self.scale
    elseif self.direction == "left" then 
        self.hitbox.x = self.x - self.w - self.hitbox.w
        self.hitbox.y = self.collider:getY() - self.h
        self.hitbox.w = self.w * (2/3)
        self.hitbox.h = self.h * self.scale
    end 
end 

--==========COLLIDER RELATED FUNCTIONS============
function Enemy.getWorldSpecificCollider(self)
    self.colliderWidthStart = 0
    self.collider = self.world:newBSGRectangleCollider(self.x, self.y, self.w*self.scale, self.h*self.scale,0)
    self.collider:setFixedRotation(true)
    self.colliderWidthStart = self.w
end 

function Enemy.updateCollider(self, dt)
    if self.colliderWidthStart == self.w then
        self.tmp = 0
        self.x = self.collider:getX()
        self.y = self.collider:getY()
    elseif self.colliderWidthStart ~= self.w then 
        self.collider:destroy()
        self.collider = self.world:newBSGRectangleCollider(self.x + self.w, self.y + self.h, self.w*2, self.h*2,0)
        self.collider:setFixedRotation(true)
        self.colliderWidthStart = self.w
    end 
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
            print("YEA")
            local x = column * w 
            local y = row * h 
            self.quad = love.graphics.newQuad(x,y, self.w,self.h,self.spritesheet:getDimensions())
            table.insert(self.quads, self.quad)
        end 
    end 

    self.idleQuad = {}

    self.attackQuad = {}

    self.runningQuad = {}

    self.hitQuad = {}

    self.dyingQuad = {}

end 


--============MOVEMENT==============
function Enemy.movement(self,dt)
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end 

--=======DETECTION CIRLCE===========
function Enemy.initDetectionCirlce(self)
    self.detectCircle = {}
    self.detectCircle.x = self.collider:getX()
    self.detectCircle.y = self.collider:getY()
    self.detectCircle.radius = self.w * 6
    self.detectCircle.distanceToPlayer = nil
    self.inRangeOfPlayer = false
end 

function Enemy.drawDetectionCircle(self)
    love.graphics.circle("line", self.detectCircle.x, self.detectCircle.y, self.detectCircle.radius)
end 

function Enemy.updateDetectCircle(self,dt)
    self.detectCircle.x = self.collider:getX()
    self.detectCircle.y = self.collider:getY()
end 

function Enemy.checkDetectionCircle(self)
    self.detectCircle.distanceToPlayer = math.sqrt((self.world.player.x - self.detectCircle.x)^2 + (self.world.player.y - self.detectCircle.y)^2)
    if self.detectCircle.distanceToPlayer <= self.detectCircle.radius then 
        self.inRangeOfPlayer = true
        
    else
        self.inRangeOfPlayer = false
    end 
end 