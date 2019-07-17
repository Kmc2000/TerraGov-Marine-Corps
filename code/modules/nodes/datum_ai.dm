/*
Datums that represent an AI mind and it's way of doing various things like movement or handling a gun
Base datums for stuff like humans or xenos have possible actions to do as well as attitudes
*/

#define ENEMY_PRESENCE 1
#define DANGER_SCALE 2

//The most basic of AI; can pathfind to a turf and path around objects in it's path if needed to
/datum/ai_behavior

	var/mob/living/carbon/parentmob //The mob this is attached to; must be updated for inheritence or else things can break
	var/turf/destinationturf //Turf that we want to get to
	var/turf/lastturf //If this is the same as parentmob turf at HandleMovement() then we made no progress in moving, do HandleObstruction from there
	var/obj/effect/AINode/current_node //Current node the parentmob is at
	var/atom/atomtowalkto //What thing we should be moving towards
	var/obj/effect/AINode/destination_node
	var/move_delay = 0 //The next world.time we can do a move at

/datum/ai_behavior/New()
	..()
	SSai.aidatums += src
	SSai_movement.toprocess += src

/datum/ai_behavior/proc/Init() //Bandaid solution for initializing things
	for(var/obj/effect/AINode/node in range(4))
		if(node)
			current_node = node
			parentmob.forceMove(current_node.loc)
			atomtowalkto = pick(current_node.datumnode.adjacent_nodes) //get_node_towards(current_node, destination_node)
		break
	if(!current_node)
		qdel(src)

/datum/ai_behavior/proc/Process() //Processes and updates things
	if(!atomtowalkto)
		atomtowalkto = pick(current_node.datumnode.adjacent_nodes)
	if(get_dist(parentmob, atomtowalkto) < 2)
		TargetReached()
	if(get_dist(parentmob, atomtowalkto) > 14)
		atomtowalkto = pick(current_node.datumnode.adjacent_nodes)
	lastturf = parentmob.loc

//We reached to one of the nodes on the way to destination node, if it is destination node lets get a new destination
/datum/ai_behavior/proc/TargetReached()
	if(istype(atomtowalkto, /obj/effect/AINode))
		current_node = atomtowalkto
	atomtowalkto = pick(current_node.datumnode.adjacent_nodes)

/datum/ai_behavior/proc/DestinationReached() //We reached our destination, let's go to another adjacent node
	GetRandomDestination()

//Comes with the turf of the tile it's going to
/datum/ai_behavior/proc/HandleObstruction() //If HandleMovement fails, do some HandleObstruction()
