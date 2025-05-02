
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

CARD_SUIT = {
  SPADES = 1,
  CLUBS = 2,
  HEARTS = 3,
  DIAMONDS = 4
}

--Suit_Display = {
--  1 = nil,
--  2 = nil,
--  3 = nil,
--  4 = nil
--}

function CardClass:new(xPos, yPos, s, num, flipped)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card,metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  card.state = CARD_STATE.IDLE
  if flipped == nil then card.flipped = false else card.flipped = flipped end
  
  card.suit = s
  print(CARD_SUIT.SPADES)
  if s == CARD_SUIT.SPADES then 
    card.suitSym = "<3<♠"
    card.color = "b"
  elseif s == CARD_SUIT.CLUBS then 
    card.suitSym = "c3<♣"
    card.color = "b"
  elseif s == CARD_SUIT.HEARTS then 
    card.suitSym = "3>♥"
    card.color = "r"
  elseif s == CARD_SUIT.DIAMONDS then 
    card.suitSym = "<>♦"
    card.color = "r"
  end
  card.value = num
  
  card.myStack = nil
  
  return card
end

function CardClass:update(grabber)
  if self.state == CARD_STATE.GRABBED then
    --when grabbed, update stack stuff
    if self.myStack ~= nil and grabber.grabPos ~= nil then
      self.myStack:cardPulled()
      self.myStack = nil
    end
    
    --if still holding, follow mouse
    if grabber.grabPos ~= nil then
      self.position = Vector(grabber.currentMousePos.x - (self.size.x / 2), grabber.currentMousePos.y - (self.size.y / 2))
      return
      --if not still holding, check if dropped in invalid position
    elseif not self:checkValidPos() then
      self.position = grabber.grabPos --THIS WON'T WORK. IT TURNS INTO A NIL VALUE BY THE TIME THIS GETS CALLED
    end
    --If grabPos is nil, then it doesn't return, and the state is reset
    self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
  end
  
end

function CardClass:draw()
  local red = {1,0,0,1}
  local black = {0,0,0,1}
  local white = {1,1,1,1}
  
  
  --love.graphics.setColor(white and self.flipped or red)
  if not self.flipped then
    love.graphics.setColor(white)
  else
    love.graphics.setColor(red)
  end
  love.graphics.rectangle("fill",self.position.x,self.position.y, 
    self.size.x, self.size.y, 6, 6)
  
  --love.graphics.print(tostring(self.state), self.position.x +20, self.position.y -20)
  if self.color == "r" then love.graphics.setColor(red) else love.graphics.setColor(black) end
  if not self.flipped then love.graphics.print(tostring(self.suitSym .." ".. self.value), self.position.x, self.position.y) end
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED then
    return
  end
  
  
  local mousePos = grabber.currentMousePos
  local isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
      
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end

--States whether card is put into a valid position
--RETURNS TRUE FOR NOW, AS NO STACKS HAVE BEEN MADE. MODIFY AS NEEDED
function CardClass:checkValidPos()
  return true
end
