
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber,metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  grabber.flipping = false --bool, true on frame you try to flip
  grabber.pressRC = false --bool, true on frame you try to flip
  
  return grabber
end

function GrabberClass:update()
  self.flipping = false --should always be false, except for the first frame you press RC
  self.currentMousePos = Vector(
      love.mouse.getX(),
      love.mouse.getY()
    )
    
  -- Click (just first frame)
  if love.mouse.isDown(1) and self.grabPos == nil then -- left click
    self:grab()
  elseif love.mouse.isDown(2) and self.grabPos == nil and not self.pressRC then -- right click
    self.flipping = true
    self.pressRC = true
  end
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  elseif not love.mouse.isDown(2) and self.pressRC then
    self.pressRC = false
  end
    
end
  
  
function GrabberClass:grab()
  self.grabPos = self.currentMousePos
  --print("GRAB - " .. tostring(self.grabPos))
end
  
function GrabberClass:release()
  --print("RELEASE - " .. tostring(self.grabPos))
  
  self.grabPos = nil
end
