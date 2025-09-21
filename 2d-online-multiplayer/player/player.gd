class_name Player
extends CharacterBody2D
## The player character.


func _physics_process(_delta: float) -> void:
	var movement_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = movement_vector * 100.0
	move_and_slide()
