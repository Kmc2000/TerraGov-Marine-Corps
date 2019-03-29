//It's like regular xenomorph but now it uses nodes

/mob/living/carbon/Xenomorph/Drone/node
	var/obj/effect/landmark/AINode/current_node //Current node it's at
	var/obj/effect/landmark/AINode/next_node //Node it wants to get to next
	var/obj/effect/landmark/AINode/destination_node //Node it wants to get to after traveling VIA next_node


/mob/living/carbon/Xenomorph/Drone/node/Initialize()
	..()
	for(var/obj/effect/landmark/AINode/node in range(4))
		if(node)
			current_node = node
			forceMove(current_node.loc)
			break
	destination_node = pick(AINodes)
	while(destination_node == current_node)
		destination_node = pick(AINodes) //Insurence
	destination_node.color = "#FF69B4" //Pink is goal
	//current_node.color = "#800080" //Purple is start
	next_node = current_node.GetNodeInDirInAdj(pick(DiagonalToCardinal(get_dir(src, destination_node))))
	world << next_node
	ConsiderMovement()

/mob/living/carbon/Xenomorph/Drone/node/proc/ConsiderMovement()

	var/adirection = get_dir(src, get_step_to(src, next_node))
	if(IsDiagonal(adirection)) //It's a diagonal, convert to cardinal and pick a random one of the two
		step(src, pick(DiagonalToCardinal(adirection)))
	else
		step(src, adirection)

	if(loc == next_node.loc && loc != destination_node.loc) //Made it to the next node
		current_node = next_node
		if(loc != destination_node.loc)
			next_node = current_node.GetNodeInDirInAdj(pick(DiagonalToCardinal(get_dir(src, destination_node))))

	if(loc == destination_node.loc) //We made it at our destination; reset path and get a new random node
		destination_node.color = initial(destination_node.color)
		destination_node = pick(AINodes)
		current_node = next_node
		while(destination_node == current_node)
			destination_node = pick(AINodes) //Insurence
		destination_node.color = "#FF69B4" //Pink is goal
		//current_node.color = "#800080" //Purple is start
		next_node = current_node.GetNodeInDirInAdj(pick(DiagonalToCardinal(get_dir(src, destination_node))))

	addtimer(CALLBACK(src, .proc/ConsiderMovement), 1)
	return
