local Gamestate = require 'vendor/gamestate'
local game = require 'game'
local window = require 'window'
local state = Gamestate.new()

local selections = {}
selections[0] = {}
selections[1] = {}
selections[1][0] = require 'characters/troy'
selections[1][1] = require 'characters/shirley'
selections[1][2] = require 'characters/pierce'
selections[0][0] = require 'characters/jeff'
selections[0][1] = require 'characters/britta'
selections[0][2] = require 'characters/abed'
selections[0][3] = require 'characters/annie'

function state:init()
    self.side = 0 -- 0 for left, 1 for right
    self.level = 0 -- 0 through 3 for characters
    self.screen = love.graphics.newImage("images/selectscreen.png")
    self.arrow = love.graphics.newImage("images/arrow.png")
    love.graphics.setFont(love.graphics.newFont("fonts/xen3.ttf", 32))
end

function state:character()
    return selections[self.side][self.level]
end

function state:keypressed(key)
    local level = self.level
    local options = 4

    if self.side == 1 then
        options = 3
    end

    if key == 'left' or key == 'right' or key == 'a' or key == 'd' then
        self.side = (self.side - 1) % 2
    elseif key == 'up' or key == 'w' then
        level = (self.level - 1) % options
    elseif key == 'down' or key == 's' then
        level = (self.level + 1) % options
    end

    if self.side == 1 and level == 3 then
        level = 2
    end

    self.level = level
    
    if key == 'return' then
        local character = self:character()
        Gamestate.switch(game, character)
    end
end

function state:draw()
    love.graphics.draw(self.screen)
    local x = 17
    local r = 0
    local offset = 68

    if self.side == 1 then
        x = window.width - 17
        r = math.pi
        offset = 68 + self.arrow:getHeight()
    end

    love.graphics.draw(self.arrow, x, offset + 34 * self.level, r)
    love.graphics.printf(self:character().name, 0, 20, window.width, 'center')
    love.graphics.printf('PRESS ENTER', 0, 200, window.width, 'center')
end


return state

