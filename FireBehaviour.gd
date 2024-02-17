extends Node2D

@onready var smokeParticles:GPUParticles2D = $SmokeParticles
@onready var fireParticles:GPUParticles2D = $FireParticles

var fueled: bool = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_status_description() -> String:
	if fueled:
		return "a roaring campfire"
	else:
		return "a smouldering campfire"
	
func overlaps(to_be_dropped:Node2D) -> bool:
	var overlap_distance = global_position.distance_to(to_be_dropped.global_position)
	print(overlap_distance)
	return overlap_distance <= 100
	
func dropped_on(to_be_dropped:Node2D):
	if to_be_dropped.has_method("get_flammability"):
		smokeParticles.amount_ratio = 1
		fireParticles.emitting = true
		to_be_dropped.queue_free()
		fueled = true
	else:
		add_child(to_be_dropped)
		

