//A subsystem that determines what the AI mobs do; currently handles movement

SUBSYSTEM_DEF(ai)
	name = "AI Controller"
	wait = 10
	var/list/aimobs = list()
	var/list/last_turf = list()
	var/list/current_run

/datum/controller/subsystem/ai/fire(resume = FALSE)
	if(!resume)
		current_run = aimobs.Copy()
	while(current_run.len)
		var/mob/living/carbon/Xenomorph/Drone/node/M = current_run[current_run.len]
		current_run.len--
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
