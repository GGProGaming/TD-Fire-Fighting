if 1 == 1 then
	function init()
		RegisterTool("waterhose", "Water Hose", "MOD/vox/extinguisheropen.vox")
		SetBool("game.tool.waterhose.enabled", true)
		SetFloat("game.tool.waterhose.ammo", 101)
		waterSound = LoadLoop("MOD/snd/water.ogg")
		splashSoundzero = LoadLoop("MOD/snd/splash0.ogg")
		splashSoundone = LoadLoop("MOD/snd/splash1.ogg")
		splashSoundtwo = LoadLoop("MOD/snd/splash2.ogg")
		lifetime = 4.5
	end

	function rnd(mi, ma)
		return math.random(0, 1000)/1000*(ma-mi)+mi
	end

	local lmbWaterAmount = 0.25
	local rmbWaterAmount = 0.40
	local gravity = -40
	local smokeparticles = 0

	local d = 0.1 * 1

	function extinguish(Widespread)
		local t = GetCameraTransform()
		local forward = TransformToParentVec(t, Vec(0, 0, -1))
		local direction = forward
		local dist = 45
		local velocity = 0.10

		PlayLoop(waterSound, t.pos, 0.8)
		ParticleReset()
		ParticleType("smoke")
		ParticleColor(0.3, 0.4, 1)
		ParticleDrag(0.5)
		ParticleAlpha(1)
		ParticleSticky(0.03)
		ParticleFlags(256)
		ParticleCollide(8)
		ParticleGravity(-40)
		ParticleStretch(35.0)
		ParticleRadius(lmbWaterAmount, "easein")
		ParticleEmissive(rnd(0.1, 0.3), 0, "easeout")
		ParticleTile(1)
		if Widespread then
			ParticleRadius(rmbWaterAmount, rmbWaterAmount + 0.1, "easein")
			ParticleDrag(0.3)
			ParticleEmissive(rnd(0.1, 0.3), 0, "easeout")

			SpawnParticle(VecAdd(toolPos, Vec(d, d, d)), VecScale(direction, dist), lifetime)
			SpawnParticle(toolPos, VecScale(direction, dist), lifetime)
			SpawnParticle(VecSub(toolPos, Vec(0, 0, 0)), VecScale(direction, dist), lifetime)
	
			SpawnParticle(VecAdd(toolPos, Vec(d, d, d)), VecScale(direction, dist), lifetime)
			SpawnParticle(toolPos, VecScale(direction, dist), lifetime)
			SpawnParticle(VecSub(toolPos, Vec(0, 0, 0)), VecScale(direction, dist), lifetime)
	
			SpawnParticle(VecAdd(toolPos, Vec(d, d, d)), VecScale(direction, dist), lifetime)
			SpawnParticle(toolPos, VecScale(direction, dist), lifetime)
			SpawnParticle(VecSub(toolPos, Vec(0, 0, 0)), VecScale(direction, dist), lifetime)
	
			if smokeparticles == 1 then
				ParticleType("smoke")
				ParticleColor(1, 1, 1)
				ParticleRadius(rmbWaterAmount + -0.1)
				ParticleGravity(-40)
				ParticleAlpha(0.5)
				ParticleTile(0)
				ParticleStretch(20.0)
				SpawnParticle(VecAdd(toolPos, Vec(0.1, 0.1, 0.1)), VecScale(direction, velocity), lifetime)
				SpawnParticle(toolPos, VecScale(direction, velocity), lifetime)
				SpawnParticle(VecSub(toolPos, Vec(0, 0, 0)), VecScale(direction, velocity), lifetime)
			end

		else
		SpawnParticle(VecAdd(toolPos, Vec(d, d, d)), VecScale(direction, dist), lifetime)
		SpawnParticle(toolPos, VecScale(direction, dist), lifetime)
		SpawnParticle(VecSub(toolPos, Vec(0, 0, 0)), VecScale(direction, dist), lifetime)

		SpawnParticle(VecAdd(toolPos, Vec(d, d, d)), VecScale(direction, dist), lifetime)
		SpawnParticle(toolPos, VecScale(direction, dist), lifetime)
		SpawnParticle(VecSub(toolPos, Vec(0, 0, 0)), VecScale(direction, dist), lifetime)

		SpawnParticle(VecAdd(toolPos, Vec(d, d, d)), VecScale(direction, dist), lifetime)
		SpawnParticle(toolPos, VecScale(direction, dist), lifetime)
		SpawnParticle(VecSub(toolPos, Vec(0, 0, 0)), VecScale(direction, dist), lifetime)

			if smokeparticles == 1 then
				ParticleType("smoke")
				ParticleColor(1, 1, 1)
				ParticleRadius(lmbWaterAmount + -0.1)
				ParticleGravity(-40)
				ParticleAlpha(0.5)
				ParticleTile(0)
				ParticleStretch(20.0)
		
				SpawnParticle(VecAdd(toolPos, Vec(0.1, 0.1, 0.1)), VecScale(direction, velocity), lifetime)
				SpawnParticle(toolPos, VecScale(direction, velocity), lifetime)
				SpawnParticle(VecSub(toolPos, Vec(0, 0, 0)), VecScale(direction, velocity), lifetime)
			end

		end


	end

	function tick(dt)
		if GetBool("savegame.mod.debug") then DebugWatch(d) end
		if GetString("game.player.tool") == "waterhose" and GetPlayerVehicle() == 0 then
			local toolBody = GetToolBody()
			if toolBody ~= 0 then
				local offset = Transform(Vec(0.8, -0.6, -0.8))
				SetToolTransform(offset)
				toolTrans = GetBodyTransform(toolBody)
				toolPos = TransformToParentPoint(toolTrans, Vec(0, 0.2, -0.8))
			end
			if InputDown("lmb") then
				extinguish(false)
			end
			if InputDown("rmb") then
				toolPos = TransformToParentPoint(toolTrans, Vec(0, 0.2, -0.2))
				extinguish(true)
			end
		end
	end
end