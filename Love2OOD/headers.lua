require('miscellaneous/helpers')
Object = require('Love2OOD/classic')

Header = Object:extend()

function Header.new(self, text, x ,y, windowWDivide, windowHDivide, fontSize, color, bg, table)
    self.text = text
    self.windowHDivide = windowHDivide
    self.windowWDivide = windowWDivide
    self.font = love.graphics.newFont(fontSize)
    -- 'assets/fonts/heycomic.ttf',
    self.x = x 
    self.y = y
    self.color = color or {1,1,1,1}
    self.offset = WINDOW_WIDTH/2 + 40
    self.bg = bg or false
    self.tableToAddTo = table
    self.addToLevelTable(self)
end 

function Header.draw(self)
    love.graphics.setFont(self.font)
    if self.bg then 
        self.w = self.font:getWidth(self.text)
        self.h = self.font:getHeight(self.text)
        love.graphics.setColor(0.2,0.7,1,0.75)
        love.graphics.rectangle('fill',self.x + self.w /2,self.y,self.w,self.h, 40)
    end 
    love.graphics.setColor(self.color)
    love.graphics.printf(self.text, self.x,self.y,WINDOW_WIDTH/self.windowWDivide,'center')
end 
function Header.update(self, header)
    self.font = love.graphics.newFont(WINDOW_WIDTH*.15)
end 

function Header.addToLevelTable(self)
    table.insert(self.tableToAddTo, self)
end 