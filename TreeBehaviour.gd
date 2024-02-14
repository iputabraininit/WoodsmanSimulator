extends Node2D

var _health: int = 100
@export var wood_scene: PackedScene
@export var world_items_node: Node2D 

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func damage(amount:int):
	_health -= amount
	if (_health <= 0):
		# spawn a stump
		var wooden_log = wood_scene.instantiate()
		wooden_log.global_position = global_position
		
		world_items_node.add_child(wooden_log)
		
		# spawn a log
		queue_free()
