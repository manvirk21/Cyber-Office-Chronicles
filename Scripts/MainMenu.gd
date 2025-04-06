extends Control

@onready var secure_button = $ButtonContainer/SecureOrSketchyButton
@onready var weak_button = $ButtonContainer/TheWeakestLinkButton
@onready var quit_button = $ButtonContainer/QuitButton
@onready var maze_button = $ButtonContainer/CyberMaze

func _ready():
	secure_button.pressed.connect(on_secure_pressed)
	weak_button.pressed.connect(on_weak_pressed)
	maze_button.pressed.connect(on_maze_pressed)
	quit_button.pressed.connect(on_quit_pressed)

func on_secure_pressed():
	get_tree().change_scene_to_file("res://Scenes/SecureOrSketchy.tscn")

func on_weak_pressed():
	get_tree().change_scene_to_file("res://Scenes/TheWeakestLink.tscn")  # Placeholder for now

func on_maze_pressed():
	get_tree().change_scene_to_file("res://Scenes/CyberMaze.tscn") 

func on_quit_pressed():
	get_tree().quit()
