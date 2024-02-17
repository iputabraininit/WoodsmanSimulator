extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_ui_command(command, arguments:Array[String]):
	append_text("\n%s %s" % [command, " ".join(PackedStringArray(arguments)) ])

func on_command_response(response:String):
	append_text("\n[color=green]%s[/color]" % [response])
