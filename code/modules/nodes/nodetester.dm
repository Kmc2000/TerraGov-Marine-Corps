//It's like regular xenomorph but now it uses nodes, used for testing the pathfinding

/mob/living/carbon/Xenomorph/Drone/node
	var/obj/effect/AINode/current_node //Current node it's at
	var/obj/effect/AINode/next_node //Node it wants to get to next
	var/obj/effect/AINode/destination_node //Node it wants to get to after traveling VIA next_node

/mob/living/carbon/Xenomorph/Drone/node/Initialize()
	..()
	for(var/obj/effect/AINode/node in range(4))
		if(node)
			current_node = node
			forceMove(current_node.loc)
			break
	GetRandomDestination()
	var/nextnode = current_node.GetNodeInDirInAdj(pick(DiagonalToCardinal(get_dir(src, destination_node))))
	if(nextnode)
		next_node = nextnode
	ConsiderMovement()

/mob/living/carbon/Xenomorph/Drone/node/proc/ConsiderMovement()
	if(!next_node || next_node == current_node)
		next_node = current_node.GetNodeInDirInAdj(pick(DiagonalToCardinal(get_dir(src, destination_node))))
	forceMove(next_node.loc)
	current_node = next_node
	if(current_node == destination_node)
		destination_node.color = initial(color)
		GetRandomDestination()

	addtimer(CALLBACK(src, .proc/ConsiderMovement), 3)
	return

/mob/living/carbon/Xenomorph/Drone/node/proc/GetRandomDestination() //Gets a new random destination that isn't it's current node
	destination_node = pick(GLOB.allnodes)
	while(destination_node == current_node)
		destination_node = pick(GLOB.allnodes) //Insurence
	destination_node.color = "#FF69B4"