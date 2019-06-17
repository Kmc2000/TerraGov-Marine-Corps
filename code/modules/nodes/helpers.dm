//A file containing helpers for nodes

//Returns a node that is in the direction of this node; must be in the src's adjacent node list
/obj/effect/AINode/proc/GetNodeInDirInAdj(dir)
	for(var/obj/effect/AINode/node in datumnode.adjacent_nodes)
		if(get_dir(src, node) == dir)
			return node
	return null

//The equivalent of get_step_towards but now for nodes; will NOT intelligently pathfind based on node weights or anything else
//Returns nothing if a suitable node in a direction isn't found, otherwise returns a node
/proc/get_node_towards(var/obj/effect/AINode/startnode, var/obj/effect/AINode/destination)
	var/list/possibledir = DiagonalToCardinal(get_dir(startnode, destination))
	var/list/possiblenodes = list(startnode.GetNodeInDirInAdj(possibledir[1]), startnode.GetNodeInDirInAdj(possibledir[2]))
	if(possiblenodes[1]) //See if the first index will give us a node
		return possiblenodes[1]
	if(possiblenodes[2]) //Try the other index; return FALSE if neither direction produces a node
		return possiblenodes[2]
	return null

//Returns a list of humans via get_dist and same z level method, very cheap compared to range()
/proc/cheap_get_humans_near(var/source, var/distance)
	var/list/listofhuman = list() //All humans in range
	for(var/human in GLOB.alive_human_list)
		if(get_dist(source, human) <= distance)
			listofhuman += human
	return listofhuman


/datum/ai_behavior/proc/GetRandomDestination() //Gets a new random destination that isn't it's current node
	destination_node = pick(GLOB.allnodes)
	while(destination_node == current_node) //Insurence
		destination_node = pick(GLOB.allnodes)
	//destination_node.color = "#FF69B4"
