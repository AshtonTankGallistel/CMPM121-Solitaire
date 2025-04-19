
require "vector"
require "card"

StackClass = {}

function StackClass:new(xPos, yPos, stackType, bonus)
  local stack = {}
  local metadata = {__index = StackClass}
  setmetatable(stack,metadata)
  
  stack.position = Vector(xPos, yPos)
  stack.size = Vector(50, 70)
  stack.heldCards = {}
  print(stack.heldCards)
  
  --type of stack; affects rules for updating locations and pulling cards
  stack.type = stackType
  --extra info about stack. basically just the suit name for the suit stackType
  stack.bonus = bonus
  
  return stack
end

function StackClass:draw()
  love.graphics.setColor(0.5,0.5,0.5,0.5)
  love.graphics.rectangle("fill",self.position.x,self.position.y, 
    self.size.x, self.size.y, 6, 6)
  --love.graphics.print(tostring(#self.heldCards), self.position.x +20, self.position.y -20)
  if self.bonus ~= nil then
    love.graphics.setColor(0.5,0.5,0.5,0.9)
    love.graphics.print(self.bonus, self.position.x, self.position.y -20)
  end
  
end

--add card to stack
function StackClass:insertCard(card)
  if self.type == "suit" then
    if self.bonus ~= card.suit then return end
    local prevCard = self.heldCards[#self.heldCards]
    if prevCard ~= nil then
      if prevCard.value - card.value ~= -1 then return end
    elseif card.value ~= 1 then return end
  elseif self.type == "tableau" then
    local prevCard = self.heldCards[#self.heldCards]
    --if card doesn't match either of the criteria (nor is a king added to an empty line), don't add it
    if prevCard == nil then
      if card.value ~= 13 then
        return
      end
    elseif prevCard ~= nil then
      if(prevCard.value - card.value ~= 1 or prevCard.color == card.color) then
        return
      end
    end
  else --no other insertable decks
    return
  end
  table.insert(self.heldCards, card)
  card.myStack = self --help card track what stack it's in
  --print(#self.heldCards)
  self:updateLocations()
end

--version of insertCard done only via game setup, so ignores deck rules and doesn't visually update
function StackClass:insertDirect(card)
  table.insert(self.heldCards, card)
  card.myStack = self --help card track what stack it's in
  --print(#self.heldCards)
end

function StackClass:updateLocations()
  local distanceChange = 0
  if self.type == "tableau" or self.type == "draw" then
    distanceChange = 20
  end
  local distance = 0
  for _, card in ipairs(self.heldCards) do
    card.position.x = self.position.x
    card.position.y = self.position.y + distance
    distance = distance + distanceChange
  end
  --if top card is flipped, un-flip it
  print(#self.heldCards)
  if self.type ~= "deck" then
    if #self.heldCards > 0 and self.heldCards[#self.heldCards].flipped then
      self.heldCards[#self.heldCards].flipped = false
    end
  end
  
end

--helper function, returns top card object for reading
function StackClass:topCard()
  return self.heldCards[#self.heldCards]
end

function StackClass:cardPulled()
  print("bah")
  table.remove(self.heldCards,#self.heldCards)
  self:updateLocations()
end

--helper function for hit detection, returns true bottomright corner based on how big the deckshould be due to the type + card count
function StackClass:getBottomRight()
  local distanceChange = 0
  if self.type == "tableau" or self.type == "draw" then
    distanceChange = 20
  end
  return Vector(self.position.x + self.size.x, self.position.y + self.size.y + (#self.heldCards * distanceChange))
end
