extends Control

# Updated questions and answers
var questions = [
	{
		"question": "What are the essential elements for a personalized learning process?",
		"answers": ["AI", "c", "teacher"],
		"correct": [0]  # Index of the correct answer in the list (AI)
	},
	{
		"question": "What is the most famous structure in Australia?",
		"answers": ["The Eiffel Tower", "Big Ben", "The Sydney Opera House", "The Sydney Harbour Bridge"],
		"correct": [2]  # Index of the correct answer in the list (The Sydney Opera House)
	},
	{
		"question": "What are the bad aspects of standardized learning?",
		"answers": ["it is too rigid", "it matches with each student's needs", "it allows a tailored learning", "students aren’t prepared for college"],
		"correct": [0, 3]  # Indexes of the correct answers (it is too rigid, students aren’t prepared for college)
	},
	{
		"question": "What is the most common use of digital tools for teachers?",
		"answers": ["to support teacher-directed support", "to promote collaborative learning", "to assess the strengths and weaknesses of their students", "to play games during classes"],
		"correct": [0]  # Index of the correct answer in the list (to support teacher-directed support)
	},
	{
		"question": "What are Flipped Classrooms?",
		"answers": ["we make students face a wall", "it’s just the name of a Zoom-like app", "teachers learn from students", "students learn at home and work at school"],
		"correct": [3]  # Index of the correct answer in the list (students learn at home and work at school)
	},
	{
		"question": "How can a country represent itself?",
		"answers": ["through its architecture", "through the quality of its concrete", "through its culture", "through the fur of dogs and cats"],
		"correct": [0, 2]  # Indexes of the correct answers (through its architecture, through its culture)
	}
]

var current_question_index = 0

@onready var question_label = $QuestionLabel
@onready var answer_buttons = [$VBoxContainer/AnswerButton1, $VBoxContainer/AnswerButton2, $VBoxContainer/AnswerButton3, $VBoxContainer/AnswerButton4]  # Ensure there are enough buttons
@onready var feedback_label = $FeedbackLabel
@onready var back_to_menu_button = $BackToMenuButton

# Reference to the leveling script instance
@export var leveling_node_path : NodePath
var leveling_script : CharacterBody2D

# References to AudioStreamPlayer nodes
@onready var correct_sound_player = $CorrectSoundPlayer
@onready var wrong_sound_player = $WrongSoundPlayer

func _ready():
	# Check if nodes are properly initialized
	if not question_label:
		push_error("QuestionLabel node not found")
	if not feedback_label:
		push_error("FeedbackLabel node not found")
	for button in answer_buttons:
		if not button:
			push_error("One or more answer buttons not found")
	
	# Ensure there are enough answer buttons
	if answer_buttons.size() != 4:
		push_error("The number of answer buttons does not match the expected count")

	# Connect buttons to their signal handlers
	for i in range(answer_buttons.size()):
		var button = answer_buttons[i]
		if button:
			button.connect("pressed", Callable(self, "_on_answer_button_pressed").bind(i))
		else:
			push_error("Button at index %d is null and cannot be connected" % i)

	# Get the leveling script instance from the scene
	if leveling_node_path:
		leveling_script = get_node(leveling_node_path)
		if not leveling_script or not leveling_script.has_method("add_xp"):
			push_error("Leveling script method 'add_xp' not found or leveling_node_path is invalid")
			return

	load_question(current_question_index)

func load_question(index):
	var question_data = questions[index]
	question_label.text = question_data["question"]
	for i in range(answer_buttons.size()):
		if i < question_data["answers"].size():
			answer_buttons[i].text = question_data["answers"][i]
			answer_buttons[i].show()
		else:
			answer_buttons[i].hide()  # Hide unused buttons

func _on_answer_button_pressed(button_index):
	var correct_answers = questions[current_question_index]["correct"]
	if correct_answers.has(button_index):
		feedback_label.text = "Correct!"
		# Play correct answer sound
		correct_sound_player.play()
		# Add XP to the player
		if leveling_script:
			leveling_script.add_xp(100)
	else:
		feedback_label.text = "Incorrect!"
		# Play wrong answer sound
		wrong_sound_player.play()

	# Move to the next question after a short delay to show the feedback
	await get_tree().create_timer(1.0).timeout
	current_question_index += 1
	if current_question_index < questions.size():
		load_question(current_question_index)
	else:
		feedback_label.text = "Quiz Completed!"
		disable_buttons()
		# Hide the question and answer buttons
		question_label.hide()
		for button in answer_buttons:
			button.hide()
		# Show the back to menu button after a delay
		await get_tree().create_timer(5.0).timeout
		back_to_menu_button.show()

func disable_buttons():
	for button in answer_buttons:
		button.disabled = true

func _on_back_to_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
