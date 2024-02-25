extends Node

const PORT = 50102
var tcp_server := TCPServer.new()
var socket := WebSocketPeer.new()

signal on_new_command_recieved(command:String, arguments:Array[String]) 

func _ready():
	if tcp_server.listen(PORT) != OK:
		log_message("Unable to start server")
		set_process(false)
	else:
		log_message("Websocket server listening")


func _process(_delta):
	while tcp_server.is_connection_available():
		var conn: StreamPeerTCP = tcp_server.take_connection()
		assert(conn != null)
		socket.accept_stream(conn)

	socket.poll()

	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var payload = socket.get_packet().get_string_from_ascii()
			print(payload)
			var splitCommands = payload.split(" ",  false)
			var command = splitCommands[0]
			var arguments = " ".join(splitCommands.slice(1))
			on_new_command_recieved.emit(command, arguments)

			
func log_message(message):
	var time = " %s " % Time.get_time_string_from_system()
	print(time + message)
	
func on_command_response(response:String):
	socket.send_text(response)
	
	
func _exit_tree():
	socket.close()
	tcp_server.stop()
