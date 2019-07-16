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

//Basic datum AI for a xeno; ability to use acid on obstacles if valid as well as attack obstacles
/datum/ai_behavior/xeno

/datum/ai_behavior/xeno/Init()
	..()
	parentmob.a_intent = INTENT_HARM

//Below proc happens everyone one second
/datum/ai_behavior/xeno/Process()
	..()
	HandleAbility()

//If it's a human we slap it, otherwise continue the random node traveling
/datum/ai_behavior/xeno/TargetReached()
	if(istype(atomtowalkto, /obj/effect/AINode))
		current_node = atomtowalkto
		var/list/humans_nearby = cheap_get_humans_near(parentmob, 14) //14 or less distance required to find a human	//While we're here let's update the amount of enemies here
		current_node.datumnode.set_weight(ENEMY_PRESENCE, humans_nearby.len)
		if(current_node.datumnode.weight_not_null(ENEMY_PRESENCE)) //If it turns out that it had enemies, we should make sure it's in a list of notable nodes
			current_node.add_to_notable_nodes(ENEMY_PRESENCE)
		else
			current_node.remove_from_notable_nodes(ENEMY_PRESENCE)

	if(istype(atomtowalkto, /mob/living/carbon/human))
		var/mob/living/carbon/human/dammhuman = atomtowalkto
		if(dammhuman.stat != DEAD)
			var/mob/living/carbon/xenomorph/parentmob2 = parentmob
			if(parentmob2.next_move < world.time)
				atomtowalkto.attack_alien(parentmob2)
				parentmob2.next_move = parentmob2.xeno_caste.attack_delay + world.time
		else
			..() //We go to a random node now

/datum/ai_behavior/xeno/proc/HandleAbility()
	var/list/somehumans = cheap_get_humans_near(parentmob, 14) //14 or less distance required to find a human
	for(var/human in somehumans)
		atomtowalkto = human
		break

/datum/ai_behavior/xeno/HandleObstruction()
	var/mob/living/carbon/xenomorph/parentmob2 = parentmob

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

	if(parentmob2.next_move < world.time) //If we can attack again or not
		for(var/obj/structure/struct in range(1, parentmob))
			if(struct.attack_alien(parentmob))
				parentmob2.next_move = parentmob2.xeno_caste.attack_delay + world.time
				return
		for(var/obj/machinery/machin in range(1, parentmob))
			if(machin.attack_alien(parentmob))
				parentmob2.next_move = parentmob2.xeno_caste.attack_delay + world.time
				return
