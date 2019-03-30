//A datum that stores information about this node, the actual nodes have these

/datum/ai_node
    var/obj/effect/AINode/parentnode //The node this is attached to
    var/list/adjacent_nodes = list() // list of adjacent landmark nodes
    var/list/weights //A list of associative values for various weights
