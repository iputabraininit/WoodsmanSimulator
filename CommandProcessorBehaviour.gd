extends Node

@export var target_avatar:Avatar
@export var world_items_node: Node2D

@export var world_scene: PackedScene

var _unpacked_world: Node2D

# Sent out when this command processor has finished executing a given command
signal on_command_response(response: String)

func _ready():
	pass

func _process(delta):
	pass

# A new command could have come in from the UI, or Websocket
# This script should be agnostic on where the command has come from.
func _on_new_command(command, arguments):
#	print("Command processor recieved ", command, " ", arguments)
	var expression = Expression.new()
	
	for i in arguments.size():
		arguments[i] = "'" + arguments[i] + "'"
		
	var joinedArguments = ", ".join(arguments)
	var fullCommandToExecute = command + "(" + joinedArguments + ")"
	expression.parse(fullCommandToExecute)

	var result = await expression.execute([], self)

	on_command_response.emit(result)
	
func moveto(locationName: String) -> String:
	print("Moving to ", locationName)
	# let's find the location, and then ask the avatar to move to it
	var foundNode = world_items_node.get_node(locationName)
	if foundNode == null:
		return "No destination found with name " + locationName
	
	target_avatar.moveto(foundNode.position)
	await target_avatar.arrived_at_destination

	return "Arrived at " + locationName

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
	return itemName + " picked up"
	
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

func reset(epoch_title: String):
	pass
	# clear the current scene
	# unpack the world,
	# get the avatar and root out of the unpacked scene
	# send out a signal the iteration got reset for display

func status() -> String:
	var status_text: String      = "You are in a wooded clearing. There is "
	var world_items: Array[Node] = world_items_node.get_children()

	status_text = status_text + Utilities.list_of_world_items(world_items)

	status_text = status_text + " here. You are holding " + target_avatar.get_holding_text() + "."

	return status_text


