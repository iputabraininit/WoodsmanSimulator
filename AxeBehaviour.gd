extends Node2D

const DAMAGE: int = 500

func _ready():
	pass # Replace with function body.

func use(target:Node) -> String:
	if !target.has_method("damage"):
		return "target is not damageable"

	# TODO pass in what direction the damage came from
	target.damage(DAMAGE)
	return "damaged"
