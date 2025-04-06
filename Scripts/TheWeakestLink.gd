extends Control

@onready var scenario_label = $VBoxContainer/ScenarioLabel
@onready var option_a = $VBoxContainer/VBoxContainer/OptionAButton
@onready var option_b = $VBoxContainer/VBoxContainer/OptionBButton
@onready var option_c = $VBoxContainer/VBoxContainer/OptionCButton
@onready var outcome_label = $VBoxContainer/OutcomeLabel
@onready var back_button = $BackButton
@onready var continue_buttons = $VBoxContainer/ContinueButtons
@onready var continue_yes_button = $VBoxContainer/ContinueButtons/ContinueYesButton
@onready var continue_no_button = $VBoxContainer/ContinueButtons/ContinueNoButton
@onready var intro_popup = $GameIntroPopup
@onready var start_button = $GameIntroPopup/VBoxContainer/StartButton

var all_scenarios = []
var current_scenario_index = 0
var scenario_data

var current_stage_index = 0
var score = 0

func _ready():
	intro_popup.popup_centered()
	start_button.pressed.connect(_on_start_pressed)
	back_button.pressed.connect(_on_back_pressed)
	option_a.pressed.connect(func(): _handle_choice(0))
	option_b.pressed.connect(func(): _handle_choice(1))
	option_c.pressed.connect(func(): _handle_choice(2))
	continue_yes_button.pressed.connect(_on_continue_yes)
	continue_no_button.pressed.connect(_on_continue_no)

	load_scenarios()
	show_stage()

func _on_start_pressed():
	intro_popup.hide()

func load_scenarios():
	var file = FileAccess.open("res://Scripts/weakest_link_scenarios.json", FileAccess.READ)
	var text = file.get_as_text()
	var data = JSON.parse_string(text)
	all_scenarios = data["scenarios"]
	all_scenarios.shuffle()

func show_stage():
	if current_scenario_index>= all_scenarios.size():
		show_final_result()
		return

	var scenario = all_scenarios[current_scenario_index]
	var stages = scenario["stages"]
	
	if current_stage_index >= stages.size():
		show_continue_prompt()
		return	
		
	var stage = stages[current_stage_index]
	scenario_label.text = "🕵️‍♂️ " + scenario["title"] + "\n\n" + stage["scenario"]
	
	# Shuffle options safely
	var shuffled_options = stage["options"].duplicate()
	shuffled_options.shuffle()

	# Assign text + metadata
	option_a.text = shuffled_options[0]["text"]
	option_b.text = shuffled_options[1]["text"]
	option_c.text = shuffled_options[2]["text"]

	# Track the original mapping to can handle the choice
	option_a.set_meta("score", shuffled_options[0]["score"])
	option_a.set_meta("outcome", shuffled_options[0]["outcome"])

	option_b.set_meta("score", shuffled_options[1]["score"])
	option_b.set_meta("outcome", shuffled_options[1]["outcome"])

	option_c.set_meta("score", shuffled_options[2]["score"])
	option_c.set_meta("outcome", shuffled_options[2]["outcome"])

	outcome_label.visible = false

func _handle_choice(index):
	var selected_button = [option_a, option_b, option_c][index]
	var gained_score = selected_button.get_meta("score")
	var outcome_text = selected_button.get_meta("outcome")

	score += int(gained_score)
	outcome_label.text = outcome_text
	outcome_label.visible = true

	# Delay next stage
	await get_tree().create_timer(2.5).timeout
	current_stage_index += 1
	show_stage()

func show_continue_prompt():
	scenario_label.text = "✅ Scenario Complete: " + all_scenarios[current_scenario_index]["title"] + "\n\nPlay another scenario?"
	var total_stages_completed = 0
	for i in range(current_scenario_index + 1):
		if i < all_scenarios.size():
			total_stages_completed += all_scenarios[i]["stages"].size()

	var max_possible = total_stages_completed * 10
	var percent = (float(score) / max_possible) * 100.0 if max_possible > 0 else 0.0

	scenario_label.text += "\n\nCurrent Score: %s / %s (%.0f%%)" % [score, max_possible, percent]

	option_a.visible = false
	option_b.visible = false
	option_c.visible = false
	outcome_label.visible = false
	continue_buttons.visible = true


func _on_continue_yes():
	continue_buttons.visible = false
	option_a.visible = true
	option_b.visible = true
	option_c.visible = true

	current_scenario_index += 1
	current_stage_index = 0
	show_stage()

func _on_continue_no():
	continue_buttons.visible = false
	show_final_result()


func show_final_result():
	var total_stages_completed = 0
		# Count all stages played so far
	for i in range(current_scenario_index + 1):
		if i < all_scenarios.size():
			total_stages_completed += all_scenarios[i]["stages"].size()

	var max_possible = total_stages_completed * 10
	var percent = (float(score) / max_possible) * 100.0 if max_possible > 0 else 0.0

	# Rank logic
	var rank_title = ""
	var rank_desc = ""

	if percent >= 90:
		rank_title = "🏅 Cyber Manipulator Supreme"
		rank_desc = "Elite tactics and top-tier decision-making."
	elif percent >= 70:
		rank_title = "🧠 Skilled Phisher"
		rank_desc = "You know your way around a social exploit."
	elif percent >= 50:
		rank_title = "🤔 Suspiciously Average"
		rank_desc = "Some good moves, but not quite hacker-level yet."
	else:
		rank_title = "😬 Social Engineering Intern"
		rank_desc = "Maybe stick to reading phishing awareness posters for now."

	# Display everything
	scenario_label.text = "🎯 Final Score: %s / %s (%.0f%%)\n\n%s\n%s" % [
		score, max_possible, percent, rank_title, rank_desc
	]
	
	option_a.visible = false
	option_b.visible = false
	option_c.visible = false
	outcome_label.visible = false


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
