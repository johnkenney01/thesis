require('miscellaneous/helpers')
Object = require('classes/classic')

Button = Object:extend()

function Button.new(self, text, action ,windowWDivide, windowHDivide , w, h, fontSize)
    -- x and y on rectangles are top left, we will reassign to center down below.
    self.windowWDivide = windowWDivide -- Where along the x axis you want the text
    self.windowHDivide = windowHDivide -- Where along the y axis you want the text
    self.topx = WINDOW_WIDTH/windowWDivide or 0
    self.topy = WINDOW_HEIGHT/windowHDivide or 0
    self.text = text or "button"
    self.font = love.graphics.newFont('assets/fonts/heycomic.ttf', fontSize)

    self.fontOffset = 20
    self.w = self.font:getWidth(self.text) + self.fontOffset
    self.h = self.font:getHeight(self.text)
    self.round = 10
    self.x = self.topx - self.w/2
    self.y = self.topy - self.h/2
    self.color = {0.73, 0.32, 0.32}
    self.action = action or nil
    
end 

function Button.draw(self)
    love.graphics.setFont(self.font)
    setColor(self.color)
    self.makeButtonRectangle(self)
    setColor(1,1,1,1)
    self.printTextToAlignWithButton(self)

end 

function Button.update(self, dt, functionToCall)
    -- If we change to full screen or out we need to update the x and y
    Button.checkIfHover(self, functionToCall)
    self.topx = WINDOW_WIDTH/self.windowWDivide or 0
    self.topy = WINDOW_HEIGHT/self.windowHDivide or 0
    self.x = self.topx - self.w/2
    self.y = self.topy - self.h/2
    
end 


----HELPER FUNCTIONS FOR CLASS
function Button.makeButtonRectangle(self)
    return love.graphics.rectangle('fill', self.x, self.y, self.w , self.h, self.round)
end 

function Button.printTextToAlignWithButton(self)
    love.graphics.print(self.text,self.x + self.fontOffset/2,self.y,r,sx,sy,ox,oy)
end 
  

function Button.checkIfHover(self, functionToCall)
    mouse_x, mouse_y = love.mouse.getPosition()
    if mouse_x > self.x and mouse_x < self.x + self.w  and mouse_y > self.y and mouse_y < self.y + self.h  then 
        function love.mousepressed()
            functionToCall()
        end 
        self.color = {1,.5,0,1}
    else
        self.color = {0.73, 0.32, 0.32}
    end 
end 


