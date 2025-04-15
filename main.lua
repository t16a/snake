if arg[2] == "debug" then
    require("lldebugger").start()
end

local snake, pip, state, menu, frame, border
local dirBuffer = {}
local sfx = {}
local speeds = {1, 2, 3, 9, 10}

--- TODO
-- field size?
-- highscore ("saving")

function love.load()
    math.randomseed(os.time())

    -- libs
    Object = require "lib.classic"

    -- Objects/Globals
    Score = 0
    Utils = require "utils"
    local Snake = require "snake"
    local Pip = require "pip"
    local State = require "state"
    local Menu = require "menu"
    local Border = require "border"

    -- init
    sfx.death = love.audio.newSource("assets/sfx/sfx_sounds_damage3.wav", "static")
    sfx.pip = love.audio.newSource("assets/sfx/sfx_menu_move2.wav", "static")
    state = State()
    menu = Menu(state)
    snake = Snake(state)
    pip = Pip(Utils.getLineWidth() * 20, Utils.getLineHeight() * 10, 9, 9, menu)
    border = Border()
    frame = 0

    table.insert(dirBuffer, {dx = 1, dy = 0}) -- initial direction, "right"
end

function love.keypressed(key)
    if state.currentState == state.states.PLAY then
        local dx, dy = 0, 0
        if key == "left" then
            dx = -1
        elseif key == "right" then
            dx = 1
        elseif key == "up" then
            dy = -1
        elseif key == "down" then
            dy = 1
        elseif key == "escape" then
            love.event.quit("restart")
        end

        if (#dirBuffer < 2) then
            table.insert(dirBuffer, {dx = dx, dy = dy})
        end
    elseif state.currentState == state.states.MENU then
        menu:update(key)
    elseif state.currentState == state.states.GAME_OVER then
        if key ~= "right" and key ~= "left" and key ~= "up" and key ~= "down" then
            love.event.quit("restart") -- restart if "any" key
        end
    end
end

function love.update(dt)
    frame = frame + 1
    if state.currentState == state.states.PLAY then
        if frame % (60 / speeds[menu:getSpeed()]) == 0 then
            snake:update(dirBuffer, pip, sfx, menu:getSpeed())
            if menu:isBorder() then
                -- update walls
                border:update(snake, state, sfx)
            end
        end
    end
end

function love.draw()
    if state.currentState == state.states.PLAY then
        -- score
        local score
        if Score == 0 then
            score = "00"
        else
            score = Score .. "00"
        end
        love.graphics.printf(score, 0, 6, Utils.getWindowWidth() - 10, "right")

        -- playfield
        love.graphics.rectangle(
            "line",
            Utils.getLineWidth(),
            Utils.getLineHeight() * 2,
            Utils.getLineWidth() * 30,
            Utils.getWindowHeight() - Utils.getLineHeight() * 3
        )

        if menu:isBorder() then
            border:draw()
        end
        snake:draw()
        pip:draw()
    elseif state.currentState == state.states.MENU then
        menu:draw()
    elseif state.currentState == state.states.GAME_OVER then
        love.graphics.printf("GAME OVER", 0, Utils.getLineHeight() * 8, Utils.getWindowWidth(), "center")
        love.graphics.printf(
            "Score: " .. Score .. "00",
            0,
            Utils.getLineHeight() * 10,
            Utils.getWindowWidth(),
            "center"
        )
        love.graphics.printf(
            "Press any key to restart",
            0,
            Utils.getLineHeight() * 12,
            Utils.getWindowWidth(),
            "center"
        )
    end
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
