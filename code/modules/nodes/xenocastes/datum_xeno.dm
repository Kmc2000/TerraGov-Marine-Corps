#define ENEMY_PRESENCE 1
#define DANGER_SCALE 2

//Basic datum AI for a xeno; ability to use acid on obstacles if valid as well as attack obstacles
/datum/ai_behavior/xeno
	var/last_health //For purposes of sensing overall danger at this node

/datum/ai_behavior/xeno/Init()
	..()
	parentmob.a_intent = INTENT_HARM
	last_health = parentmob.health

/datum/ai_behavior/xeno/proc/AttemptGetTarget()
	if(!SSai.is_pacifist)
		for(var/mob/living/carbon/human/human in cheap_get_humans_near(parentmob, 10))
			if(human.stat != DEAD)
				atomtowalkto = human
				return TRUE

	return FALSE

//Below proc happens everyone one second
/datum/ai_behavior/xeno/Process()
	..()
	if(parentmob.health < last_health)
		if(get_dist(parentmob, current_node) > get_dist(parentmob, destination_node)) //See what's closer
			destination_node.datumnode.increment_weight(DANGER_SCALE, last_health - parentmob.health)
			current_node.color = "#ff0000" //Red, we got hurt
		else
			current_node.datumnode.increment_weight(DANGER_SCALE, last_health - parentmob.health)
			current_node.color = "#ff0000" //Red, we got hurt
	last_health = parentmob.health
	HandleAbility()

//If it's a human we slap it, otherwise continue the random node traveling
/datum/ai_behavior/xeno/TargetReached()
	if(istype(atomtowalkto, /obj/effect/AINode))
		current_node = atomtowalkto
		var/list/humans_nearby = cheap_get_humans_near(parentmob, 10) //14 or less distance required to find a human	//While we're here let's update the amount of enemies here
		current_node.datumnode.set_weight(ENEMY_PRESENCE, humans_nearby.len)
		if(humans_nearby.len && !SSai.is_pacifist)
			current_node.color = "#FFA500"
			AttemptGetTarget()
		else
			current_node.color = initial(current_node.color)
			for(var/obj/effect/AINode/node in shuffle(current_node.datumnode.adjacent_nodes))
				if(SSai.is_pacifist && node.datumnode.get_weight(DANGER_SCALE) > 0)
					return
				else
					atomtowalkto = node
					break

	if(istype(atomtowalkto, /mob/living/carbon/human))
		var/mob/living/carbon/human/dammhuman = atomtowalkto
		if(dammhuman.stat != DEAD)
			var/mob/living/carbon/xenomorph/parentmob2 = parentmob
			if(parentmob2.next_move < world.time)
				atomtowalkto.attack_alien(parentmob2)
				parentmob2.next_move = parentmob2.xeno_caste.attack_delay + world.time
		else
			if(!AttemptGetTarget())
				..() //We go to a random node now if we don't have a nearby enemy target

/datum/ai_behavior/xeno/proc/HandleAbility()
	//var/list/somehumans = cheap_get_humans_near(parentmob, 14) //14 or less distance required to find a human
	//for(var/human in somehumans)
	//	atomtowalkto = human
	//	break

/datum/ai_behavior/xeno/HandleObstruction()
	var/mob/living/carbon/xenomorph/parentmob2 = parentmob

	for(var/obj/machinery/door/airlock/door in range(1, parentmob))
		if(door.density && !door.welded)
			door.open()

	for(var/turf/closed/probawall in range(1, parentmob))
		if(probawall.current_acid)
			return
		if(!probawall.acid_check(/obj/effect/xenomorph/acid/strong))
			var/obj/effect/xenomorph/acid/strong/newacid = new /obj/effect/xenomorph/acid/strong(get_turf(probawall), probawall)
			newacid.icon_state += "_wall"
			newacid.acid_strength = 0.1 //Very fast acid
			probawall.current_acid = newacid

	if(parentmob2.next_move < world.time) //If we can attack again or not
		for(var/obj/structure/struct in range(1, parentmob))
			if(struct.attack_alien(parentmob))
				parentmob2.next_move = parentmob2.xeno_caste.attack_delay + world.time
				return
		for(var/obj/machinery/machin in range(1, parentmob))
			if(machin.attack_alien(parentmob))
				parentmob2.next_move = parentmob2.xeno_caste.attack_delay + world.time
				return


//Like the old one but now will do left and right movements upon being in melee range
/datum/ai_behavior/xeno/ProcessMove()
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
	if(get_dist(parentmob, atomtowalkto) > 1)
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

	else //We're right at the target, let's do some left or right movement
		if(prob(SSai.prob_sidestep_melee))
			var/leftorright = pick(LeftAndRightOfDir(get_dir(parentmob, atomtowalkto)))
			if(step(parentmob, leftorright))
				move_delay = world.time + totalmovedelay
