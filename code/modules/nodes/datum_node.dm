//A datum that stores information about this node, the actual effect nodes have these

/datum/ai_node
    var/obj/effect/AINode/parentnode //The effect node this is attached to
    var/list/adjacent_nodes = list() // list of adjacent landmark nodes