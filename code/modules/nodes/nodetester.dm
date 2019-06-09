//It's like regular xenomorph but now it uses nodes, used for testing the pathfinding

/mob/living/carbon/xenomorph/Drone/node
	var/datum/ai_behavior/xeno/ai_datum = new//datum/ai_behavior/ai_datum(src)

/mob/living/carbon/xenomorph/Drone/node/Initialize()
	ai_datum.parentmob = src
	ai_datum.Init()
	..()

	/*		break
	GetRandomDestination()
	var/nextnode = current_node.GetNodeInDirInAdj(pick(DiagonalToCardinal(get_dir(src, destination_node))))
	if(nextnode)
		next_node = nextnode
	*/
	//ConsiderMovement()

/*
/mob/living/carbon/xenomorph/Drone/node/proc/DealWithObstruct()
	var/turf/turf = get_step_towards(src, ai_datum.next_node)
	for(var/obj/machinery/door/airlock/door in turf)
		if(door && door.density)
			door.open(1)

/mob/living/carbon/xenomorph/Drone/node/proc/DoMove()
	walk_to(src, ai_datum.next_node)
	if(get_dist(src, ai_datum.next_node) < 2)
		next_node.color = initial(color)
		current_node = ai_datum.next_node
		next_node = pick(ai_datum.current_node.datumnode.adjacent_nodes)
		next_node.color = "#FF69B4"

/mob/living/carbon/xenomorph/Drone/node/proc/ConsiderMovement()
	//if(!next_node || next_node == current_node)
	//	next_node = current_node.GetNodeInDirInAdj(pick(DiagonalToCardinal(get_dir(src, destination_node))))
	walk_to(src, next_node, 0, movement_delay() + 3)
	for(var/obj/machinery/door/airlock/adoor in range(1))
		if(adoor)
			adoor.open(1)
	//forceMove(next_node.loc)
	if(get_dist(src, next_node) < 2)
		next_node.color = initial(color)
		current_node = next_node
		next_node = pick(current_node.datumnode.adjacent_nodes)
		next_node.color = "#FF69B4"
	/*
	if(current_node == destination_node)
		destination_node.color = initial(color)
		GetRandomDestination()
	*/

	addtimer(CALLBACK(src, .proc/ConsiderMovement), 1)
	return
*/
