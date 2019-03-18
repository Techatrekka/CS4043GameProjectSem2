-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here
--local background = display.newImageRect( "Background.png", 1280, 720 )
--background.x = display.contentCenterX
--background.y = display.contentCenterY

-- Set Variables
_W = display.contentWidth; -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen
scrollSpeed = 2; -- Set Scroll Speed of background

-- Add First Background
local bg1 = display.newImageRect("background-with-clouds.jpg", 1000, 1080)
bg1.x = _W*0.5; bg1.y = _H/2;

-- Add Second Background
local bg2 = display.newImageRect("background-with-clouds.jpg", 1000, 1080)
bg2.x = bg1.x + 1000; bg2.y =_H/2;

-- Add Third Background
local bg3 = display.newImageRect("background-with-clouds.jpg", 1000, 1080)
bg3.x = bg2.x + 1000; bg3.y = _H/2;

local function move(event)
-- move backgrounds to the left by scrollSpeed, default is 2
bg1.x = bg1.x - scrollSpeed
bg2.x = bg2.x - scrollSpeed
bg3.x = bg3.x - scrollSpeed

-- Set up listeners so when backgrounds hits a certain point off the screen,
-- move the background to the right off screen

  if (bg1.x + bg1.contentHeight) > 7040 then
    bg1:translate( 1960, 0 )
  end
  if (bg2.x + bg2.contentHeight) > 7040 then
    bg2:translate( 1960, 0 )
  end
  if (bg3.x + bg3.contentHeight) > 7040 then
    bg3:translate( 1960, 0 )
  end
end

-- Create a runtime event to move backgrounds
Runtime:addEventListener( "enterFrame", move )

local platform = display.newImageRect( "Platform.png", 150, 10 )
platform.x = display.contentCenterX
platform.y = display.contentHeight-50

local platform2 = display.newImageRect( "Platform.png", 100, 10 )
platform2.x = display.contentCenterX+300
platform2.y = display.contentHeight-100

local platform3 = display.newImageRect( "Platform.png", 100, 10 )
platform3.x = display.contentCenterX-200
platform3.y = display.contentHeight-100

local platform4 = display.newImageRect( "Platform.png", 100, 10 )
platform4.x = display.contentCenterX+450
platform4.y = display.contentHeight-100

local Sprite = display.newImageRect ("Sprite1.png", 30, 100)
Sprite.x = display.contentCenterX
Sprite.y = display.contentHeight-200

local physics = require( "physics" )
physics.start()
physics.setGravity(0, 50)

physics.addBody( platform, "static" )
physics.addBody( platform2, "static" )
physics.addBody( platform3, "static" )
physics.addBody( platform4, "static" )

physics.addBody( Sprite, "dynamic", {friction = 1.0} )

Sprite.isFixedRotation = true

local function walkPerson(event)
  if (event.keyName == 'd' or event.keyName == 'right' ) then
    while (event.phase == 'down')
    do
    Sprite:setLinearVelocity(200, 0)
    return true
    end
  end
  if (event.keyName == 'a' or event.keyName == 'left' and event.phase == 'down') then
    Sprite:setLinearVelocity(-200, 0)
    return true
  end
  if(event.keyName == 'space' or event.keyName == 'up' or event.keyName == 'w') then
    Sprite:applyLinearImpulse(0, -.25)
  end
end

Runtime:addEventListener( "key", walkPerson )


local lives = 3
local score = 0
local livesText
local scoreText

-- Display lives and score
livesText = display.newText("Lives: " .. lives, 200, 100, native.systemFont, 36 )
scoreText = display.newText("Score: " .. score, 400, 100, native.systemFont, 36 )

-- local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
-- end

--Create global screen boundaries
local topWall = display.newRect( 500, -2, 2000, 5 )
local leftWall = display.newRect(83, 300, 2, display.contentHeight + 250)
local rightWall = display.newRect (display.contentWidth - 80, 300, 2, display.contentHeight + 250)
local bottomWall = display.newRect(500, display.contentHeight, 2000, 5)

physics.addBody(leftWall, "static", {bounce = 0.1})
physics.addBody(rightWall, "static", {bounce = 0.1})
physics.addBody(topWall, "static", {bounce = 0.1})
physics.addBody(bottomWall, "static", {bounce = 0.1})

local circle = display.newCircle(0,20, 50)
circle.x = display.contentWidth*1.2
circle.y = 200

local function moveCircle()
circle.x = display.contentWidth*1.2
transition.to(circle, {time = 8000, x = -240, onComplete = moveCircle})
end

physics.addBody(circle, "static", {bounce = 0.1})
moveCircle()

local function onCollision( event )

        if ( event.phase == "began" ) then

            local obj1 = event.object1
            local obj2 = event.object2

            if ( obj1.myName == "circle" and obj2.myName == "Sprite" )
            then
              if ( died == false ) then
                died = true
                lives = lives - 1 -- update lives
                livesText.text = "Lives: " .. lives
                display.remove( obj1 )

                if ( lives == 0 ) then
                    display.remove( Sprite )
                else
                    Sprite.alpha = 0
                    timer.performWithDelay( 1000, restoreSprite )
                end
            end
         end
         end
         end
Runtime:addEventListener( "collision", onCollision )