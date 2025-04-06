extends Control

# === UI References ===
@onready var card_text_label = $CardContainer/CardPanel/CardText
@onready var score_label = $ScoreLabel
@onready var secure_button = $ButtonContainer/SecureButton
@onready var sketchy_button = $ButtonContainer/SketchyButton
@onready var feedback_panel = $FeedbackPanel
@onready var feedback_label = $FeedbackPanel/FeedbackLabel 
@onready var card_container = $CardContainer
@onready var background = $Background
@onready var back_button = $BackButton
@onready var intro_popup = $GameIntroPopup
@onready var start_button = $GameIntroPopup/VBoxContainer/StartButton

func _process(delta):
	background.scroll_offset.x += 230 * delta  # Adjust speed here

# === Game Variables ===
var all_cards = []
var current_deck = []
var score = 0
var current_card_index = 0
var correct_count = 0

const CARDS_PER_GAME = 10
const SCORE_PER_CORRECT = 10

const RANKS = [
	{ "min": 90, "title": "🏅 Cyber Champ", "desc": "Flawless instincts! You spot threats like a pro." },
	{ "min": 70, "title": "🧠 Cautious Clicker", "desc": "Solid work! You're mostly secure with a few slip-ups." },
	{ "min": 50, "title": "🤔 Needs Improvement", "desc": "Not bad, but you missed some sketchy stuff." },
	{ "min": 0,  "title": "😬 Security Sponge", "desc": "Oops. You absorbed more threats than you blocked!" }
]

func _ready():
	intro_popup.popup_centered()
	start_button.pressed.connect(_on_start_pressed)
	#get_tree().paused = true  # Pause game while popup is open
	load_cards()
	shuffle_and_select()
	# Connect button signals
	secure_button.pressed.connect(on_secure_pressed)
	sketchy_button.pressed.connect(on_sketchy_pressed)
	back_button.pressed.connect(on_back_pressed)
	
	show_card()

func _on_start_pressed():
	intro_popup.hide()
	#get_tree().paused = false  # Resume game

func load_cards():
	var file = FileAccess.open("res://Scripts/cards.json", FileAccess.READ)
	var json_text = file.get_as_text()
	all_cards = JSON.parse_string(json_text)

func shuffle_and_select():
	all_cards.shuffle()
	current_deck = all_cards.slice(0, CARDS_PER_GAME)

func show_card():
	if current_card_index >= current_deck.size():
		show_final_score()
		return
			
	feedback_panel.visible = false
	feedback_label.text = ""
	card_container.visible = true
	# Show current card text
	card_text_label.text = current_deck[current_card_index]["text"]

func on_secure_pressed():
	handle_answer("secure")

func on_sketchy_pressed():
	handle_answer("sketchy")

func on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func handle_answer(player_choice):
	var card = current_deck[current_card_index]
	var correct_answer = card["answer"]
	var explanation = card.get("explanation", "No explanation provided.")
	
	card_container.visible = false  # Hides the card
	feedback_panel.visible = true
	
	if player_choice == correct_answer:
		score += 10
		correct_count += 1
		feedback_label.text = "✅ Correct!\n" + explanation

	else:
		score -= 5
		feedback_label.text = "❌ Incorrect!\n" + explanation

	score_label.text = "Score: %s" % score
	current_card_index += 1
	
	await get_tree().create_timer(3.0).timeout
	show_card()

func show_final_score():
	card_container.visible = true
	secure_button.visible = false
	sketchy_button.visible = false
	score_label.visible = false
	feedback_panel.visible = false
	
	var total_possible = CARDS_PER_GAME * SCORE_PER_CORRECT
	var total_questions = current_deck.size()
	var percent = float(correct_count) / total_questions * 100.0
	var rank = RANKS[3]  # Default to lowest

	for r in RANKS:
		if percent >= r["min"]:
			rank = r
			break
	
	card_text_label.text = "🎉 Final Score: %s/%s (%.0f%%)\n%s\n%s" % [
		score, total_possible, percent, rank["title"], rank["desc"]
	]
