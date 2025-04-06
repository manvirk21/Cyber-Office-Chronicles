extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Notify game or unlock exit
		get_node("/root/Global").set("has_packet", true)  # OR signal to main scene
		queue_free()
