push = require 'push'

Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1200
WINDOW_HIEGHT = 700

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong ! ')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HIEGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    servingPlayer = 1

    -- initilize the variable for the score
    player1Score = 0
    player2Score = 0

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    -- initilize the state of the game 
    gameState = 'start'

end

function love.update(dt)
    -- Adding the velocity and the movements to the ball
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

    elseif gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(-10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(-10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
        
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end
    end

    -- Score Update When Colision 
    if ball.x < 0 then
        servingPlayer = 1
        player1Score = player1Score + 1
        
        if player2Score == 10 then 
            winningPlayer = 2
            gameState = 'done'
        else
            gameState = 'serve'
            ball:reset()
        end
    end

    if ball.x > VIRTUAL_WIDTH then
        servingPlayer = 2
        player2Score = player2Score + 1

        if player1Score == 10 then
            winningPlayer = 1
            gameState = 'done'
        else
            gameState = 'serve'
            ball:reset()
        end
    end

    -- player1 movements 
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- player2 movements
    if love.keyboard.isDown('up') then 
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then 
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState == 'play' then 
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'start'
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(0, 0, 0, 255)

    -- Display the score of both player
    displayScore()

    if gameState == 'start' then
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'done' then 
        love.graphics.printf('Player '.. tostring(winningPlayer) .." hurry !",
            0, 10, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    end

    
    -- draw the ball and the player1 and player2Y
    player1:render()
    player2:render()

    -- Ball
    ball:render()

    displayFPS()
    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS..'..tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2 + 40, VIRTUAL_HEIGHT / 3)
end