//An attempt to see if it's possible to do tile by tile movement without the usage of timers or spawns VIA Entered()
//If it doesn't work it's probably cause of animation gliding being annoying and calling Entered() before animation finishes

//Moves in a random cardinal direction every time the parent has Entered() called
/datum/component/ai

/datum/component/ai/Initialize()
	if(!ismovableatom(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/do_move)

/datum/component/ai/proc/do_move()
	step(parent, pick(CARDINAL_DIRS())

/mob/living/carbon/Xenomorph/drone/componenttest

/mob/living/carbon/Xenomorph/drone/componenttest/Initialize()
	. = ..()
	AddComponent(/datum/component/ai)
	step(parent, pick(CARDINAL_DIRS)) //Move once to get the Entered() loop going