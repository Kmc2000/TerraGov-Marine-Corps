SUBSYSTEM_DEF(nodes)
	name = "Nodes"
	init_order = INIT_ORDER_NODES
	flags = SS_NO_FIRE

/datum/controller/subsystem/nodes/Initialize()
	InitAllAdjacent()

//Call this to manually make adjacencies
/datum/controller/subsystem/nodes/proc/InitAllAdjacent()
	for(var/obj/effect/AINode/nodes in GLOB.allnodes)
		nodes.MakeAdjacents()
	return ..()