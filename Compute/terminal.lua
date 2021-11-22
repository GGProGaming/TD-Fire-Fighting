
#include "fire.lua"
#include "config.lua"

function init()
	currentTab = "welcome"
	header = ""

	sandboxIsOptimizedSelected = false

	Userlevel = UserStartLevel
	UserMoney = UserStartMoney
	
	currentWebsite = "main"				
	
	UpgradesCurrentPageSlider = 1
	BoughtUpgrades = {}

	BoughtEmployees = {}
	
	Mails = StartMails	
	MailsCurrentPageSlider = 1
	CurrentMailOpen = nil
	
	showCheats = false
	
	tasks = {}
end

function tick()
	if InputPressed("f1") then
		showCheats = not showCheats
	end
end

function showPage1()
	UiColor(0, 0, 0, 0.7)
	UiRect(UiWidth(), UiHeight())

	UiFont("bold.ttf", 64)
	UiAlign("center middle")
	UiColor(1, 0.5, 0.4)
	UiRect(2000, 200)
	UiColor(1, 1, 1)
	UiTranslate(UiWidth() / 2, 50)
	UiText(header)
	UiTranslate(-UiWidth() / 3, 0)
	UiColor(1, 1, 1)
	UiFont("regular.ttf", 32)
	UiButtonImageBox("MOD/images/box-outline-6.png", 10, 10)
	UiTranslate(UiCenter(), UiMiddle())

	UiTranslate(-100, -150)

	------------------------------------------------------------
	if currentTab == "welcome" then
		header = "Welcome"

		if Userlevel > 3 then
			UiTextButton("Hire Employees")
				currentTab = "hire"
		else
			UiColor(1, 1, 1, 0.5)
		end

		UiTranslate(0, 50)
		if UiTextButton("Upgrades") then
			currentTab = "upgrades"
		end
	end
	------------------------------------------------------------
	if currentTab == "upgrades" then
		header = "Upgrades"
		if UiTextButton("Go back") then
			UiTranslate(0, -150)
			currentTab = "welcome"
		end
	end
	------------------------------------------------------------
	if currentTab == "hire" then
		header = "Hire Employees"
	
		UiTranslate(0, 50)
		UiColor(1, 1, 1, 1)
		if UiTextButton("Noob FireFighter") then
			Emp_level = 1 == true
		end

		UiTranslate(0, 50)
		UiColor(1, 1, 1, 1)
		if UiTextButton("O.K. FireFighter") then
			Emp_level = 2 
		end

		UiTranslate(0, 50)
		UiColor(1, 1, 1, 1)
		if UiTextButton("Average FireFighter") then
			Emp_level = 3 
		end

		UiTranslate(0, 50)
		UiColor(1, 1, 1, 1)
		if UiTextButton("Best FireFighter") then
			Emp_level = 4
		end
		UiColor(1, 1, 1, 1)

		UiTranslate(0, 70)
		if UiTextButton("Go back") then
			currentTab = "welcome"
		end
	end
	------------------------------------------------------------
	if currentTab == "sandboxPreview" then
		header = "Sandbox"

		UiWordWrap(400)
		UiTranslate(0, 10)
		UiText("Play in Sandbox Mode with all the Tools that you've unlocked in the story mode.")
		UiWordWrap(0)

		
		--if sandboxIsOptimizedSelected then
		--	UiColor(1, 1, 1, 0.5)
		--else
		--	UiColor(1, 1, 1, 1)
		--end
		
		UiTranslate(0, 90)
		if UiTextButton("Play in Sandbox Mode") then
			if not sandboxIsOptimizedSelected then
				StartLevel("", "MOD/heightyhills.xml")
			else
				StartLevel("", "MOD/heightyhills - less trees.xml")
			end
		end
		
		UiTranslate(0, 90)
		if not sandboxIsOptimizedSelected then
			UiColor(0, 1, 0)
			if UiTextButton("[UNOPTIMIZED]") then
				sandboxIsOptimizedSelected = false
			end
		else
			UiColor(1, 0, 0)
			if UiTextButton("UNOPTIMIZED") then
				sandboxIsOptimizedSelected = false
			end
		end
		UiTranslate(0, 50)
		if sandboxIsOptimizedSelected then
			UiColor(0, 1, 0)
			if UiTextButton("[OPTIMIZED]") then
				sandboxIsOptimizedSelected = true
			end
		else
			UiColor(1, 0, 0)
			if UiTextButton("OPTIMIZED") then
				sandboxIsOptimizedSelected = true
			end
		end
		UiColor(1, 1, 1)
		
		UiTranslate(250, 70)
		if UiTextButton("Go back") then
			currentTab = "upgrades"
		end
	end
	------------------------------------------------------------
end

function showMenu()
	UiPush()
		UiColor(0, 0, 0, 0.9)
		UiTranslate(5,5)
		UiRect(UiWidth()-10, UiHeight()/4-5)
		UiTranslate(0,UiHeight()/4)
		UiRect(UiWidth()/3-5, 3*UiHeight()/4-10)
		UiPush()
			UiTranslate(10,20)
			UiColor(1,1,1,0.03)
			UiRect(UiWidth()/3-25,30)
			UiColor(1,1,1)
			UiTranslate(0,23)
			UiPush()
				UiTranslate(65,0)
				UiFont("regular.ttf",23)
				UiText("Menu")
			UiPop()
			UiTranslate(0,60)
			UiButtonHoverColor(0,1,0)
			UiPush()
				UiTranslate(45,0)
				UiFont("regular.ttf",14)
				if UiTextButton(WebSiteMenuLinkName_Mail) then currentWebsite = "mails" end
				UiTranslate(0,30)
				UiFont("regular.ttf",14)
				if UiTextButton(WebSiteMenuLinkName_Upgrades) then currentWebsite = "upgrades" end
				UiTranslate(0,30)
				UiFont("regular.ttf",14)
				if UiTextButton(WebSiteMenuLinkName_Employees) then currentWebsite = "employees" end
			UiPop()						
		UiPop()
		UiTranslate(UiWidth()/3, 0)
		UiRect(2*UiWidth()/3-10, 3*UiHeight()/4-10)		
	UiPop()
end

function showUpgrade(name,userLevelNeeded,cost,upgradeIndexInTable)
	UiPush()
		
		if Userlevel >= userLevelNeeded then
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.2)		
		else
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.1)		
		end
		
		if UiBlankButton(350,50) and Userlevel >= userLevelNeeded and UserMoney >= cost then
			BoughtUpgrades[#BoughtUpgrades+1] = name
			UserMoney = UserMoney - cost
			table.remove(Upgrades, upgradeIndexInTable)
		end		

		UiPush()
			UiTranslate(7,7)		
			UiColor(0,0,0)
			UiRect(20,20)
			UiTranslate(40,0)		
			UiColor(0.8,0.8,0.8)
			UiFont("bold.ttf",12)
			UiText(name)			
		UiPop()	
		UiTranslate(1,30)
		UiColor(0.05,0.05,0.05)		
		UiImageBox("ui/common/box-solid-4.png",348,19,4,4)				
		UiTranslate(10,1)	

		notEnoughMoney = ""
		if UserMoney < cost then notEnoughMoney = " - Not Enough Money" end
		
		if Userlevel >= userLevelNeeded then
			if UserMoney >= cost then
				UiColor(0.2,0.8,0.2)
			else
				UiColor(0.8,0.2,0.2)
			end
		else
			UiColor(0.3,0.3,0.3)
		end		
		UiFont("bold.ttf",11)		
		UiText("$" ..cost .. notEnoughMoney)	
		if Userlevel < userLevelNeeded then
			UiTranslate(265,0)	
			UiColor(0.8,0.2,0.2)
			UiText("Needs Level ".. userLevelNeeded)	
		end
	UiPop()
	UiTranslate(0,55)
end

function showEmployeeSelect(name,stars,userLevelNeeded,cost)

	UiPush()
		
		if Userlevel >= userLevelNeeded then
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.2)		
		else
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.1)		
		end
		
		if UiBlankButton(350,50) and Userlevel >= userLevelNeeded then
			Emp_level = stars == true
			UserMoney = UserMoney - cost
			table.remove(Employees, hireIndexInTable)
		end		

		UiPush()
			UiTranslate(7,7)		
			UiColor(0,0,0)
			UiRect(20,20)
			UiTranslate(40,0)		
			UiColor(0.8,0.8,0.8)
			UiFont("bold.ttf",12)
			UiText(name)
			UiTranslate(230,0)		
			UiPush()			
				for i=1,4-stars  do
					UiColor(.1,.1,0)
					UiImageBox("ui/common/star.png",12,12,0,0)	
					UiColor(.8,.8,0)
					UiImageBox("ui/common/star-outline.png",12,12,0,0)		
					UiTranslate(15,0)
				end	
				for i=1, stars do
					UiColor(1,1,0)
					UiImageBox("ui/common/star.png",12,12,0,0)		
					UiTranslate(15,0)
				end			
			UiPop()	
		UiPop()	
		UiTranslate(1,30)
		UiColor(0.05,0.05,0.05)		
		UiImageBox("ui/common/box-solid-4.png",348,19,4,4)				
		UiTranslate(10,1)		
		if Userlevel >= userLevelNeeded then
			UiColor(0.2,0.8,0.2)
		else
			UiColor(0.3,0.3,0.3)
		end		
		UiFont("bold.ttf",11)
		UiText("$" ..cost .. " / hour")	
		if Userlevel < userLevelNeeded then
			UiTranslate(265,0)	
			UiColor(0.8,0.2,0.2)
			UiText("Needs Level ".. userLevelNeeded)	
		end
	UiPop()
	UiTranslate(0,55)
end

function showHireEmployees()
	UiPush()
		UiAlign("top left")
		UiTranslate(UiWidth()/3+15, UiHeight()/4+15)					
		UiTranslate(20,5)			
		for i=1, #Employees	do
			showEmployeeSelect(Employees[i].name,Employees[i].stars,Employees[i].userLevelNeeded,Employees[i].costPerHour)	
		end					
	UiPop()
end

function showUpgrades()
	UiPush()
		UiAlign("top left")
		UiTranslate(UiWidth()/3+15, UiHeight()/4+15)					
		UiTranslate(20,5)		
		local Page = math.max(1,math.ceil((UpgradesCurrentPageSlider /300) * math.max(1,(#Upgrades - 5))))
		
		for i=Page,  math.min(#Upgrades,Page+5) do
			showUpgrade(Upgrades[i].name,Upgrades[i].userLevelNeeded,Upgrades[i].cost,i)	
		end					
	UiPop()
	if #Upgrades > 6 then
		UiPush()		
			UiTranslate(UiWidth()-20,UiHeight()/3)
			UiRotate(-90)
			
			UiColor(.5,.5,.5)
			UiRect(300,2)
			UiColor(.8,.8,.8)
			UiTranslate(-8,-8)
			UpgradesCurrentPageSlider = UiSlider("ui/common/dot.png", "y", UpgradesCurrentPageSlider, 1, 300)
		UiPop()
	end
	
end

function showMail(mail, indexOfMail)
					
	UiPush()
		UiFont("regular.ttf",12)
		UiWordWrap(340)
		local w,h = UiGetTextSize(mail.text)		
		
		if not mail.checked then
			UiButtonImageBox("ui/common/box-solid-4.png",4,4,0.2,.4,.2)		
		else
			UiButtonImageBox("ui/common/box-solid-4.png",4,4,0.3,.3,.3)		
		end
		
		if mail.task ~= nil then
			h = h + 30
		end
		
		if indexOfMail == CurrentMailOpen then
			UiColor(0.6,0.6,0.6)
			UiImageBox("ui/common/box-solid-4.png",350,40+h+30,4,4)					
		end
		UiColor(0.8,0.8,0.8)
		UiImageBox("ui/common/box-solid-4.png",350,40,4,4)				
		if UiBlankButton(350,20) then 
			mail.checked = true
			if CurrentMailOpen ~= indexOfMail then 
				CurrentMailOpen = indexOfMail 
			else
				CurrentMailOpen = nil
			end
		end
		UiImageBox("ui/terminal/arrow.png",20,20,0,0)
		UiPush()
			UiTranslate(20,3)		
			UiColor(0.8,0.8,0.8)
			UiFont("bold.ttf",12)
			UiText(mail.subject)		

			UiTranslate(-15,17)	
			UiColor(0,0,0)
			UiFont("bold.ttf",12)
			UiText("From: " .. mail.sender)		
			
			if indexOfMail == CurrentMailOpen then
				UiTranslate(0,30)	
				UiFont("regular.ttf",12)
				UiText(mail.text)		
				UiTranslate(0,h)
				if mail.task ~= nil and mail.task.status == nil then
					UiTranslate(50,-10)	
					UiFont("regular.ttf",12)					
					UiButtonImageBox("ui/common/box-solid-4.png",4,4,0.2,.4,.2)		
					UiColor(1,1,1)					
					if UiTextButton("Accept") then
						table.insert(tasks,mail.task)
						mail.task.status = "[ Accepted ]"
					end
					UiTranslate(60,0)	
					UiButtonImageBox("ui/common/box-solid-4.png",4,4,0.6,.2,.2)							
					if UiTextButton("Decline") then
						UserMoney = UserMoney + mail.task.declineFee
						mail.task.status = "[ Declined  (-$"..mail.task.declineFee..") ]"
					end
				elseif mail.task ~= nil and mail.task.status ~= nil then
					UiTranslate(50,-20)	
					UiFont("regular.ttf",20)
					UiTextOutline(0,0,0,0.3)
					UiRotate(5)
					if mail.task.status == "[ Accepted ]" then
						UiColor(0,0.5,0)
					else
						UiColor(1,0,0)
					end
					UiText(mail.task.status)
				end
			end						
		UiPop()	
		UiTranslate(1,30)					
	UiPop()
	if indexOfMail == CurrentMailOpen then
		UiTranslate(0,45+h+30)
	else
		UiTranslate(0,45)
	end
end


function showMails()
	local spaceTakenByMails = 0
	UiPush()
		UiAlign("top left")
		UiTranslate(UiWidth()/3+15, UiHeight()/4+15)					
		UiTranslate(20,5)								
		
		UiWindow(UiWidth(),320,true)
		
		UiTranslate(0,-MailsCurrentPageSlider/300 * 320)
		
		for i=1, #Mails do
			spaceTakenByMails = spaceTakenByMails + 45 + 30
			if i == CurrentMailOpen then	
				UiPush()
					UiFont("regular.ttf",12)
					UiWordWrap(340)
					local w,h = UiGetTextSize(Mails[i].text)	
					spaceTakenByMails = spaceTakenByMails + h
				UiPop()
				if Mails[i].level ~= nil then
					spaceTakenByMails = spaceTakenByMails + 30
				end	
			end							
			showMail(Mails[i],i)								
		end					
		
		
	UiPop()
	if spaceTakenByMails > 320 then
		UiPush()		
			UiTranslate(UiWidth()-20,UiHeight()/3)
			UiRotate(-90)
			
			UiColor(.5,.5,.5)
			UiRect(300,2)
			UiColor(.8,.8,.8)
			UiTranslate(-8,-8)
			MailsCurrentPageSlider = UiSlider("ui/common/dot.png", "y", MailsCurrentPageSlider, 1, 300)
		UiPop()
	end
end

function cheats()
	UiPush()
		UiColor(0, 0, 0, 1)
		UiRect(UiWidth(), UiHeight())

		UiTranslate(50,50)
		
		UiFont("regular.ttf",14)
		UiColor(1,1,1)
		UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.2)		
		
		UiText("--- Cheats ---")
		UiTranslate(0,50)
		UiPush()
			UiText("UserLevel: "..Userlevel)
			UiTranslate(100,0)
			if UiTextButton("+") then Userlevel = Userlevel + 1 end
			UiTranslate(30,0)
			if UiTextButton("-") then Userlevel = math.max(1,Userlevel - 1) end
		UiPop()
		UiTranslate(0,30)
		UiPush()
			UiText("Money: "..UserMoney)
			UiTranslate(100,0)
			if UiTextButton("+") then UserMoney = UserMoney + 50 end
			UiTranslate(30,0)
			if UiTextButton("-") then UserMoney = math.max(0,UserMoney - 50) end
		UiPop()
			
		
	UiPop()
end

function draw()	

	UiImageBox("MOD/images/background.png", UiWidth(), UiHeight(), 10, 10)

	UiColor(0, 0, 0, 0.9)
	UiRect(UiWidth(), UiHeight())
	
	showMenu()
	
	if currentWebsite == "employees" then showHireEmployees() end
	if currentWebsite == "upgrades" then showUpgrades() end
	if currentWebsite == "mails" then showMails() end
	
	if showCheats then cheats() end
end