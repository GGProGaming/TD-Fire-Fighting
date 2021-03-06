-- website left menu --
WebSiteMenuLinkName_Mail = "Mail Account"
WebSiteMenuLinkName_Employees = "Hire Employees"
WebSiteMenuLinkName_Upgrades = "Upgrade Shop"
WebSiteMenuLinkName_Housing = "Home Shopping"

-- Tasks for Mails--

Tasks = {
	{
		id = 1,
		reward = 100,
		declineFee = -100,
	},
	{
		id = 2,
		reward = 100,
		declineFee = -100,
	},
	{
		id = 3,
		reward = 100,
		declineFee = -100,
	},
	{
		id = 4,
		reward = 100,
		declineFee = -100,
	},
	{
		id = 5,
		reward = 100,
		declineFee = -100,
	}
}

-- Mails --
Mail_Welcome = {
	sender = "Claire",
	subject = "Congratulations to your new job!",
	text = "Hey Honey!\n\nLook at you! A real fire department manager now. I am sooo proud of you, little brother and so is mom. Please let us know how it is going and show those fires who's the boss!!!\n\nLove You!\n\nClaire ",	
	checked = false
}

Mail_FirstMission = {
	sender = "Maurice",
	subject = "Fire! Fire! Fire!"		,
	text = "Dear Sir or Madam,\n\nI recently discovered a fire in my kitchen. Please come and help.\n\nLooking forward to hearing from you.\n\nMaurice",	
	checked = false,
	task = Tasks[1]
}

Mail_SecondMission = {
	sender = "James Cormack",
	subject = "Accidents happen"		,
	text = "Hey there!\n\nWhile I was cooking some steaks over my radiator, that dang thing ignited the oil and now I'm sitting in my toilet and waiting for someone to put out the da*n fire!!!\n\nCome immediately!!",	
	checked = false,
	task = Tasks[2]
}

Mail_ThirdMission = {
	sender = "Freddy 'Dima' Loupe",
	subject = "My Cat Is On Fire!!!"		,
	text = "I need help!\n\nMy cat caught on fire and is running around the house setting everything alight... You gotta help me! Please save Mr. Wiggles!\n\nHe's going to suffocate right now! I need help NOW!",	
	checked = false,
	task = Tasks[3]
}

Mail_FourthMission = {
	sender = "Dennis Tuxed",
	subject = "A Dumpster Fire"		,
	text = "Hello mate\n\nI was walking down the street when I saw some stupid teenagers running from a smoking dumpster. When I walked over there, it was on fire!\n\nGood luck!",	
	checked = false,
	task = Tasks[4]
}
Mail_FifthMission = {
	sender = "Bob Killz",
	subject = "My Bloody House!"		,
	text = "Its BURNING\n\nMy Bloody HOUSE is BURNING. Ya hear me? Its BURNING!!! Get over here NOW!\n\nGet UP!",	
	checked = false,
	task = Tasks[5]
}
Mail_SixthMission = {
	sender = "Amazon Web Services Middle East A.K.A. AWSME",
	subject = "Company House"		,
	text = "To whomever it concerns,\n\nWe were notified recently that a company property of AMAZON was on fire and burning to the ground. Please resolve this issue as soon as possible.\n\nThanks, AWSME",	
	checked = false,
	task = Tasks[6]
}
Mail_SeventhMission = {
	sender = "Larry Walsh",
	subject = "A Unfortunate Series of Events",
	text = "Good day lad,\n\nSo, I woke up on this fine day and prepared myself to go to work... as well as preparing some very tasty breakfast of eggs and pickles. Then I went to work and arrived back home in the evening. While I made my late evening dinner however, I was struck by the overwelming smell of smoke. And what do you know? MY HOUSE IS ON FIRE!\n\nHelp ME or ELSE!",	
	checked = false,
	task = Tasks[7]
}


StartMails = { 
	Mail_Welcome,
	Mail_FirstMission,
	Mail_SecondMission,
	Mail_ThirdMission,
	Mail_FourthMission,
	Mail_FifthMission,
	Mail_SixthMission,
	Mail_SeventhMission,
}


-- employee configs --
Employees = {
	{
		name = "Trainee Firefighter",
		userLevelNeeded = 3,
		stars = 1,
		costPerHour = 25,
		speed = 250
	},
	{
		name = "Standard Firefighter",
		userLevelNeeded = 4,
		stars = 2,
		costPerHour = 40,
		speed = 220
	},
	{
		name = "Experienced Firefighter",
		userLevelNeeded = 4,
		stars = 3,
		costPerHour = 60,
		speed = 180
	},
	{
		name = "Heroic Firefighter",
		userLevelNeeded = 5,
		stars = 4,
		costPerHour = 80,
		speed = 150
	}
}

-- upgrade configs --
Upgrades = {
	{
		name = "Upgrade 1",
		userLevelNeeded = 2,
		cost = 25,
	},
	{
		name = "Upgrade 2",
		userLevelNeeded = 3,			
		cost = 40,
	},
	{
		name = "Upgrade 3",
		userLevelNeeded = 4,			
		cost = 60,
	},
	{
		name = "Upgrade 4",
		userLevelNeeded = 4,
		cost = 80,
	},
	{
		name = "Upgrade 5",
		userLevelNeeded = 5,
		cost = 100,
	},
	{
		name = "Upgrade 6",
		userLevelNeeded = 6,
		cost = 120,
	},
	{
		name = "Upgrade 7",
		userLevelNeeded = 7,
		cost = 140,
	},
	{
		name = "Upgrade 8",
		userLevelNeeded = 7,
		cost = 160,
	},
	{
		name = "Upgrade 9",
		userLevelNeeded = 8,
		cost = 170,
	}
}

---- House Upgrades ----

Housings = {
	{
		name = "Nice Chair",
		userLevelNeeded = 2,
		cost = 25,
	},
	{
		name = "Bettter Desk",
		userLevelNeeded = 3,			
		cost = 40,
	},
	{
		name = "House Upgrade 3",
		userLevelNeeded = 4,			
		cost = 60,
	},
	{
		name = "House Upgrade 4",
		userLevelNeeded = 4,
		cost = 80,
	},
	{
		name = "House Upgrade 5",
		userLevelNeeded = 5,
		cost = 100,
	},
	{
		name = "House Upgrade 6",
		userLevelNeeded = 6,
		cost = 120,
	},
	{
		name = "House Upgrade 7",
		userLevelNeeded = 7,
		cost = 140,
	},
	{
		name = "House Upgrade 8",
		userLevelNeeded = 7,
		cost = 160,
	},
	{
		name = "House Upgrade 9",
		userLevelNeeded = 8,
		cost = 170,
	},
	{
		name = "House Upgrade 10",
		userLevelNeeded = 8,
		cost = 180
	},
	{
		name = "House Upgrade 11",
		userLevelNeeded = 9,
		cost = 185
	},
	{
		name = "House Upgrade 12",
		userLevelNeeded = 9,
		cost = 200
	},
	{
		name = "House Upgrade 13",
		userLevelNeeded = 10,
		cost = 220
	},
}