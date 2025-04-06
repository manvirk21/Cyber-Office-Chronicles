extends Control

@onready var main_menu_button = $MainMenuButton

func _ready():
	main_menu_button.pressed.connect(on_main_menu_pressed)

func on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
