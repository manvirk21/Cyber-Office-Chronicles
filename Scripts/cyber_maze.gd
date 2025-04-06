extends Node2D

@onready var intro_popup = $GameIntroPopup
@onready var start_button = $GameIntroPopup/VBoxContainer/StartButton

func _ready():
	intro_popup.popup_centered()
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	intro_popup.hide()
