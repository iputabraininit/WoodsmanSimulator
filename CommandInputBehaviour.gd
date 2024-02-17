extends LineEdit

signal on_new_command(command:String, arguments: Array)
# Called when the node enters the scene tree for the first time.
func _ready():
	text_submitted.connect(promptTextChanged)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func promptTextChanged(newText):
	var splitCommands = newText.split(" ",  false)
	
	clear()
	var command = splitCommands[0]
	var arguments = splitCommands.slice(1)
	
	on_new_command.emit(command, arguments)
