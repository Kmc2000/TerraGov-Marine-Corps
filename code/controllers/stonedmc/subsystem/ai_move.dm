//How many controlelrs do you need, four?

//Handles tile by tile movement, meant for experimental reasons

SUBSYSTEM_DEF(ai_movement)
	name = "ai movement handler"
	priority = FIRE_PRIORITY_DEFAULT
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME
	wait = 1

	//A list of all AI datums that are going to move in the future, not in order by what time their going to move in sadly
	var/list/toprocess = list()

	//A list of ai datums to check; if they aren't allowed to move yet, we readd them to the list above
	var/list/currentrun = list()

/datum/controller/subsystem/ai_movement/fire(resumed = 0)
	if (!resumed)
		src.currentrun = toprocess.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/ai_behavior/ai = currentrun[currentrun.len]
		currentrun.len--
		if(ai.move_delay < world.time)
			ai.ProcessMove()

		if (MC_TICK_CHECK)
			return

//Tile by tile movement electro boogaloo
/datum/ai_behavior/proc/ProcessMove()

	if(!parentmob.canmove)
		return
	var/totalmovedelay = 0
	switch(parentmob.m_intent)
		if(MOVE_INTENT_RUN)
			totalmovedelay += 2 + CONFIG_GET(number/movedelay/run_delay)
		if(MOVE_INTENT_WALK)
			totalmovedelay += 7 + CONFIG_GET(number/movedelay/walk_delay)
	totalmovedelay += parentmob.movement_delay()

	var/doubledelay = FALSE //If we add on additional delay due to it being a diagonal move
	//var/turf/directiontomove = get_dir(parentmob, get_step_towards(parentmob, atomtowalkto)) //We cache the direction so we can adjust move delay on things like diagonal move alongside other things
	var/turf/smarterdirection = get_step_to(parentmob, atomtowalkto)
	if(!parentmob.Move(smarterdirection)) //If this doesn't work, we're stuck
		HandleObstruction()
		move_delay = world.time + 2 //Let's try again shortly:tm:
		return

	if(smarterdirection in GLOB.diagonals)
		doubledelay = TRUE

	if(doubledelay)
		move_delay = world.time + (totalmovedelay * SQRTWO)
	else
		move_delay = world.time + totalmovedelay
