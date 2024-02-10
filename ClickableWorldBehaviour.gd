extends Node2D

@export var agent:Avatar
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func _on_click_layer_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		print("click, click ", event.position)
		agent.moveto(event.position)
