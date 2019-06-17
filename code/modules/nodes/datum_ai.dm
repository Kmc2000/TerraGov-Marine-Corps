/*
Datums that represent an AI mind and it's way of doing various things like movement or handling a gun
Base datums for stuff like humans or xenos have possible actions to do as well as attitudes
*/

//The most basic of AI; can pathfind to a turf and path around objects in it's path if needed to
/datum/ai_behavior

	var/mob/living/carbon/parentmob //The mob this is attached to; must be updated for inheritence or else things can break
	var/turf/destinationturf //Turf that we want to get to
	var/turf/lastturf //If this is the same as parentmob turf at HandleMovement() then we made no progress in moving, do HandleObstruction from there
	var/obj/effect/AINode/current_node //Current node the parentmob is at
	//var/obj/effect/AINode/next_node
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
			//GetRandomDestination()
			atomtowalkto = pick(current_node.datumnode.adjacent_nodes) //get_node_towards(current_node, destination_node)
			//next_node.color = "#FF6900" //Orange
		break
	if(!current_node)
		qdel(src)

/datum/ai_behavior/proc/Process() //Processes and updates things
	if(get_dist(parentmob, atomtowalkto) < 2)
		TargetReached()
	lastturf = parentmob.loc

//We do some moving to a destination
/*
/datum/ai_behavior/proc/ProcessMove()
	if(get_dist(parentmob, atomtowalkto) < 2)
		TargetReached()
	else
		if(parentmob.loc == lastturf) //No change in turfs since last AI process update, switch to more intelligent pathfinding for a bit
			HandleObstruction()
		else //Should be alright going with dumb AI
			walk_towards(parentmob, atomtowalkto, parentmob.movement_delay() + (2 + CONFIG_GET(number/movedelay/run_delay)))
*/

//We reached to one of the nodes on the way to destination node, if it is destination node lets get a new destination
/datum/ai_behavior/proc/TargetReached()
	if(istype(atomtowalkto, /obj/effect/AINode))
		current_node = atomtowalkto
	//if(atomtowalkto == destination_node)
	//	GetRandomDestination()
	atomtowalkto = pick(current_node.datumnode.adjacent_nodes)
	/*
	next_node.color = initial(next_node.color)
	var/possiblenode = get_node_towards(current_node, destination_node)
	if(possiblenode)
		next_node = possiblenode
		next_node.color = "#FF6900"
	else
		next_node = pick(current_node.datumnode.adjacent_nodes)
		next_node.color = "#FF6900"
	*/


/datum/ai_behavior/proc/DestinationReached() //We reached our destination, let's go to another adjacent node
	GetRandomDestination()

//Comes with the turf of the tile it's going to
/datum/ai_behavior/proc/HandleObstruction() //If HandleMovement fails, do some HandleObstruction()
	//In this case, we switch to intelligent pathfinding to move around the obstacle until HandleMovement() gets called again
	//walk_to(parentmob, atomtowalkto, 0, parentmob.movement_delay() + (2 + CONFIG_GET(number/movedelay/run_delay)))

//Basic datum AI for a xeno; ability to use acid on obstacles if valid as well as attack obstacles

/datum/ai_behavior/xeno
	//mob/living/carbon/Xenomorph/parentmob //Retypecast

/datum/ai_behavior/xeno/Init()
	..()
	parentmob.a_intent = INTENT_HARM

/datum/ai_behavior/xeno/Process()
	..()
	if(prob(25))
		HandleAbility()

/datum/ai_behavior/xeno/proc/HandleAbility()
	var/list/somehumans = cheap_get_humans_near(parentmob, 14) //7 or less distance required to find a human
	for(var/human in somehumans)
		atomtowalkto = human
		break

/datum/ai_behavior/xeno/HandleObstruction()
	var/mob/living/carbon/xenomorph/parentmob2 = parentmob
	//walk_to(parentmob2, atomtowalkto, 0, parentmob2.movement_delay() + (2 + CONFIG_GET(number/movedelay/run_delay)))

	for(var/obj/machinery/door/airlock/door in range(1, parentmob))
		if(door.density && !door.welded)
			door.open()

	for(var/turf/closed/probawall in range(1, parentmob))
		if(probawall.current_acid)
			return
		if(!probawall.acid_check(/obj/effect/xenomorph/acid/strong))
			var/obj/effect/xenomorph/acid/strong/newacid = new /obj/effect/xenomorph/acid/strong(get_turf(probawall), probawall)
			newacid.icon_state += "_wall"
			newacid.acid_strength = 0.1 //Very fast acid
			probawall.current_acid = newacid

	for(var/obj/machinery/machin in range(1, parentmob))
		if(probawall.current_acid)
			return
		if(!probawall.acid_check(/obj/effect/xenomorph/acid/strong))
			var/obj/effect/xenomorph/acid/strong/newacid = new /obj/effect/xenomorph/acid/strong(get_turf(probawall), probawall)
			newacid.icon_state += "_wall"
			newacid.acid_strength = 0.1 //Very fast acid
			probawall.current_acid = newacid

	if(parentmob2.next_move < world.time) //If we can attack again or not
		for(var/obj/structure/struct in range(1, parentmob))
			struct.attack_alien(parentmob)
			parentmob2.next_move = parentmob2.xeno_caste.attack_delay + world.time
			return
