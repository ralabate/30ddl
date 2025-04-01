class_name Log


static func info(message: String) -> void:
	# TODO: This will only work in DEBUG.
	var stack = get_stack()
	
	# TODO: There's gotta be a better way...
	var current_line = stack[1]
	var source = current_line["source"] as String
	var function = current_line["function"] as String
	
	print_rich("[color=green][INFO][/color][color=pink][%s-> %s]:[/color] %s"
			% [source.get_file().to_upper(), function, message])
