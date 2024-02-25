extends Node2D

const DAMAGE: int = 500

func _ready():
	pass # Replace with function body.

func use(target:Node) -> String:
	if !target.has_method("damage"):
		return "[Error] target is not damageable"

	target.damage(DAMAGE)
	return "damaged"

func get_status_description() -> String:
	return "an axe"
