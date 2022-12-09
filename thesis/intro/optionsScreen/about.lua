require('miscellaneous/helpers')
Object = require('classes/classic')
local about = {}
--gameState = 4

function about.load()
    msg = 'This game was created by John Kenney, a student at Endicott College. Unofficial creator and founder of Kung_Fu Studios. Forge On is a single player RPG following the story of Helion the great warrior who will attempt to liberate Echo Rift from the clutches of the Evil Dr. Yenyth, leader of the mighty Yenyth Empire. Do you have what it takes to help Helion on his quest for justice ? '
    msg_color = {1,1,0.3,1}
    aboutHeader = Header(msg, 0,WINDOW_HEIGHT/3,1,1,50, msg_color)
    backButton = Button('Back', 'intro', 2, 1.3, 300,50,50 )
    backgroundAbout = createBackGroundImage('assets/intro.jpg')
end 

function about.draw()
    love.graphics.draw(backgroundAbout.image, 0,0,0,backgroundAbout.scaleX, backgroundAbout.scaleY)
    aboutHeader.draw(aboutHeader)
    backButton.draw(backButton)
end 

function about.update(dt)
    setImageFullScreen(backgroundAbout)
    aboutHeader.update(aboutHeader, dt)
    backButton.update(backButton,dt, backButton_functionToCall)
end 


function backButton_functionToCall()
    gameState = 2
end 

return about