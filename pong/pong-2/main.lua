push = require 'push'

WINDOW_WIDTH = 1200
WINDOW_HIEGHT = 700

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HIEGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    -- initilize the variable for the score
    player1Score = 0
    player2Score = 0

    -- define the position Y of the player1 and the player2
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT-50

    -- initilize the ball movements
    ballX = VIRTUAL_WIDTH/ 2 - 2
    ballY = VIRTUAL_HEIGHT/ 2 - 2
    
    ballDX = math.random(2) == 1 and 100 or - 100
    ballDY = math.random(-50, 50) * 1.5

    -- initilize the state of the game 
    gameState = 'start'

end

function love.update(dt)
    -- player1 movements 
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    -- player2 movements
    if love.keyboard.isDown('up') then 
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then 
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    -- Adding the velocity and the movements to the ball
    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            -- initilize the ball movements again at the start
            ballX = VIRTUAL_WIDTH/ 2 - 2
            ballY = VIRTUAL_HEIGHT/ 2 - 2
            
            ballDX = math.random(2) == 1 and 100 or - 100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(0, 0, 0, 255)


    love.graphics.printf('Hello Pong !', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2 + 40, VIRTUAL_HEIGHT / 3)

    -- draw the ball and the player1 and player2Y
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, ballY, 5, 20 )  -- initilize ballY here because i dont have control the player2 

    -- ball
    love.graphics.rectangle('fill', ballX, ballY, 4, 4 )
    push:apply('end')
end