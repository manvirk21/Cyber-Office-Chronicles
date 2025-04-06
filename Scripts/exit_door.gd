extends Area2D

@onready var popup = get_node("/root/Node2D/HUD/NoDataPopup")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if Global.has_packet:
			get_tree().change_scene_to_file("res://Scenes/Win.tscn")
		else:
			if popup:
				popup.visible = true
				await get_tree().create_timer(2.0).timeout
				popup.hide()
