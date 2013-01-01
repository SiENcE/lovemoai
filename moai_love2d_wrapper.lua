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
   prop.texture:load ( LOVE_DIR..file )
   local xtex, ytex = prop.texture:getSize ()

   prop.gfxQuad = MOAIGfxQuad2D.new ()
   prop.gfxQuad:setTexture ( prop.texture )
   prop.gfxQuad:setRect ( 0,ytex,xtex,0 )

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
      local prop, x, y, r, sx, sy, ox, oy = unpack(renderitem)

      -- get an instance of this prop, creating a new one if all existing ones have been used
      local instances = __prop_instances[prop]
      if instances.index > #instances then
         clonePropInstance(prop)
      end
      local renderprop = instances[instances.index]
      instances.index = instances.index + 1
  
      renderprop:setPiv( ox, oy );
      renderprop:setLoc( x, y );
      renderprop:setRot( math.deg(r) );
      
    renderprop:setColor( unpack( gColor ) )
    renderprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
    --renderprop:setBlendMode( MOAIProp.GL_DST_COLOR, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
     --unpack( gColor ) );
      --renderprop:setParent( transform )
   end
end

function love.graphics.draw( prop, x, y, r, sx, sy, ox, oy )
   table.insert(__renderlist, {prop, x, y, r or 0, sx or 1, sy or 1, ox or 0, oy or 0 })
end


local function color( r,g,b,a ) 
  local function convert(c) return math.max( math.min( (c or 255 ) / 255, 1 ), 0 ) end
  return convert(r), convert(g), convert(b), convert(a)
end

function love.graphics.setBackgroundColor( r, g, b ) 
  MOAIGfxDevice.setClearColor( color( r,g,b ) )
end

gColor = { 1, 1, 1, 1 }
function love.graphics.setColor( r,g,b,a) 
  gColor = { color(r,g,b,a) }
end

function love.graphics.newImageFont() end
function love.graphics.quad() end
function love.graphics.setFont() end
function love.graphics.print() end

love.audio = {}
function love.audio.play() end
function love.audio.newSource() end

love.filesystem = {}
function love.filesystem.load() end
