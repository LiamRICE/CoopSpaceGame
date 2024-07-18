##########################################################
###   Instruction for how to use the dialogue system   ###
##########################################################


I. Dialogue file architecture

	1. Creating a new dialogue sequence
		Each dialogue sequence starts with the start identifier symbol followed by the string name of the sequence : ~
		For example : the start of a dialogue should be identified with : =>start
		
		The end of the dialogue file should be marked with : =>end
		Anything written after that will not be parsed by the DialogueManager
	
	2. Creating a line of dialogue to be read
		A line of dialogue is presented as the speaking character (represented by %s to be replaced in code later) followed by a colon then the line of dialogue, for example :
		%s : Hello !
		Note that each line of dialogue will be presented sequentially one line at a time.
		
		Additionally, comments can be added in the same way as Godot comments. A hash character followed by the comment. Everything after the comment will be ignored.
	
	3. Branching dialogue
		Speaking options for the player character are represented by a dash immediately before the option.
		Many options can be chained one after the other and will all be included until a line not starting with a dash is found.
		
		For example :
		%s : Hello !
		- Hello there !
		- How do you do ?
		- Wassup !
		
		Dialogue branches must be followed by a colon with the response to the prompt. This is represented by a colon after the option with the following lines of dialog indented.
		
		For example :
		%s : Hello !
		- Hello there !:
			%s : Nice to meet you !
		- How do you do ?:
			%s : I'm good, thanks.
		
		Dialog branches can be nested to create multiple branches.
	
	4. Jump to dialog and exiting dialog
		Exiting dialog happens automatically if the line of dialog is the last line in the file (eg. the ~end command follows it) or can be ended prematurely with the return command RTN.
		This command will let the dialog manager know that the dialog has been exited and that control should be given back to the player character.
		
		In order to create a jump to go from one branch back to a main dialog selection or to a different branch, a marker and a jump command can be added.
		A marker is formatted the same way as the start and end markers, that is a tilde ~ followed by the name of the marker. The name must be unique to the file.
		A marker must occupy an entire line by itself.
		
		A jump command can be written by adding the jump command JMP followed by the name of the marker. No need for the tilde.
		
		For example :
		~shop
		%s : What can I get you ?
		- Bye !:
			%s : Nice to meet you ! Bye !
			RTN
		- Can I see your wares ?:
			%s : Sure.
			JMP shop
		
		In this example, the RTN command wouldn't be needed if this is all that is present in the dialog tree.
		RTN commands are mostly important if multiple different dialog trees are present in the same file, dialogs for different seasons, effects, etc...
	
	5. Evaluating conditions for dialog
		Conditions can be evaluated by the dialog manager when presented with the IF command and a variable expression followed by a colon.
		The corresponding ELIF and ELSE commands can be used also.
		This tag must be consistent with a dictionary of tags that the character provides to the dialog manager.
		Each entry in the dictionary should be a unique name tag such as "received_gift" or "temp_hostile" and be followed by a value (bool, int, str, float).
		Valid comparisons are ==,<,>,<=,>= and !=. Variables in the dict can be compared to each other or to values of the same type (num/num or str/str).
		The only valid expressions for bools and strings are == and !=. Bools don't need to be compared but can just be evaluated as they are.
		
		If the entry to evaluate is a part of the player, the player character must update the actionable variables in the dictionary using the reference it has before initiating dialog.
		The only entries that can be evaluated are in the dictionary of the actionable.
		Any name tag that is not present in the dictionary will be evaluated as being false by default.
		
		For example :
		~shop
		%s : What can I get you ?
		- Bye !:
			%s : Nice to meet you ! Bye !
			RTN
		- Can I see your wares ?:
			IF is_selling: #bool
				%s : Sure.
			ELIF investement < 1000: #int
				%s : Sorry, I don't have enough capital for trades.
			ELSE:
				%s : I'm not open at the moment, come again later.
			JMP shop
		
		These options can of course be nested if needed.
	
	6. Changing state variables in dialog
		A variable's state can be modified within a script to allow for different dialog within the same branching tree.
		The CHNG command can be used to change any variable into another value.
		The name of the value to change should be added after the CHNG command followed by the value to which it is being changed.
		Note that this will assume that the value typed is of the same type as the value contained in the dictionary.
		
		/!\ A value changed in the dialogue manager will be updated in the host's dictionary as they are like arrays (the reference is passed rather than the object itself).
		/!\ A value may only be a text string, a boolean, an integer or a floating point number.
		
		For example:
		CHNG is_upset true
		CHNG tears_cried 40000
	
	7. Starting other managers/interfaces from dialog
		Custom commands can be inplemented using the dialog system to start different systems based on dialog.
		By including a string after a RTN command, a message can be passed to the actionable that can pass that message back to the entity.
		This message can be any contiguous string and will be sent back to the entity.
		This can be used to initiate a trading screen, start a cutscene, or trigger any other function in actionable/entity.
		
		For example :
		~shop
		%s : What can I get you ?
		- Bye !:
			%s : Nice to meet you ! Bye !
			RTN
		- Can I see your wares ?:
			IF is_selling:
				%s : Sure.
				RTN trade
			ELIF needs_investement:
				%s : Sorry, I don't have enough capital for trades. Would you like to invest ?
				RTN invest
			ELSE:
				%s : I'm not open at the moment, come again later.
				RTN
			JMP shop
		
		Only the first encountered return will be evaluated and will cancel the player out of the dialog.
		If the dialog needs to be returned to after the other function is called, the dialog must be restarted by the entity with a jump modifier to go to the appropriate marker.
		(see II)

II. Using the dialog manager

	1. Starting a dialog
	Dialog can be started by using the DialogManager.show_dialogue() function call. This will access the UI and begin the interaction.
	A DialogueResource object must be passed to the show_dialogue() function. The DialogueResource contains the text string that is interpreted by the dialogue manager.
	
	Aditionally, a starting marker can also be passed as an argument in order to begin a conversation from that marker.
	This can be used to start a conversation from a different position that the start marker.
	
	2. Detecting when dialogue finishes
	When dialogue finishes, a dialogue_finished signal is fired containing a potential return string from the dialogue script.
	This can be subscribed to by the entity to know perform logic when a conversation ends.


