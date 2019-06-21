/mob/living/carbon/xenomorph/runner/ai
	var/datum/ai_behavior/xeno/runner/ai_datum = new

/mob/living/carbon/xenomorph/runner/ai/Initialize()
	..()
	ai_datum.parentmob = src
	ai_datum.Init()

//Uses runner abilities
/datum/ai_behavior/xeno/runner
	var/datum/action/xeno_action/activable/pounce/pounce = new

/datum/ai_behavior/xeno/runner/Init()
	..()
	pounce.owner = parentmob

/datum/ai_behavior/xeno/runner/HandleAbility()
	..()
	if(istype(atomtowalkto, /mob/living/carbon/human) && pounce.can_use_ability())
		pounce.use_ability(atomtowalkto)
