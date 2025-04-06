extends CharacterBody2D

# Movement speed (adjust if needed)
const SPEED = 150

func _physics_process(delta):
	var direction = Vector2.ZERO

	# Input handling
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		direction.y -= 1

	# Normalize direction so diagonal isn't faster
	velocity = direction.normalized() * SPEED
	move_and_slide()
