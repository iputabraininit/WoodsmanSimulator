extends Node2D

@onready var smokeParticles:GPUParticles2D = $SmokeParticles
@onready var fireParticles:GPUParticles2D = $FireParticles

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	
func overlaps(to_be_dropped:Node2D) -> bool:
	var overlap_distance = global_position.distance_to(to_be_dropped.global_position)
	print(overlap_distance)
	return overlap_distance <= 100
	
func dropped_on(to_be_dropped:Node2D):
	if to_be_dropped.has_method("get_flammability"):
		smokeParticles.amount_ratio = 1
		fireParticles.emitting = true
		to_be_dropped.queue_free()
	else:
		add_child(to_be_dropped)
		
	
	
	#if to_be_dropped.has_method("flammable")
