-- TODO:
-- Add OOP for buttons

lf = love.filesystem
ls = love.sound
la = love.audio
lp = love.physics
lt = love.thread
li = love.image
lg = love.graphics
lm = love.mouse
width = lg.getWidth()
height = lg.getHeight()

function love.load()
	-- Images
    logo = lg.newImage("assets/images/snail studios logo.png");
    backgroundimage = lg.newImage("assets/images/background placeholder.png");
	titlescreen = lg.newImage("assets/images/title_screen.png")
	playbutton = lg.newImage("assets/images/play button.png")
	settingsbutton = lg.newImage("assets/images/settings button.png")
	castle = lg.newImage("assets/images/castle.png")
	sunnyhut = lg.newImage("assets/images/sunnyhut.png")
	taco = lg.newImage("assets/images/Taco_Guy.png")
	rainbow = lg.newImage("assets/images/rainbow.png")
	sscpeek = lg.newImage("assets/images/tacothoughts.png")
	mainhud = lg.newImage("assets/images/mainhud.png")

	icon = {"assets/images/normalicon.png", "assets/images/enemyicon.png", "assets/images/spbg.png", "assets/images/eks.png", "assets/images/royalknighticon.png", "assets/images/badroyalknighticon.png"}
	unit = {"assets/images/soldier.png", "assets/images/enemyknight.png", "assets/images/spnk.png", "assets/images/spek.png", "assets/images/royalknight.png", "assets/images/badroyalknight.png"}
	bodyparts = {"assets/images/normalesquireleftarm.png", "assets/images/normalesquirehead.png", "assets/images/normalesquirebody.png", "assets/images/normalesquirerightarm.png", "assets/images/normalleftleg.png", "assets/images/normalrightleg.png"}

	-- Audio

	audio3 = love.audio.newSource("assets/sfx/Retro-Night.mp3", "static")
	audio2 = love.audio.newSource("assets/sfx/Dark-winters-night.mp3", "static")
	audio = love.audio.newSource("assets/sfx/Tokyo-bells.mp3", "static")

	sfx1 = love.audio.newSource("assets/sfx/sfx1.mp3", "static")
	sfx2 = love.audio.newSource("assets/sfx/sfx2.mp3", "static")

	settingsfont = love.graphics.newFont(36)
	settingsfont2 = love.graphics.newFont(50)
	gamefont = lg.newFont((width+height)/100)
end

-- Variables

unitX = {100} unitY = {100} unitSelect = {} unitsize = {313, 417} unitspeed = 5 playerspeed = 5
destinationX = {} destinationY = {}
xadd = 0 yadd = 0 direction = "horizontal" maxX = 0 maxY = 0 unitselectednum = 0
easteregg = false eggtimer = 200 introtexttime = 500

mousedrag = 0 mousedragcoord = {} -- x, y, w, h

x = 0 y = 0

--v 0.2.3
page = "intro"
menuintro = 0
menuoutro = 200

--v 0.2.4
audiotoggle = true

--v 0.2.6.2
sfxplayed = {false, false}

--v 0.2.7
unittype = {0}

--v 0.3
version = love.window.getTitle()
battlemusic = false
battletime = 0

--v 0.3.0.2
code = ""
aa = 1664525
ac = 1013904223
am = math.pow(2, 32)
aseed = 1











--v a0.3.1
selectedunits = 0
unitpanelgraphic = function(x, y, w, h, ID)

	--background panel
	--image(icon[unittype[ID]], x, y, w, h)
	lg.draw(icon[unittype[ID]], x, y, 0, w, h, icon[unittype[ID]]:getWidth()/2, icon[unittype[ID]]:getHeight()/2)

	--health bar!
	strokeWeight(1)
	fill(100, 0, 0)
	rect(x + width/200, y + height/100, w - width/100, h/10)
	fill(255, 0, 0)
	rect(x + width/200, y + height/100, (w - width/100)*(unithealth[ID]/unitmaxhealth[round((unittype[ID]-1)/2)]), h/10)

	--health text
	fill(0)
	textAlign(CENTER, CENTER)

	if h > 100 then
		textSize(14)
	end
	if h < 100 and h > 10 then
		textSize(10)
	end

	text(unithealth[ID] + "/" + unitmaxhealth[round((unittype[ID]-1)/2)], x + width/200 + (w - width/100)/2, y + height/100 + h/20)

	if h > 100 then
		textSize((width+height)/250)
	end 
	if h < 100 and h > 10 then
		textSize((width+height)/300)
	end

	fill(150, 150, 0)
	text(unitname[round((unittype[ID]-1)/2)], x + width/200 + (w - width/100)/2, y + height/100 + h/5)
	end

IDredirect = {}
unithealth = {10}
ocatwords = ""

--v a0.4
attacked = {}
attackcooldown = {}

--v a0.5.2
mpd = false

--v a0.5.3
unitmaxhealth = {10, 50, 20}

--v a0.6
paused = false
unitname = {"Esquire", "Knight", "Royal Esquire"}

--v a0.7
ar = {-1} --rotation position
ad = {false} --direction
as = {0.1} --animation speed
zoom = 2 --self explanatory

unitanimation = {"idle"}

t1a = {-15, 0, -3, -10, 0, 0}
t2a = {-38, -63, 0, -42, 68, 70}
ra = {0, 0, 0, 0, 0, 0}
ixa = {-114/2, -52/2, -52/2, -48/2, -30/2, -38/2}
iya = {-40/2, -90/2, -134/2, -28/2, -10/2, -20/2}
iwa = {131, 57, 52, 41, 62, 61}
iha = {165, 62, 134, 115, 107, 116}

bodypart = function(t1, t2, r, l, ix, iy, iw, ih)
	translate(t1, t2)
	rotate(r)
	image(l, ix, iy, iw, ih)
end






function love.update(dt)
	if page == "game" then
		if paused == false then
		    if love.keyboard.isDown("w") then
		        y = y - playerspeed
		    end
		    if love.keyboard.isDown("a") then
		        x = x - playerspeed
		    end
		    if love.keyboard.isDown("s") then
		        y = y + playerspeed
		    end
		    if love.keyboard.isDown("d") then
		        x = x + playerspeed
		    end
		end
		
		-- Escape
		if love.keyboard.isDown("p") then
		    if paused == true then
		        paused = false
		    else
		        paused = true
		    end
		end

		-- Return to menu
		if paused == true then
		    if love.keyboard.isDown("m") then
		        page = "menu"
		        paused = false
		    end
		end
	end
end

--[[
buttons = {}
function createButton(id, image, x, y, scale, func)
	if buttons[tostring(id)] == nil then
		buttons[tostring(id)] = {sfx1 = false, sfx2 = false}
	end

	-- print(y) -- Why are both values printed and used?
	if mouseX > (x - (image:getWidth()*scale)/2) and mouseY > (y - (image:getHeight()*scale)/2)
	and mouseX < (x + (image:getWidth()*scale)/2) and mouseY < (y + (image:getHeight()*scale)/2) then
		lg.draw(image, x, y, -0.1, scale+0.05, scale+0.05, image:getWidth()/2, image:getHeight()/2)
		if buttons[tostring(id)].sfx1 == false and audiotoggle == true then
            sfx1:play()
			buttons[tostring(id)].sfx1 = true
        end

		if lm.isDown(1) then
			if buttons[tostring(id)].sfx2 == false and audiotoggle == true then
		        sfx2:play()
				buttons[tostring(id)].sfx2 = true
		    end
			func()
		else
			buttons[tostring(id)].sfx2 = false
		end
	else
		lg.draw(image, x, y, 0, scale, scale, image:getWidth()/2, image:getHeight()/2)
		buttons[tostring(id)].sfx1 = false
	end
end
--]]

function love.draw()
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()

	-- Settings page
	if page == "settings" then
        lg.setBackgroundColor(0, 0, 0)
		love.graphics.setFont(settingsfont)

		-- Glow effect
        for glowy = 1, 25 do
			lg.setColor(1, 1, 1, 1/255)
			lg.ellipse("fill", mouseX, mouseY, glowy*20, glowy*20)
        end

        -- "Yes" button
        if mouseX > width/2 - width/4 - width/20 and mouseY > height/2 - height/20 and mouseX < width/2 - width/4 + width/20 and mouseY < height/2 + height/20 then
			lg.setColor(100/255, 100/255, 100/255)

			-- Check if mouse clicked
			if lm.isDown(1) then
				page = "menu"
                audiotoggle = true
                audio:play()
			end
        else
			lg.setColor(50/255, 50/255, 50/255)
        end
        lg.rectangle("fill", width/2 - width/4 - width/20, height/2 - height/20, width/10, height/10)

		-- "No" button
        if mouseX > width/2 + width/4 - width/20 and mouseY > height/2 - height/20 and mouseX < width/2 + width/4 + width/20 and mouseY < height/2 + height/20 then
            lg.setColor(100/255, 100/255, 100/255)

			-- Check if mouse clicked
			if lm.isDown(1) then
				page = "menu"
                audiotoggle = false
				audio:stop()
				audio2:stop()
			end
        else
            lg.setColor(50/255, 50/255, 50/255)
        end
        lg.rectangle("fill", width/2 + width/4 - width/20, height/2 - height/20, width/10, height/10)

        lg.setColor(1, 1, 1)
		love.graphics.printf("Yes", -width/2 + width/4, (height/2 - 22)+0.5, width, "center")
		love.graphics.printf("No", width/2 - width/4, height/2 - 22+0.5, width, "center")

        love.graphics.setFont(settingsfont2)
		love.graphics.printf("Do you want audio?", 0, height/4 - 22, width, "center")

        love.graphics.setFont(settingsfont)
    end

	if page == "intro" then
		-- Set BGM
        if audiotoggle == true then
            audio:setVolume(0.5);
			audio:setLooping(true)
            audio:play();
        end

        lg.setBackgroundColor(0, 0, 0)

		-- Check if intro is done
        if menuintro < logo:getHeight()*1.1 then
            menuintro = menuintro + 1
        else
            page = "menu"
        end

		-- Logo
		lg.setColor(1, 1, 1)
        lg.draw(logo, width/2, height/2, 0, 0.5+menuintro/logo:getWidth()/2, 0.5+menuintro/logo:getHeight()/2, logo:getWidth()/2, logo:getHeight()/2);

		-- Fade out
		lg.setColor(0, 0, 0, (-300 + menuintro/(logo:getHeight()/1.5)*355)/255)
        lg.rectangle("fill", 0, 0, width, height)
		lg.setColor(1, 1, 1)
    end

	-- Menu page
	if page == "menu" then
		lg.draw(titlescreen, 0, 0, 0, width/titlescreen:getWidth(), height/titlescreen:getHeight())

		sfx1:setVolume(0.7)
		sfx2:setVolume(0.5)

		--createButton(1, playbutton, 150, 190, 0.2, function() page = "game" end)
		--createButton(2, settingsbutton, 150, 380, 0.2, function() page = "settings" end)

		-- Play button
		-- Check if mouse over
		if mouseX > width/12 and mouseY > height/4.6 and mouseX < width/12 + width/6 and mouseY < height/4.6 + height/7 then
			lg.draw(playbutton, 150, 190, -0.1, 0.25, 0.25, playbutton:getWidth()/2, playbutton:getHeight()/2)

			-- Check if sound is enabled
			if sfxplayed[1] == false and audiotoggle == true then
				sfx1:play()
				sfxplayed[1] = true
			end

			-- Check if mouse clicked
			if lm.isDown(1) then
				page = "game"

				-- Play sound
				if audiotoggle == true then
					sfx2:play()
				end

				-- Random something
				for nmbgen = 0, 1000 do
					aseed = math.floor(((aa * aseed + ac) % am) + 0.5)
				end
			end
		else
			lg.draw(playbutton, 150, 190, 0, 0.2, 0.2, playbutton:getWidth()/2, playbutton:getHeight()/2)
			sfxplayed[1] = false
		end

		-- Settings button
		-- Check if mouse over
		if mouseX > width/12 and mouseY > height/1.9 and mouseX < width/12 + width/6 and mouseY < height/1.9 + height/7 then
			lg.draw(settingsbutton, 150, 380, -0.1, 0.25, 0.25, settingsbutton:getWidth()/2, settingsbutton:getHeight()/2)

			-- Check if sound is enabled
			if sfxplayed[2] == false and audiotoggle == true then
				sfx1:play()
				sfxplayed[2] = true
			end

			-- Check if mouse clicked
			if lm.isDown(1) then
				page = "settings"

				-- Play sound
				if audiotoggle == true then
					sfx2:play()
				end
			end
		else
			lg.draw(settingsbutton, 150, 380, 0, 0.2, 0.2, settingsbutton:getWidth()/2, settingsbutton:getHeight()/2)
			sfxplayed[2] = false
		end
	end

	-- Game page
	if page == "game" then
		-- "Main settings"
		if "main settings" then
			audio:setVolume(0.5)
			audio2:setVolume(0.5)

			-- Check if sound is enabled
			if audiotoggle == true then
				if battlemusic == true then
				    audio2:play()
				    audio:pause()
				    if battletime < 600 then
				        battletime = battletime + 1
				    else
				        battlemusic = false
				    end
				else
				    audio:play()
				    audio2:pause()
				end
			end

			-- Background
			lg.setBackgroundColor(100/255, 100/255, 100/255)

			-- General settings
			--stroke(50) -- MIGHT NEED CHANGING
			lg.setLineWidth(10)
			lg.setLineStyle("smooth")
			love.graphics.setFont(gamefont)
		end

		if "map" then
			lg.draw(backgroundimage, -x, -y, 0, width/backgroundimage:getWidth(), height/backgroundimage:getHeight())
			lg.draw(castle, width - x, -y, 0, width/castle:getWidth(), height/castle:getHeight())
			lg.draw(sunnyhut, -width/2 - x, -y, 0, width/sunnyhut:getWidth()/2, height/sunnyhut:getHeight())
			--lg.printf(aseed, width*10 - x, -y, width, "center")
        end
	end
end
