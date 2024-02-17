extends Node

class_name Utilities


static func list_of_world_items(world_items:Array[Node]) -> String:
	var list_text: String = ""

	var items_to_stringify = []

	for world_item in world_items:
		if (world_item != null && !items_to_stringify.has(world_item)):
			items_to_stringify.append(world_item)

	var items_count  = items_to_stringify.size()
	var index = 0

	for item in items_to_stringify:
		if (index > 0):
			if (index >= (items_count - 1)):
				list_text = list_text + " and "
			else:
				list_text = list_text + ", "

		if item != null:
			list_text = list_text + item.get_status_description()
		index += 1
	return list_text
