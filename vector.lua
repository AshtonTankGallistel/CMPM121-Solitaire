
Vector = {}

vecMetatable ={
  --call is what happens when you 'call' a metatable like a function
  --So you could basically do Vector(), it makes and returns a vector()
  __call = function(self, a, b)
  
    local vec = {
      x = a,
      y = b
    }
    setmetatable(vec, vecMetatable) --This is wonky; in order to declare, you have to set the metatable from the inside
    return vec
  end,
  __add = function(a,b)
    return Vector(a.x +b.x,a.y+b.y)
  end,
  __mul = function(a,b)
    if type(a) == "number" then
      return Vector(a*b.x,a*b.y)
    end
    if type(b) == "number" then
      return Vector(a.x*b,a.y*b)
    end
    --if both vectors, component wise (not real vector mult)
    return Vector(a.x*b.x, a.y*b.y)
  end,
  __eq = function(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then return false end
      
    return a.x == b.x and a.y == b.y
  end
  
}

setmetatable(Vector, vecMetatable)

--COLLISION

--return if number n is between vector a's x and y values
  function between(a1,n,a2)
    return (a1 > n and n > a2) or (a1 < n and n < a2)
  end
  --Collision detection (true for collides, false for not). Below merely checks for any overlap whatsoever between rectangles a and b
  --1 refers to the top left corner of a/b, 2 refers to the bottom right corner
  function overlap(a1,a2,b1,b2)
    if (between(a1.x,b1.x,a2.x) and between(a1.y,b1.y,a2.y)) or
    (between(a1.x,b1.x,a2.x) and between(a1.y,b2.y,a2.y)) or
    (between(a1.x,b2.x,a2.x) and between(a1.y,b1.y,a2.y)) or
    (between(a1.x,b2.x,a2.x) and between(a1.y,b2.y,a2.y)) then
      return true
    end
    return false
  end
  --Collision detection for checking if a point is within a square area.a1 = top left, a2 = bottom right, b = the point
  function pointInside(a1,a2,b)
    if between(a1.x,b.x,a2.x) and between(a1.y,b.y,a2.y) then
      return true
    else
      return false
    end
  end