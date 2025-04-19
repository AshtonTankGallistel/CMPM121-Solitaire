-- Ashton Gallistel
-- CMPM 121 - Pickup
-- 4-11-25
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "stack"

function love.load()
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0,0.7,0.2,1)
  
  grabber = GrabberClass:new()
  cardTable = {}
  grabbedCard = nil
  
  --table.insert(cardTable, CardClass:new(100,100,"Spades",1))
  --table.insert(cardTable, CardClass:new(150,100,"Hearts",4))
  for _, suit in ipairs({"Spades","Clubs","Hearts","Diamonds"}) do
    for val = 1, 13 do
      table.insert(cardTable, CardClass:new(100,100,suit,val,true))
    end
  end
  
  
  --STACKS
  stackTable = {}
  --Deck Pile
  table.insert(stackTable, StackClass:new(50,100, "deck"))
  --Draw Pile
  table.insert(stackTable, StackClass:new(50,175, "draw"))
  --Tableau Piles
  table.insert(stackTable, StackClass:new(150,100, "tableau"))
  table.insert(stackTable, StackClass:new(250,100, "tableau"))
  table.insert(stackTable, StackClass:new(350,100, "tableau"))
  table.insert(stackTable, StackClass:new(450,100, "tableau"))
  table.insert(stackTable, StackClass:new(550,100, "tableau"))
  table.insert(stackTable, StackClass:new(650,100, "tableau"))
  table.insert(stackTable, StackClass:new(750,100, "tableau"))
  --Suit Piles
  table.insert(stackTable, StackClass:new(875,100, "suit", "Spades"))
  table.insert(stackTable, StackClass:new(875,200, "suit", "Clubs"))
  table.insert(stackTable, StackClass:new(875,300, "suit", "Hearts"))
  table.insert(stackTable, StackClass:new(875,400, "suit", "Diamonds"))
  
  math.randomseed(os.time())
  for _, card in ipairs(cardTable) do
    stackTable[math.random(3,9)]:insertDirect(card)
  end
  
  for _, deck in ipairs(stackTable) do
    deck:updateLocations()
  end
  
  
end

function love.update()
  grabber:update()
  
  checkForMouseMoving()
  
  for _, card in ipairs(cardTable) do
    card:update(grabber)
  end
end

function love.draw()
  for _, stack in ipairs(stackTable) do
    stack:draw()
  end
  
  for _, card in ipairs(cardTable) do
    card:draw()
  end
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. "," .. tostring(grabber.currentMousePos.y))
  love.graphics.print("\nflipping: " .. tostring(grabber.flipping))
  
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil or grabbedCard ~= nil then
    if grabber.grabPos == nil and grabbedCard ~= nil then --Card dropped, check position
      --Loop through stacks
      for _, stack in ipairs(stackTable) do
          print("stack")
        if pointInside(stack.position, stack:getBottomRight(), grabber.currentMousePos) then
          stack:insertCard(grabbedCard)
          break --exit loop when added to a stack
        end
      end
      grabbedCard = nil
      --TODO: add code for sending cards back if they aren't added to stack
    end
    return
  end
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
    --If hovering, consider results
    if card.state == CARD_STATE.MOUSE_OVER then
      if grabber.grabPos ~= nil and not card.flipped then -- if left clicked, grab the card
        --check if inside stack (if it is, we can't pick it up)
        print(card.myStack)
        if card.myStack == nil or card.myStack:topCard() == card then
          card.state = CARD_STATE.GRABBED
          grabbedCard = card
          --pop and reinsert card at end of cardTable
          table.remove(cardTable,_)
          table.insert(cardTable,grabbedCard)
          break
          end
--      elseif grabber.flipping then --if right clicked, flip the card
--        card.flipped = not card.flipped --done by inversing current flip value
      end
    end
  end
end
