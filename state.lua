local State = Object:extend()

function State:new()
    self.states = { MENU = 1, PLAY = 2, GAME_OVER = 3 }
    self.currentState = self.states.MENU
end

function State:update(state)
    self.currentState = state
end

return State
