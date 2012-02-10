print ( "hello, moai here is love!" )

require ("moai_love2d_wrapper")
require ("love2d_pclouds/main")

SCREEN_UNITS_X = 800
SCREEN_UNITS_Y = 600
SCREEN_WIDTH = SCREEN_UNITS_X
SCREEN_HEIGHT = SCREEN_UNITS_Y

MOAISim.openWindow ( "moai_love2d_wrapper_test", SCREEN_WIDTH, SCREEN_HEIGHT )

viewport = MOAIViewport.new ()
viewport:setScale ( SCREEN_UNITS_X, SCREEN_UNITS_Y )
viewport:setSize ( SCREEN_WIDTH, SCREEN_HEIGHT )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

love.load()

--==============================================================
-- game loop
--==============================================================
mainThread = MOAIThread.new ()

gameOver = false

mainThread:run ( 
	function ()

		local frames = 0

		while not gameOver do
		
			coroutine.yield ()
			frames = frames + 0.01
			
			-- call Love2D callbacks
			love.update( MOAISim.framesToTime (frames) )
			love.graphics:___renderinit()
			love.draw()
			love.graphics:___render()

--			love.keypressed(k)
		end
		
	end 
)

