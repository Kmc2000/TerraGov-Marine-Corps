/datum/action_state
	var/datum/ai_behavior/parent_ai

/datum/action_state/proc/Process() //Called from the datum ai process

/datum/action_state/proc/CanComplete() //If we can complete the task

/datum/action_state/move_to //Generic move to a thing, sets atomtowalkto for ai behavior datums

/datum/action_state/move_to/node //Generic move to a thing but now specifically nodes

/datum/action_state/move_to/node/Process()
