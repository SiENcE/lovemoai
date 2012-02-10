love = {}
love.graphics = {}

local __prop_instances = {}

local function clonePropInstance(prop)
   local copy = MOAIProp2D.new()
   copy:setDeck(prop.gfxQuad)
   layer:insertProp(copy)
   table.insert(__prop_instances[prop], copy)
   return copy
end

function love.graphics.newImage(file)
   local prop = MOAIProp2D.new ()

   prop.texture = MOAITexture.new ()
   prop.texture:load ( file )
   local xtex, ytex = prop.texture:getSize ()

   prop.gfxQuad = MOAIGfxQuad2D.new ()
   prop.gfxQuad:setTexture ( prop.texture )
   prop.gfxQuad:setRect ( xtex/2*-1, ytex/2*-1, xtex/2, ytex/2 )

   prop:setDeck(prop.gfxQuad )
   layer:insertProp ( prop )

   __prop_instances[prop] = {index=1; prop }

   return prop
end

local __renderlist = {}

function love.graphics:___renderinit()
   __renderlist = {}
end

function love.graphics:___render()
   -- new frame; reset instance index
   for _,prop in pairs(__prop_instances) do
      prop.index = 1
   end

   for i,renderitem in ipairs(__renderlist) do
      local prop, x, y = unpack(renderitem)

      -- get an instance of this prop, creating a new one if all existing ones have been used
      local instances = __prop_instances[prop]
      if instances.index > #instances then
         clonePropInstance(prop)
      end
      local renderprop = instances[instances.index]
      instances.index = instances.index + 1

      renderprop:setLoc(prop, x-(SCREEN_WIDTH/2), y-(SCREEN_HEIGHT/2))
   end
end

function love.graphics.draw( prop, x, y, r, sx, sy, ox, oy )
   table.insert(__renderlist, {prop, x, y, r, sx, sy, ox, oy })
end

function love.graphics.setBackgroundColor() end
function love.graphics.setColor() end
function love.graphics.newImageFont() end
function love.graphics.quad() end
function love.graphics.setFont() end
function love.graphics.print() end

love.audio = {}
function love.audio.play() end
function love.audio.newSource() end

love.filesystem = {}
function love.filesystem.load() end
