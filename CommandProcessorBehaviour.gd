extends Node

@export var target_avatar:Avatar
@export var worldNode: Node2D

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
	
func moveto(locationName: String):
	print("Move command, moving to " + locationName)
	# let's find the location, and then ask the avatar to move to it
	var foundNode = worldNode.get_node(locationName)
	if foundNode == null:
		return "No destination found with name " + locationName
	
	target_avatar.moveto(foundNode.position)
	
	return "Moving"
	

	
	
func pickup(itemName: String):
	print("Picking up ", itemName)
	
	var foundNode = worldNode.get_node(itemName)
	if foundNode == null:
		return "No object found with name " + itemName
	
	if !foundNode.is_in_group("pickupable"):
		return itemName + " is not able to be picked up."
	
	if !target_avatar.close_enough_for_pickup(foundNode):
		return itemName + " is not close enough to be picked up."	
		
	worldNode.remove_child(foundNode)	
	target_avatar.pickup(foundNode)
	
func drop(itemName: String):
	if !target_avatar.is_holding_object(itemName):
		return itemName + " can't be dropped as it's not being held."
		
	var droppedNode:Node2D = target_avatar.drop(itemName)
	# move droppedNode into the front of the avatar
	worldNode.add_child(droppedNode)
	droppedNode.global_position = target_avatar.calculateDropPoint()
	
