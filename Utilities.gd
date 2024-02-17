extends Node

class_name Utilities


static func list_of_world_items(world_items:Array[Node]) -> String:
	var list_text: String = ""
	var items_count       = world_items.size()
	var index = 0

	for item in world_items:
		if (index > 0):
			if (index >= (items_count - 1)):
				list_text = list_text + " and "
			else:
				list_text = list_text + ", "

		list_text = list_text + item.get_status_description()
		index += 1
	return list_text
