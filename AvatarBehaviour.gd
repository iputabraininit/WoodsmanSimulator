extends CharacterBody2D
class_name Avatar

@onready var _navigation_agent = $NavigationAgent2D
@export var speed: int = 20

var _moving_to_destination: bool = false
var _pickedUpObjects:Array[Node] = []
var _previousTargetPosition = Vector2(0, 0)
var _movementVector = Vector2(0, 1)

var PICKUP_DISTANCE = 100

signal arrived_at_destination

# Called when the node enters the scene tree for the first time.
func _ready():
	_navigation_agent.path_desired_distance = 4.0
	_navigation_agent.target_desired_distance = PICKUP_DISTANCE - 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta) -> void:
	if !_moving_to_destination:
		return

	_movementVector = (global_position - _previousTargetPosition).normalized()
	_previousTargetPosition = global_position
	

	if _navigation_agent.is_target_reached():
		print("Target reached")
		_moving_to_destination = false
		arrived_at_destination.emit()
		return
	
	var move_direction: Vector2 = global_position.direction_to(_navigation_agent.get_next_path_position()).normalized()
	velocity = move_direction * speed

	move_and_slide()


func moveto(destination:Vector2):
	_navigation_agent.target_position = destination
	_moving_to_destination = true
	
func close_enough_for_interaction(itemToPickUp: Node2D) -> bool:
	var distance = global_position.distance_to(itemToPickUp.global_position) 	
	return distance <= PICKUP_DISTANCE
		
	
func pickup(toPickUp:Node2D):
	add_child(toPickUp)
	toPickUp.position = Vector2(0, 0)
	if !_pickedUpObjects.has(toPickUp):
		_pickedUpObjects.push_back(toPickUp)
	
func is_holding_object(nameToCheck:String) -> bool:
	var foundChildNode: Node = get_node(nameToCheck)
	return foundChildNode != null
	
func drop(toDrop:String) -> Node2D:
	var childToDrop = get_node(toDrop) 
	remove_child(childToDrop)
	return childToDrop
	
func calculateDropPoint():
	var arrowRotation = Vector2(0, PICKUP_DISTANCE - 10).angle_to(_movementVector)
	return Vector2(0, PICKUP_DISTANCE - 10).rotated(arrowRotation) + global_position

func use_held_item(heldItemName:String, targetObject:Node2D) -> String:
	var itemToUse = get_node(heldItemName)

	if (!itemToUse.has_method("use")):
		return ("[Error] item " + heldItemName + "does not have a use method")

	itemToUse.use(targetObject) # using some duck-typing here

	return itemToUse.name + " used on " + targetObject.name

func get_holding_text() -> String:
	if (_pickedUpObjects.is_empty()):
		return "nothing"
	else:
		return Utilities.list_of_world_items(_pickedUpObjects)

