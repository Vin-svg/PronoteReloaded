extends Control

var questions = [
	{"question": "What is the capital of France?", "answers": ["Paris", "Berlin", "Madrid"], "correct": 0},
	{"question": "What is 2 + 2?", "answers": ["3", "4", "5"], "correct": 1},
	{"question": "What is the color of the sky?", "answers": ["Blue", "Green", "Red"], "correct": 0},
	{"question": "What is the largest planet?", "answers": ["Earth", "Mars", "Jupiter"], "correct": 2}
]

var current_question_index = 0

@onready var question_label = $QuestionLabel
@onready var answer_buttons = [$AnswerButton1, $AnswerButton2, $AnswerButton3]
@onready var feedback_label = $FeedbackLabel

func _ready():
	# Ensure all nodes are properly initialized
	if not question_label or not feedback_label or answer_buttons.size() != 3:
		push_error("One or more UI elements are not properly initialized")
		return
	
	# Connect buttons to their signal handlers
	for i in range(answer_buttons.size()):
		var button = answer_buttons[i]
		button.connect("pressed", Callable(self, "_on_answer_button_pressed").bind(i))

	load_question(current_question_index)

func load_question(index):
	var question_data = questions[index]
	question_label.text = question_data["question"]
	for i in range(answer_buttons.size()):
		answer_buttons[i].text = question_data["answers"][i]

func _on_answer_button_pressed(button_index):
	var correct_answer = questions[current_question_index]["correct"]
	if button_index == correct_answer:
		feedback_label.text = "Correct!"
	else:
		feedback_label.text = "Incorrect!"
	
	# Move to the next question after a short delay to show the feedback
	await get_tree().create_timer(1.0).timeout
	current_question_index += 1
	if current_question_index < questions.size():
		load_question(current_question_index)
	else:
		feedback_label.text = "Quiz Completed!"
		disable_buttons()

func disable_buttons():
	for button in answer_buttons:
		button.disabled = true
