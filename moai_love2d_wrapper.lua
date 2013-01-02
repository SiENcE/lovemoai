love = {}
love.graphics = {}
MOAILove2D = {}
MOAILove2D.dir = ""

local __prop_instances = {}
local __gColor = { 1, 1, 1, 1 }
local __renderlist = {}

function MOAILove2D.convertFilename( filename )
	return MOAILove2D.dir .. filename
end

function MOAILove2D.load( filename )	
	MOAILove2D.dir = "love2d_pclouds/";
	require ( MOAILove2D.convertFilename( "main" ) )
	require ( MOAILove2D.convertFilename( "conf" ) )
		
	config = { title = "moai_love2d_wrapper_test" }
	if love.conf then 
		love.conf( config ) 
	end
	
	SCREEN_UNITS_X = 800
	SCREEN_UNITS_Y = 600
	SCREEN_WIDTH = SCREEN_UNITS_X
	SCREEN_HEIGHT = SCREEN_UNITS_Y

	MOAISim.openWindow ( config.title, SCREEN_WIDTH, SCREEN_HEIGHT )
	MOAISim.setStep ( 1 / 60 )
	MOAISim.clearLoopFlags()
	MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_ALLOW_BOOST )
	MOAISim.setBoostThreshold ( 0 )

	viewport = MOAIViewport.new ()
	viewport:setSize ( SCREEN_WIDTH, SCREEN_HEIGHT )
	viewport:setScale ( SCREEN_UNITS_X, -SCREEN_UNITS_Y )
	viewport:setOffset( -1, 1 )
	  
	layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	MOAISim.pushRenderPass( layer )  

	if MOAIUntzSystem then
		MOAIUntzSystem.initialize()
	end

	love.load()

	--==============================================================
	-- game loop
	--==============================================================
	mainThread = MOAIThread.new ()

	gameOver = false

	mainThread:run ( 
		function ()
			local lastTime = MOAISim.getElapsedTime()
			while not gameOver do
			  
				coroutine.yield ()		
					
				local curTime = MOAISim.getElapsedTime()
				local dt = curTime - lastTime;
				lastTime = curTime;
				-- call Love2D callbacks
				love.update( dt )
				love.graphics:___renderinit()
				love.draw()
				love.graphics:___render()
	--			love.keypressed(k)
			end				
		end 
	)
end

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
   prop.texture:load ( MOAILove2D.convertFilename( file ) )
   local xtex, ytex = prop.texture:getSize ()

   prop.gfxQuad = MOAIGfxQuad2D.new ()
   prop.gfxQuad:setTexture ( prop.texture )
   prop.gfxQuad:setRect ( 0, 0, xtex, ytex )
   prop.gfxQuad:setUVRect( 0, 0, 1, 1 )

   prop:setDeck(prop.gfxQuad )
   layer:insertProp ( prop )

   __prop_instances[prop] = {index=1; prop }

   return prop
end

function love.graphics:___renderinit()  
  __renderlist = {}
end

function love.graphics:___render()
   -- new frame; reset instance index
   for _,prop in pairs(__prop_instances) do
      prop.index = 1
   end

   for _,renderitem in ipairs(__renderlist) do
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
      
      renderprop:setColor( unpack( __gColor ) )
      renderprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
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

function love.graphics.setColor( r,g,b,a) 
  __gColor = { color(r,g,b,a) }
end

function love.graphics.newImageFont() end
function love.graphics.quad() end
function love.graphics.setFont() end
function love.graphics.print() end


love.audio = {}
if MOAIUntzSystem then
	function love.audio.play( loveSnd ) 
		loveSnd.__untz:play()
	end
	function love.audio.newSource( file ) 
		loveSnd = {}
		loveSnd.__untz = MOAIUntzSound.new()
		loveSnd.__untz:load( MOAILove2D.convertFilename( file ) )
		loveSnd.__untz:setLooping(true)
		return loveSnd
	end
else
	function love.audio.play() end
	function love.audio.newSource() end
end
	
	
love.filesystem = {}
function love.filesystem.load() end
