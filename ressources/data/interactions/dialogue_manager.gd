class_name DialogueManager

enum state {DONE, NEXT, OPTION}

signal dialogue_finished(String)

# Parses the text from the DialogueResource and shows the first line of dialogue upon interacting with the character
# Returns if the character has another line of dialogue to say
static func show_dialogue(resource, state:Dictionary, start:String = "") -> void:
	# Save the indexes and names of markers in the script in a dict
	var markers :Dictionary = {}
	
	# Open the script file
	var file := FileAccess.open("res://ressources/data/dialogue/test_dialogue.txt", FileAccess.READ)
	var text = file.get_as_text()
	
	# Remove all of the excess data from the script
	text = text.get_slice("=>start", 1)
	text = text.get_slice("=>end", 0)
	var lines = text.split("\n", false)
	
	# Strip the lines of any comments and complete the markers dict
	var pos := 0
	for line in lines:
		if "#" in line:
			line = line.get_slice("#", 0)
			if line.ends_with(" "):
				line = line.left(-1)
		if "~" in line:
			markers[line.get_slice("~", 1)] = pos
		pos += 1
	
	# Evaluates each line sequentially
	_evaluate_lines(lines, 1, markers, state)


# Presents the dialogue options at the string marker to the player
# Returns the # of the option selected (ex: if there are 3 dialogue options and the player chooses the second, returns 2)
# A return of 0 means no option was selected in the case of timed dialog.
static func _show_options(options:Array[String]) -> int:
	# TODO Create the show options dialogue
	return 0


static func _get_options(lines:Array[String], index:int) -> Array[String]:
	# TODO List the options that can be selected by the player
	return [""]


# Evaluates the effect of a line and creates it's effect.
# Returns the number of the next line to be evaluated
static func _evaluate_lines(lines:Array[String], index:int, markers:Dictionary, state:Dictionary) -> int:
	# isolates the evaluated line
	var line:String = lines[index]
	
	# Find the order of the line (num of indents)
	var level := 0
	while line[level] == "\t":
		level += 1
	
	# Match the first character to any commands
	var index_changed := false
	match line[level]:
		"-":
			# TODO create an options dialogue
			index = _show_options(_get_options(lines, index))
		"%":
			# TODO print line to a UI element
			print(line % state["name"])
		_:
			if line.begins_with("IF"):
				# TODO handle if statements
				print("If statement")
			
			elif line.begins_with("ELIF"):
				# TODO handle elif statements
				print("If statement")
			
			elif line.begins_with("ELSE"):
				# TODO handle else statements
				print("If statement")
			
			elif line.begins_with("CHNG"):
				var key := line.get_slice(" ", 1)
				if state.has(key):
					match typeof(state[key]):
						TYPE_INT:
							state[key] = line.get_slice(" ", 2).to_int()
						TYPE_FLOAT:
							state[key] = line.get_slice(" ", 2).to_float()
						TYPE_STRING:
							state[key] = line.get_slice(" ", 2)
						TYPE_BOOL:
							if line.get_slice(" ", 2) == "true":
								state[key] = true
							else:
								state[key] = false
			
			elif line.begins_with("JMP"):
				# TODO Handle jump cases
				print("If statement")
			
			elif line.begins_with("RTN"):
				# TODO Handle return cases
				print("If statement")
		
	# increment the index if no other modifications or jumps happened
	if !index_changed:
		index += 1
	
	return 0


















