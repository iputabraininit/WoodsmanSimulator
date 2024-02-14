extends Node

@export var target_avatar:Avatar
@export var world_items_node: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_command(command, arguments):
	print("Command processor recieved ", command, " ", arguments)
	var expression = Expression.new()
	
	for i in arguments.size():
		arguments[i] = "'" + arguments[i] + "'"
		
	var joinedArguments = ", ".join(arguments)
	var fullCommandToExecute = command + "(" + joinedArguments + ")"
	expression.parse(fullCommandToExecute)
	
	print ("executing : ", fullCommandToExecute)
	var result = expression.execute([], self)
	print(result)
	
func moveto(locationName: String) -> String:
	print("Move command, moving to " + locationName)
	# let's find the location, and then ask the avatar to move to it
	var foundNode = world_items_node.get_node(locationName)
	if foundNode == null:
		return "No destination found with name " + locationName
	
	target_avatar.moveto(foundNode.position)
	
	return "Moving"

func pickup(itemName: String) -> String:
	print("Picking up ", itemName)
	
	var foundNode = world_items_node.get_node(itemName)
	if foundNode == null:
		return "No object found with name " + itemName
	
	if !foundNode.is_in_group("pickupable"):
		return itemName + " is not able to be picked up."
	
	if !target_avatar.close_enough_for_interaction(foundNode):
		return itemName + " is not close enough to be picked up."	
		
	world_items_node.remove_child(foundNode)	
	target_avatar.pickup(foundNode)
	return itemName + "picked up"
	
func drop(itemName: String):
	if !target_avatar.is_holding_object(itemName):
		return itemName + " can't be dropped as it's not being held."
		
	var droppedNode:Node2D = target_avatar.drop(itemName)
	# loop through all world items and see if any object is a drop target, and the
	droppedNode.global_position = target_avatar.calculateDropPoint()

	var can_drop_on_on_world_item: bool = false
	var all_world_items: Array[Node] = world_items_node.get_children()
	var target_item = null

	for world_item in all_world_items:
		if (world_item.has_method("overlaps")):
			if (world_item.overlaps(droppedNode)):
				target_item = world_item
				can_drop_on_on_world_item = true
				print("can drop " + itemName + " on " + world_item.name)
				break

	# item we drop intersects then tell that target that it was dropped on
	# otherwise, add it to the world
	if can_drop_on_on_world_item:
		target_item.dropped_on(droppedNode)
		print("Dropped " + itemName + " on something in the world")
	else:
		world_items_node.add_child(droppedNode)



func use(heldItemName: String, targetWorldItemName: String) -> String:
	var foundWorldNode = world_items_node.get_node(targetWorldItemName)
	if foundWorldNode == null:
		return "No object found with name " + heldItemName

	if (!target_avatar.close_enough_for_interaction(foundWorldNode)):
		return targetWorldItemName + " is not close enough to be interacted with"

	if (!target_avatar.is_holding_object(heldItemName)):
		return heldItemName + "cannot be used as it's not being held."

	return target_avatar.use_held_item(heldItemName, foundWorldNode)




