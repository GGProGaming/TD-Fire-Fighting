function init()
	slider = FindJoint("joint")
	wheel = FindJoint("wheel")
	panel = FindShape("switch")
	
	velocity = 2.5
	
	sliderprev = 0
end

function tick(dt)
	if GetPlayerInteractShape() == panel and InputPressed("interact") then
		velocity = velocity * -1
		if velocity > 0 then
			SetTag("panel","interact","open")
		else
			SetTag("panel","interact","close")
		end
	end
	
	slidercurrent = GetJointMovement(slider)
	slidermotion = sliderprev - slidercurrent
	
	if 7-slidercurrent < 0.1 then
		slidermotion = 0
	end
	
	sliderprev = slidercurrent
	SetJointMotor(slider,velocity,10000)
	SetJointMotor(wheel,slidermotion*200,2)
end