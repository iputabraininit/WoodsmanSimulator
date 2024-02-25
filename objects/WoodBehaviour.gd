extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_flammability() -> int:
	return 100

func get_status_description() -> String:
	return "a log"

func use(target:Node) -> String:
	if !target.has_method("dropped_on"):
		return "[Error] target is not usable with log"

	# using a log on a target is the equivelent of dropping it
	target.dropped_on(self)
	return "used"
