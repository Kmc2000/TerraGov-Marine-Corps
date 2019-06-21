/mob/living/carbon/xenomorph/drone/ai
	var/datum/ai_behavior/xeno/drone/ai_datum = new

/mob/living/carbon/xenomorph/drone/ai/Initialize()
	..()
	ai_datum.parentmob = src
	ai_datum.Init()

//An AI datum for drones; it makes weeds and pheromones

/datum/ai_behavior/xeno/drone
	var/datum/action/xeno_action/plant_weeds/plantweeds = new

/datum/ai_behavior/xeno/drone/Init()
	..()
	var/mob/living/carbon/xenomorph/drone/parentmob2 = parentmob
	parentmob2.current_aura = pick(list("recovery", "warding", "frenzy"))
	plantweeds.owner = parentmob2

//We make magic weeds
/datum/ai_behavior/xeno/drone/HandleAbility()
	..()
	plantweeds.action_activate()
	/*
	var/mob/living/carbon/xenomorph/drone/parentmob2 = parentmob
	var/turf/T = get_turf(parentmob2)

	if(!T.is_weedable())
		return

	if(locate(/obj/effect/alien/weeds/node) in T)
		return

	parentmob2.visible_message("<span class='xenonotice'>\The [parentmob2] regurgitates a pulsating node and plants it on the ground!</span>", \
		"<span class='xenonotice'>You regurgitate a pulsating node and plant it on the ground!</span>", null, 5)
	new/obj/effect/alien/weeds/node(parentmob2.loc)
	//var/obj/effect/alien/weeds/node/N = new (parentmob.loc, src, parentmob)
	playsound(parentmob2.loc, "alien_resin_build", 25)
	round_statistics.weeds_planted++
	return
	*/