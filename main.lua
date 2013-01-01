print ( "hello, moai here is love!" )

require ("moai_love2d_wrapper")


LOVE_DIR = "love2d_pclouds/";

require (LOVE_DIR.."main")

SCREEN_UNITS_X = 800
SCREEN_UNITS_Y = 600
SCREEN_WIDTH = SCREEN_UNITS_X
SCREEN_HEIGHT = SCREEN_UNITS_Y

MOAISim.openWindow ( "moai_love2d_wrapper_test", SCREEN_WIDTH, SCREEN_HEIGHT )
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

