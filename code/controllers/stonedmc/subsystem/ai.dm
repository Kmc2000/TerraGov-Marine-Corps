//A subsystem that determines what the AI mobs do; currently handles movement

SUBSYSTEM_DEF(ai)
	name = "AI Controller"
	wait = 1
	var/list/aidatums = list()
	var/list/last_turf = list()
	var/list/current_run

/datum/controller/subsystem/ai/fire(resume = FALSE)
	if(!resume)
		current_run = aidatums.Copy()
	while(current_run.len)

		var/datum/ai_behavior/aidatum = current_run[current_run.len]
		current_run.len--
		aidatum.Process()
		if(TICK_CHECK)
			return

		/*
		var/mob/living/carbon/Xenomorph/Drone/node/ai = current_run[current_run.len]
		if(M.loc != last_turf[M])
			last_turf[M] = M.loc
			M.DoMove()
			if(TICK_CHECK)
				return
			continue
		M.DealWithObstruct()
		M.DoMove()
		if(TICK_CHECK)
			return
		*/
