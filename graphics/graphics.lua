--graphics.lua
--This module will hold functions that will contain easy access functions for graphics
function intializeGraphics()
    WINDOW_WIDTH = love.graphics.getWidth()
    WINDOW_HEIGHT = love.graphics.getHeight()
    love.window.setFullscreen(true,"desktop")
    love.graphics.setDefaultFilter("nearest", "nearest")
    -- WINDOW_WIDTH = love.graphics.getWidth()
    -- WINDOW_HEIGHT = love.graphics.getHeight()
end 




function allGraphics()
    toggleFullScreen()
    getWindowDimensions()
end 



function toggleFullScreen(key)
    isFullScreen = love.window.getFullscreen()
    if gameIsPaused == true then 
        if key == 'f1'then 
            if isFullScreen == true then 
                love.window.setFullscreen(false, "desktop")
            else
                love.window.setFullscreen(true, "desktop")
            end
        elseif key == '3' then 
            love.event.quit()
        end 
    end  
end 

function togglePause(key)
    if key == 'p' then 
        if gameIsPaused == true then 
            gameIsPaused = false
        else
            gameIsPaused = true
        end 
    end 
end 



--Gets the window height and width every update
function getWindowDimensions()
    WINDOW_WIDTH = love.graphics.getWidth()
    WINDOW_HEIGHT = love.graphics.getHeight()
end 


