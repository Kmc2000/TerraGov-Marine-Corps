/*
Datums that represent an AI mind and it's way of doing various things like movement or handling a gun
Base datums for stuff like humans or xenos have possible actions to do as well as attitudes
*/

//The most basic of AI; can pathfind to a turf
/datum/ai_behavior

	var/mob/living/carbon/parentmob //The mob this is attached to; must be updated for inheritence or else things can break
	var/turf/destinationturf //Turf that we want to get to
	var/turf/lastturf //If this is the same as parentmob turf at HandleMovement() then we made no progress in moving, do HandleObstruction from there
	var/obj/effect/AINode/current_node //Current node the parentmob is at
	var/obj/effect/AINode/next_node //Node the parent mob wants to get to
	var/obj/effect/AINode/destination_node //Node that parent mob wants to get to

/datum/ai_behavior/New()
	..()
	SSai.aidatums += src
	for(var/obj/effect/AINode/node in range(4))
		if(node)
			current_node = node
			parentmob.forceMove(current_node.loc)
			next_node = pick(current_node.datumnode.adjacent_nodes)
			next_node.color = "#FF69B4"

/datum/ai_behavior/proc/Process() //Processes and updates things
	HandleMovement()

//We do some moving to a destination
/datum/ai_behavior/proc/HandleMovement()
	walk_to(parentmob, next_node)
	if(get_dist(parentmob, next_node) < 2)
		NextNodeReached()
	if(lastturf == parentmob.loc) //No change in turfs since last AI process update, switch to more intelligent pathfinding for a bit
		HandleObstruction()
	else //Should be alright going with dumb AI
		walk_towards(parentmob, destinationturf, parentmob.movement_delay())

//We reached to one of the nodes on the way to destination node, if it is destination node lets get a new destination
/datum/ai_behavior/proc/NextNodeReached()
	current_node = next_node
	if(next_node == destination_node)
		GetRandomDestination()
	next_node.color = initial(next_node.color)
	var/possiblenode = get_node_towards(current_node, destination_node)
	if(possiblenode)
		next_node = possiblenode

/datum/ai_behavior/proc/DestinationReached() //We reached our destination, let's go to another adjacent node
	GetRandomDestination()

/datum/ai_behavior/proc/HandleObstruction() //If HandleMovement fails, do some HandleObstruction()
	//In this case, we switch to intelligent pathfinding to move around the obstacle until HandleMovement() gets called again
	walk_to(parentmob, destinationturf, parentmob.movement_delay())

/datum/ai_behavior/proc/GetRandomDestination() //Gets a new random destination that isn't it's current node
	destination_node = pick(GLOB.allnodes)
	while(destination_node == current_node)
		destination_node = pick(GLOB.allnodes) //Insurence
	destination_node.color = "#FF69B4"