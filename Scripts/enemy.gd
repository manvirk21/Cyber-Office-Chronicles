extends CharacterBody2D

# Movement speed
const SPEED = 140

# Direction toggle
var direction = Vector2.DOWN

# Patrol distance before turning around
@export var patrol_distance = 440
var start_position
var distance_moved = 0.0

func _ready():
	start_position = global_position

func _physics_process(delta):
	velocity = direction * SPEED
	move_and_slide()

	# Track how far we've moved
	distance_moved += SPEED * delta
	if distance_moved >= patrol_distance:
		direction *= -1  # Flip direction
		distance_moved = 0.0




func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Game Over! You were detected.")
		get_tree().reload_current_scene()
