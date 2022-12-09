function setColor(n1,n2,n3,n4)
    n4 = n4 or 1
    love.graphics.setColor(n1,n2,n3,n4)
end 

function setFont(sizeOfFont, font)
    tempFont = love.graphics.newFont('assets/fonts/heycomic.ttf', sizeOfFont)
    love.graphics.setFont(tempFont)
    return tempFont
end 

function newImage(filename)
    newImage = love.graphics.newImage(filename)
    return newImage
end 

function setImageFullScreen(imageTable)
    imageTable.w = imageTable.image:getWidth()
    imageTable.h = imageTable.image:getHeight()
    imageTable.scaleX = WINDOW_WIDTH/imageTable.w
    imageTable.scaleY = WINDOW_HEIGHT/imageTable.h
end 

function makeButtonRectangle(table)
    return love.graphics.rectangle('fill', table.x, table.y, table.w, table.h, table.round)
end 


function createBackGroundImage(imageFilePath)
    imageTable = {}
    imageTable.image = love.graphics.newImage(imageFilePath)
    imageTable.w = imageTable.image:getWidth()
    imageTable.h = imageTable.image:getHeight()
    imageTable.scaleX = WINDOW_WIDTH/imageTable.w
    imageTable.scaleY = WINDOW_HEIGHT/imageTable.h

    return imageTable
end 


