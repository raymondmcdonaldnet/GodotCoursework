class_name CharacterMover
extends Node3D
## The component used to apply movement to [CharacterBody3D] parent characters.

## The character body to apply movement to.
@export var character_body: CharacterBody3D
## The amount of force to add to Y velocity when jumping.
@export var jump_force: float = 16.0
## The amount of gravity to subtract from Y velocity when falling.
@export var gravity: float = 30.0
## The maximum movement speed of the character.
@export var max_movement_speed: float = 15.0
## The rate at which the character's movement speed accelerates upward.
@export var movement_acceleration: float = 4.0
## The amount of drag to apply to character movement when stopping.
@export var stop_drag: float = 0.9

## The amount of drag to apply while character is moving. Formula is 
## movement_acceleration divided by max_movement_speed.
var movement_drag: float = 0.0
## The 3D direction the character moves in.
var movement_direction: Vector3


func _ready() -> void:
	# Calculate movement drag.
	movement_drag = movement_acceleration / max_movement_speed


func _physics_process(delta: float) -> void:
	# Bounce off of the ceiling when jumping into it.
	if character_body.velocity.y > 0 and character_body.is_on_ceiling():
		character_body.velocity.y = 0
	# Apply gravity while in the air.
	if not character_body.is_on_floor():
		character_body.velocity.y -= gravity * delta
	
	# Determine which drag to use (is character moving or not?)
	var drag: float = movement_drag
	if movement_direction.is_zero_approx():
		drag = stop_drag
	var flat_velocity: Vector3 = Vector3(character_body.velocity.x, 0.0, character_body.velocity.z)
	# Accelerate velocity positively or negatively depending on movement and 
	# previous velocity.
	character_body.velocity += movement_acceleration * movement_direction - flat_velocity * drag
	
	character_body.move_and_slide()


## Interface to set the character's movement direction.
func set_movement_direction(new_movement_direction: Vector3) -> void:
	movement_direction = new_movement_direction


## Apply jump force to character's y velocity.
func jump() -> void:
	if character_body.is_on_floor():
		character_body.velocity.y += jump_force
