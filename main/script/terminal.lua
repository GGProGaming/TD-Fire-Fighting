--
--	Savegame variables are:
--
--	Int 	savegame.mod.userLevel 					- the level of the user
--	Int 	savegame.mod.userMoney 					- the money of the user
--  Int 	savegame.mod.employees.1.hired			- the number of hired level 1 employees
--  Int 	savegame.mod.employees.2.hired			- the number of hired level 2 employees
--  Int 	savegame.mod.employees.3.hired			- the number of hired level 3 employees
--  Int 	savegame.mod.employees.4.hired			- the number of hired level 4 employees
--  Bool	savegame.mod.housings.{index}.bought	- true, if the house upgrade with index {index} has already been bought
--  Bool	savegame.mod.upgrades.{index}.bought	- true, if the upgrade with index {index} has already been bought
--  Bool	savegame.mod.mails.{index}.read			- true, if the mail with index {index} has already been read
--  String	savegame.mod.task.{index}.status		- either nil, if not yet decided or "Accepted" or "Rejected" for the task with index {index}


#include "config.lua"

function init()
	currentTab = "welcome"
	header = ""

	sandboxIsOptimizedSelected = false

	Userlevel = GetInt("savegame.mod.userLevel",UserStartLevel)
	UserMoney = GetInt("savegame.mod.userMoney",UserStartMoney)	
	
	currentWebsite = "main"					
	
	HousingsCurrentPageSlider = 1
	BoughtHouseUpgrades = {}
	
	UpgradesCurrentPageSlider = 1
	BoughtUpgrades = {}

	BoughtEmployees = {}
	
	Mails = StartMails	
	
	for i=1, #Mails do
		if Mails[i].task and GetString("savegame.mod.task."..Mails[i].task.id..".status") ~= "" then
			Mails[i].task.status = "[ "..GetString("savegame.mod.task."..Mails[i].task.id..".status").." ]"
		end
	end
	
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

function showMenu()
	UiPush()
		UiColor(0, 0, 0, 0.9)
		UiTranslate(5,5)
		UiRect(UiWidth()-10, UiHeight()/4-5)
		UiPush()
			UiTranslate(UiWidth()-15,UiHeight()/4-10)
			UiColor(1, 1, 1)
			UiAlign("bottom right")
			UiFont("regular.ttf",20)
			UiText("LEVEL : " ..Userlevel)
			UiTranslate(0,-22)
			UiText("MONEY : $"..UserMoney)
		UiPop()		
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
				UiTranslate(0,30)
				UiFont("regular.ttf",14)
				if UiTextButton(WebSiteMenuLinkName_Housing) then currentWebsite = "housing" end
			UiPop()						
		UiPop()
		UiTranslate(UiWidth()/3, 0)
		UiRect(2*UiWidth()/3-10, 3*UiHeight()/4-10)		
	UiPop()
end

function showHousing(name,image, userLevelNeeded,cost,index)
	UiPush()
		
		if Userlevel >= userLevelNeeded and not GetBool("savegame.mod.housings."..index..".bought") then
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.2)		
		elseif GetBool("savegame.mod.housings.bought."..index) then
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.6,.1)	
		else
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.1)		
		end
		
		if UiBlankButton(350,80) and Userlevel >= userLevelNeeded and UserMoney >= cost and not GetBool("savegame.mod.housings."..index..".bought") then
			SetUserMoney(UserMoney - cost)			
			SetBool("savegame.mod.housings."..index..".bought", true)
		end		

		UiPush()
			UiTranslate(7,7)		
			UiColor(1,1,1)
			UiImageBox(image,50,50,0,0)
			UiTranslate(65,0)		
			UiColor(0.8,0.8,0.8)
			UiFont("bold.ttf",12)
			UiText(name)			
		UiPop()	
		UiTranslate(1,60)
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
		if GetBool("savegame.mod.housings."..index..".bought") then			
			UiColor(0.5,0.9,0.5)
			UiText("Already Bought")	
		else		
			UiText("$" ..cost .. notEnoughMoney)	
		end
		if Userlevel < userLevelNeeded then
			UiTranslate(265,0)	
			UiColor(0.8,0.2,0.2)
			UiText("Needs Level ".. userLevelNeeded)	
		end		
	UiPop()
	UiTranslate(0,85)
end

function showUpgrade(name,userLevelNeeded,cost,upgradeIndexInTable)
	UiPush()
		
		if Userlevel >= userLevelNeeded and not GetBool("savegame.mod.upgrades."..upgradeIndexInTable..".bought") then
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.2)		
		elseif GetBool("savegame.mod.upgrades.bought."..upgradeIndexInTable) then
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.6,.1)		
		else
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.1)		
		end
		
		if UiBlankButton(350,50) and Userlevel >= userLevelNeeded and UserMoney >= cost and not GetBool("savegame.mod.upgrades."..upgradeIndexInTable..".bought") then			
			SetUserMoney(UserMoney - cost)
			SetBool("savegame.mod.upgrades."..upgradeIndexInTable..".bought", true)
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
		if GetBool("savegame.mod.upgrades."..upgradeIndexInTable..".bought") then			
			UiColor(0.5,0.9,0.5)
			UiText("Already Bought")	
		else		
			UiText("$" ..cost .. notEnoughMoney)	
		end
		if Userlevel < userLevelNeeded then
			UiTranslate(265,0)	
			UiColor(0.8,0.2,0.2)
			UiText("Needs Level ".. userLevelNeeded)	
		end
	UiPop()
	UiTranslate(0,55)
end

function SetUserMoney(money)
	UserMoney = money
	SetInt("savegame.mod.userMoney", UserMoney)
end

function SetUserLevel(level)
	Userlevel = level
	SetInt("savegame.mod.userLevel", Userlevel)
end


function showEmployeeSelect(name,stars,userLevelNeeded,cost)

	UiPush()
		
		if Userlevel >= userLevelNeeded and GetInt("savegame.mod.employees."..stars..".hired") < 2 then
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.2)		
		else
			UiButtonImageBox("ui/common/box-solid-6.png",6,6,0.1,.1,.1)		
		end
				
		if UiBlankButton(350,50) and Userlevel >= userLevelNeeded and GetInt("savegame.mod.employees."..stars..".hired") < 2 and UserMoney >= cost then			
			SetUserMoney(UserMoney - cost)			
			SetInt("savegame.mod.employees."..stars..".hired",GetInt("savegame.mod.employees."..stars..".hired")+1)
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
		if Userlevel >= userLevelNeeded and UserMoney >= cost then
			UiColor(0.2,0.8,0.2)
		else
			UiColor(0.8,0.2,0.2)
		end		
		UiFont("bold.ttf",11)		
		UiText("$" ..cost .. " / hour")	
		if Userlevel < userLevelNeeded then
			UiTranslate(265,0)	
			UiColor(0.8,0.2,0.2)
			UiText("Needs Level ".. userLevelNeeded)	
		elseif GetInt("savegame.mod.employees."..stars..".hired") > 0 then
			UiTranslate(265,0)	
			if GetInt("savegame.mod.employees."..stars..".hired") ~= 2 then
				UiColor(0.2,0.8,0.2)
			else
				UiColor(0.8,0.2,0.2)
			end
			UiText("Bought "..GetInt("savegame.mod.employees."..stars..".hired").." of 2")	
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

function showHousings()
	UiPush()
		UiAlign("top left")
		UiTranslate(UiWidth()/3+15, UiHeight()/4+15)					
		UiTranslate(20,5)		
		local Page = math.max(1,math.ceil((HousingsCurrentPageSlider /300) * math.max(1,(#Housings - 3))))
		
		for i=Page,  math.min(#Housings,Page+3) do
			showHousing(Housings[i].name,Housings[i].image, Housings[i].userLevelNeeded,Housings[i].cost,i)	
		end					
	UiPop()
	if #Housings > 4 then
		UiPush()		
			UiTranslate(UiWidth()-20,UiHeight()/3)
			UiRotate(-90)
			
			UiColor(.5,.5,.5)
			UiRect(300,2)
			UiColor(.8,.8,.8)
			UiTranslate(-8,-8)
			HousingsCurrentPageSlider = UiSlider("ui/common/dot.png", "y", HousingsCurrentPageSlider, 1, 300)
		UiPop()
	end
	
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
		
		if not GetBool("savegame.mod.mails."..indexOfMail..".read") then
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
				SetBool("savegame.mod.mails."..indexOfMail..".read",true)
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
					if UiTextButton("Accept") and GetString("savegame.mod.task."..mail.task.id..".status") == "" then
						table.insert(tasks,mail.task)
						mail.task.status = "[ Accepted ]"
						SetString("savegame.mod.task."..mail.task.id..".status","Accepted")
					elseif GetString("savegame.mod.task."..mail.task.id..".status") == "Accepted" then
						mail.task.status = "[ Accepted ]"
					end
					UiTranslate(60,0)	
					UiButtonImageBox("ui/common/box-solid-4.png",4,4,0.6,.2,.2)							
					if UiTextButton("Decline") and GetString("savegame.mod.task."..mail.task.id..".status") == "" then
						UserMoney = UserMoney + mail.task.declineFee
						mail.task.status = "[ Declined  (-$"..mail.task.declineFee..") ]"
						SetString("savegame.mod.task."..mail.task.id..".status","Declined")
					elseif GetString("savegame.mod.task."..mail.task.id..".status") == "Declined" then
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
			if UiTextButton("+") then SetUserLevel(Userlevel + 1) end
			UiTranslate(30,0)
			if UiTextButton("-") then SetUserLevel(math.max(1,Userlevel - 1)) end
		UiPop()
		UiTranslate(0,30)
		UiPush()
			UiText("Money: "..UserMoney)
			UiTranslate(100,0)
			if UiTextButton("+") then SetUserMoney(UserMoney + 50) end
			UiTranslate(30,0)
			if UiTextButton("-") then SetUserMoney(math.max(0,UserMoney - 50)) end
		UiPop()
		UiTranslate(0,30)
		if UiTextButton("Clear all bought Upgrades") then 
			for i=1, #Upgrades do					     
				SetBool("savegame.mod.upgrades."..i..".bought",false)
			end
		end
		UiTranslate(0,30)
		if UiTextButton("Clear all bought House upgrades") then 
			for i=1, #Housings do
				SetBool("savegame.mod.housings."..i..".bought",false)
			end
		end
		UiTranslate(0,30)
		if UiTextButton("Clear all hired firemen") then 
			for i=1, 4 do
				SetInt("savegame.mod.employees."..i..".hired",0)
			end
		end
		UiTranslate(0,30)
		if UiTextButton("Clear all Mails and Tasks") then 
			for i=1, #Mails do
				SetBool("savegame.mod.mails."..i..".read",false)
				if Mails[i].task then
					Mails[i].task.status = nil
					SetString("savegame.mod.task."..Mails[i].task.id..".status","")
				end
			end
		end	
			
			
		
	UiPop()
end

function draw()	

	UiImageBox("MOD/main/images/background.png", UiWidth(), UiHeight(), 10, 10)

	UiColor(0, 0, 0, 0.9)
	UiRect(UiWidth(), UiHeight())
	
	showMenu()
	
	if currentWebsite == "employees" then showHireEmployees() end
	if currentWebsite == "upgrades" then showUpgrades() end
	if currentWebsite == "mails" then showMails() end
	if currentWebsite == "housing" then showHousings() end
	
	if showCheats then cheats() end
end