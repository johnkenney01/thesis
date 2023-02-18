require('miscellaneous/helpers')
Object = require('classes/classic')

Button = Object:extend()

function Button.new(self, text, action ,windowWDivide, windowHDivide ,fontSizePercentage, functionToCall, table)
    self.__type = "button"
    -- x and y on rectangles are top left, we will reassign to center down below.
    self.windowWDivide = windowWDivide -- Where along the x axis you want the text
    self.windowHDivide = windowHDivide -- Where along the y axis you want the text
    self.topx = WINDOW_WIDTH/windowWDivide or love.event.quit()
    self.topy = WINDOW_HEIGHT/windowHDivide or love.event.quit()
    self.text = text or "button"
    self.fontSizePercentage = fontSizePercentage
    self.fontSize = (WINDOW_WIDTH * self.fontSizePercentage)
    
    self.font = love.graphics.newFont("assets/fonts/heycomic.ttf", self.fontSize)

    self.fontOffset = 20
    self.w = self.font:getWidth(self.text) + self.fontOffset
    self.h = self.font:getHeight(self.text)
    self.round = 10
    self.x = self.topx - self.w/2
    self.y = self.topy - 10
    self.color = {0.73, 0.32, 0.32}
    self.action = action or nil
    self.functionToCall = functionToCall
    self.tableToAddTo = table
    self.addToLevelTable(self)
    
end 

function Button.draw(self)
    love.graphics.setFont(self.font, self.fontSize)
    setColor(self.color)
    self.makeButtonRectangle(self)
    setColor(1,1,1,1)
    self.printTextToAlignWithButton(self)

end 

function Button.update(self, dt)
    -- If we change to full screen or out we need to update the x and y
    Button.checkIfHover(self)
    self.ConfigDimensions(self)
    self.topx = WINDOW_WIDTH/self.windowWDivide or 0
    self.topy = WINDOW_HEIGHT/self.windowHDivide or 0
    self.x = self.topx - self.w/2
    self.y = self.topy - 10
    
end 


----HELPER FUNCTIONS FOR CLASS
function Button.makeButtonRectangle(self)
    return love.graphics.rectangle('fill', self.x, self.y, self.w , self.h, self.round)
end 

function Button.printTextToAlignWithButton(self)
    love.graphics.print(self.text,self.x + self.fontOffset/2,self.y,r,sx,sy,ox,oy)
end 
  

function Button.checkIfHover(self)
    mouse_x, mouse_y = love.mouse.getPosition()
    if mouse_x > self.x and mouse_x < self.x + self.w  and mouse_y > self.y and mouse_y < self.y + self.h  then 
        function love.mousepressed()
            self.functionToCall()
        end 
        self.color = {1,.5,0,1}
    else
        self.color = {0.73, 0.32, 0.32}
    end 
end 

function Button.ConfigDimensions(self)
    self.fontSize = (WINDOW_WIDTH * self.fontSizePercentage)
    self.font = love.graphics.newFont( self.fontSize)
    -- "assets/fonts/heycomic.ttf",
    love.graphics.setFont(self.font, self.fontSize)
    self.w = self.font:getWidth(self.text) + self.fontOffset
    self.h = self.font:getHeight(self.text)
    print(self.w)
end 


function Button.addToLevelTable(self)
    table.insert(self.tableToAddTo, self)        
end 

