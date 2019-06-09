/mob/living/carbon/xenomorph/Drone/ai
	var/datum/ai_behavior/xeno/drone/ai_datum = new

//An AI datum for drones; it makes weeds and pheromones

/datum/ai_behavior/xeno/drone
	//parentmob = new/mob/living/carbon/Xenomorph/Drone()
	//mob/living/carbon/Xenomorph/Drone/parentmob //Retypecast

/datum/ai_behavior/xeno/drone/Init()
	..()
	var/mob/living/carbon/Xenomorph/Drone/parentmob2 = parentmob
	parentmob2.current_aura = pick(list("recovery", "warding", "frenzy"))

//We make magic weeds
/datum/ai_behavior/xeno/drone/HandleAbility()
	var/mob/living/carbon/Xenomorph/Drone/parentmob2 = parentmob
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
