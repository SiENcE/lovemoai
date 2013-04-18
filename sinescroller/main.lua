-------------------------------------------------
-- Ultimate Sinescroller Demo		
-- By: fleg
-------------------------------------------------

function love.load()
	muzac = love.audio.newSource("labyrinth.mod");
	love.audio.play(muzac, 0);
	planetfont = love.graphics.newImageFont("planetfont.png", " abcdefghijklmnopqrstuvwxyz1234567890!?")	
	font = love.graphics.newImageFont("bluefont-2x.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
	flippedfont = love.graphics.newImageFont("bluefont-2x-vflip-gradient.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
	love.graphics.setFont(font);
	
	love.graphics.setBackgroundColor(0,0,0);
	--alpha = love.graphics.newColor(255,255,255,40);
	--noalpha = love.graphics.newColor(255,255,255,255);
	
	star = love.graphics.newImage("star.png");
	stars = {};
	
	textstring = "Yay! Behold the power of this awesome oldschool super-duper sine-scroller! Isn't it beautiful? I think so :3 (Music: labyrinth by omega)";
	textstring2 = "citizens! join one of our many offworld colonies and start a better life today! love corp will cover all interplanetary travel expenses if you sign up now!"; 
	
	yBase = 300;
	scrollerHeight = 30;
	letterSize = 21;
	angle = {};
	x = {};
	initScroller();
	initScroller2();
	-- changing color thingy
	col = 150;
	coldx = 100;
end

function love.update(dt)
	for i = 1,textstring:len() do
		stars[i].x = stars[i].x - stars[i].speed*dt
		if stars[i].x < -20 then
			stars[i].x = math.random(830, 900);
			stars[i].y = math.random(1,600);
		end
		angle[i] = angle[i] + math.pi/1.5 * dt;		
		x[i] = x[i] - letterSize*3*dt;
		if x[textstring:len()-1] < -letterSize*2 then
			initScroller();
		end
	end
	
	scroller2.x = scroller2.x - scroller2.speed * dt;
	if scroller2.x + textstring2:len()*scroller2.letterWidth < -scroller2.letterWidth then
		initScroller2();
	end
	
	if col > 254 and coldx > 0 or col < 1 and coldx < 0 then
		coldx = coldx *-1;
	end
	col = col + coldx*dt;
	
end

function love.draw()

	love.graphics.setColor(33,33,40);
	love.graphics.quad("fill", 0, 300, 0, 600, 800, 600, 800, 300)
	for i = 1,textstring:len() do	

		love.graphics.setColor(255 - stars[i].speed,255 - stars[i].speed/2,150,stars[i].speed*0.9);		
		love.graphics.draw(star, stars[i].x, stars[i].y, 0, stars[i].speed/255 + 0.55);
		
		local yflip = yBase + 40 + scrollerHeight + math.sin(angle[i])*scrollerHeight/2;
		local y = yBase - scrollerHeight - math.sin(angle[i])*scrollerHeight;
		
		c = textstring:sub(i,i);
		if x[i] > 2*-letterSize and x[i] < 850 then
			love.graphics.setColor(255, 255, col, 40);
			love.graphics.setFont(flippedfont);
			love.graphics.print(c,math.floor(x[i]),math.floor(yflip));			

			love.graphics.setColor(255, 255, col, 255);
			love.graphics.setFont(font);
			love.graphics.print(c,math.floor(x[i]),math.floor(y));
		end		
	end
	love.graphics.setColor(255,255,255,175);
	love.graphics.setFont(planetfont);
	love.graphics.print(textstring2, math.floor(scroller2.x), math.floor(scroller2.y));
	
	-- love.graphics.draw(textstring, 50, i)
end

function initScroller()
	local w = 800;
	for i = 1,textstring:len() do
		table.insert(stars, {x = math.random(1,800), y = math.random(1,600), speed = math.random(2,255)});
		angle[i] = i*6;
		x[i] = w+i*letterSize;
	end	
end

function initScroller2()
	local w = 800;
	scroller2 = {};
	scroller2 = {x = w + 30, y = 10, speed = 100, letterWidth = 16};
end