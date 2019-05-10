//An AI datum for drones; it makes weeds and pheromones using magic


/datum/ai_behavior/xeno/drone

/datum/ai_behavior/xeno/drone/Init()
	..()
	var/list/possibleaura = list("recovery", "warding", "frenzy")
	parentmob.current_aura = pick(possibleaura)

//We make magic weeds
/datum/ai_behavior/xeno/drone/HandleAbility()
	var/turf/T = get_turf(parentmob)

	if(!T.is_weedable())
    	return

	if(locate(/obj/effect/alien/weeds/node) in T)
		return 

	parentmob.visible_message("<span class='xenonotice'>\The [parentmob] regurgitates a pulsating node and plants it on the ground!</span>", \
		"<span class='xenonotice'>You regurgitate a pulsating node and plant it on the ground!</span>", null, 5)
	var/obj/effect/alien/weeds/node/N = new (parentmob.loc, src, parentmob)
	owner.transfer_fingerprints_to(parentmob)
	playsound(parentmob.loc, "alien_resin_build", 25)
	round_statistics.weeds_planted++
	return succeed_activate()
