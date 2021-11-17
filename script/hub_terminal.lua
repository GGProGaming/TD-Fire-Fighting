messages = {{"Anonymous","An offer","As you may be aware, the westbound line has a blockage preventing all throughput. Clear this blockage tonight, and change the junction toward the coast. You will find yourself compensated quite nicely."},{}}

function init()
	timer = 0
	timeout = 0
	
	dvdX = 0
	dvdY = 0
	dvdColor = {1,0,0}
	dvdVelX = 1
	dvdVelY = 1
	
	emailScroll = 0
	currentEmail = 0
end

function tick(dt)
	timer = timer + dt
	timeout = timeout + dt
end

function draw()
	if GetPlayerScreen() == UiGetScreen() then
		timeout = 0
	end
	
	if timeout > 15 then
		UiPush()
			--screen saver
			dvdX = dvdX + (dvdVelX*5)
			dvdY = dvdY + (dvdVelY*5)
			UiTranslate(dvdX,dvdY)
			
			UiScale(4,4)
			UiColor(dvdColor[1],dvdColor[2],dvdColor[3])
			w, h = UiImage("hud/dvd.png")
			if (dvdX + (w*4) >= UiWidth()) or (dvdX <= 0) then
				dvdVelX = dvdVelX * -1
				dvdColor[1] =  math.random()
				dvdColor[2] =  math.random()
				dvdColor[3] =  math.random()
			end
			if (dvdY + (h*4) >= UiHeight()) or (dvdY <= 0) then
				dvdVelY = dvdVelY * -1
				dvdColor[1] =  math.random()
				dvdColor[2] =  math.random()
				dvdColor[3] =  math.random()
			end
		UiPop()
	else
		UiPush()
			UiFont("bold.ttf", 48)
			UiText("Emails")
			
			UiTranslate(0,50)
			local listW = UiCenter()-100
			local listH  = UiHeight()-50
			
			UiPush() --sub window for email list
				
				UiAlign("left top")
				
				UiWindow(listW, listH, true)
				UiColor(0.2, 0.2, 0.2)
				UiImageBox("common/box-solid-6.png", listW, listH, 6, 6)
				UiColor(1, 1, 1)
				UiImageBox("common/box-outline-6.png", listW, listH, 6, 6, 1)
				
				UiPush()
					UiTranslate(listW,0)
					UiAlign("top right")
					UiColor(0.1,0.1,0.1)
					UiImageBox("common/box-solid-6.png", 16, listH, 6, 6)
					UiColor(1,1,1)
					UiTranslate(0,16)
					UiRotate(-90)
					emailScroll = UiSlider("common/dot.png","x",emailScroll,0,listH-16)
				UiPop()
				
				if UiIsMouseInRect(listW,listH) then
					emailScroll = emailScroll - InputValue("mousewheel")*30
					if emailScroll < 0 then emailScroll = 0 end
					if emailScroll > listH-16 then emailScroll = listH-16 end
				end
				
				UiTranslate(0,emailScroll*-1)
				
				UiFont("bold.ttf",36)
				local fontHeight = UiFontHeight()
				for i=1, #messages do
					author = messages[i][1]
					name = messages[i][2]
					
					if UiIsMouseInRect(listW-15,fontHeight) then
						UiColor(0.4,0.4,0.4)
						UiRect(listW-15,fontHeight)
						UiColor(1, 1, 1)
						
						if InputPressed("lmb") then
							currentEmail = i
						end
					end
					UiText(name,true)
				end
				
			UiPop()
			UiPush()
				if currentEmail > 0 then
					UiTranslate(UiCenter(),50)
					
					UiPush()
						UiFont("bold.ttf", 48)
						UiWordWrap(UiCenter())
						UiText(messages[currentEmail][2],true)
						UiTranslate(0,10)
						
						UiFont("bold.ttf", 24)
						
						UiColor(0.3,0.3,0.3)
						UiText("Sent by "..messages[currentEmail][1],true)
						UiColor(1,1,1)
						
						
						UiText(messages[currentEmail][3],true)
						
					UiPop()
				end
			UiPop()
		UiPop()
	end
	
end