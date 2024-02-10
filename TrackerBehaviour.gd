extends Node2D

@export var target:Node2D
@onready var trackingArrow:Node2D = $Transformer

var _previousTargetPosition = Vector2(0, 0)
var _movementVector = Vector2(0, 1)

func _ready():
	_previousTargetPosition = target.global_position
	pass # Replace with function body.


func _process(delta):
	if (_previousTargetPosition == target.global_position):
		return

	_movementVector = (target.global_position - _previousTargetPosition).normalized()
	_previousTargetPosition = target.global_position
	global_position = target.global_position
	
	var arrowRotation: float = Vector2.UP.angle_to(_movementVector)
	
	trackingArrow.set_rotation(arrowRotation)
