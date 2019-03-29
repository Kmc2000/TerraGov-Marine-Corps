//The actual node; really only to hold the ai_node datum that stores all the information

/obj/effect/AINode //A effect that has a ai_node datum in it, used by AIs to pathfind over long distances as well as knowing what's happening at it
	name = "AI Node"
	icon_state = "x4" //Pure white 'X'
	var/datum/ai_node/datumnode = new/datum/ai_node() //Stores things about the AI node
	var/list/mob/living/detectedmobs = list() //All hostile mobs that were reported here
	var/lastscout = 0 //Last time this was scouted

/obj/effect/AINode/Initialize() //Add ourselve to the global list of nodes
	..()
	datumnode.parentnode = src
	GLOB.allnodes += src

/obj/effect/AINode/proc/MakeAdjacents()
	for(var/obj/effect/AINode/node in GLOB.allnodes)
		if((node != src) && (get_dir(src, node) in GLOB.cardinals) && (get_dist(src, node) < 3))
			var/IsClearPath = TRUE //If a getline() to the node is nondense at all
			var/list/turf/turfs = getline(src, node)
			for(var/turf/T in turfs)
				if(T.density)
					IsClearPath = FALSE
					break
			if(IsClearPath)
				datumnode.adjacent_nodes |= node //Probably going to get expensive with the sanity |=, will have to test out later

/obj/effect/AINode/debug //A debug version of the AINode; makes it visible to allow for easy var editing

/obj/effect/AINode/debug/Initialize()
	..()
	alpha = 120
	invisibility = 0
	color = "#ffffff" //Color coding yo; white is 'unkonwn', green is 'safe' and red is 'danger'
