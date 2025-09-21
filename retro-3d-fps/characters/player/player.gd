class_name Player
extends CharacterBody3D
## The player character.

# TODO: Rotate player toward camera.

## Is the camera x axis inverted?
@export var is_camera_x_axis_inverted: bool = false
## Is the camera y axis inverted?
@export var is_camera_y_axis_inverted: bool = false
## The factor to scale horizontal mouse input with.
@export_range(0.15, 0.70, 0.01)
var mouse_sensitivity_horizontal: float = 0.05
## The factor to scale vertical mouse input with.
@export_range(0.15, 0.70, 0.01)
var mouse_sensitivity_vertical: float = 0.05
## The minimum pitch (y rotation) the camera may look toward.
@export_range(-0.90, 0.0, 0.01, "radians_as_degrees")
var minimum_pitch: float = -0.60
## The maximum pitch (y rotation) the camera may look toward.
@export_range(0.0, 0.90, 0.01, "radians_as_degrees")
var maximum_pitch: float = 0.60

## The player's accumulated mouse input.
var mouse_input := Vector2.ZERO
## The player's movement input as a vector.
var movement_input := Vector2.ZERO
## Whether the player is dead or alive.
var is_dead: bool = false

## The component used to apply movement to the player.
@onready var character_mover: CharacterMover = %CharacterMover
## The component used to manage the player's health.
@onready var health_manager: HealthManager = %HealthManager
@onready var weapon_manager: WeaponManager = %WeaponManager
## The camera's parent node.
@onready var camera_pivot: Node3D = %CameraPivot
## The player's first-person camera.
@onready var camera_3d: Camera3D = %Camera3D
## The container for the player's equipped weapons.
@onready var weapons: Node3D = %Weapons


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(_delta: float) -> void:
	set_movement_direction()


func _physics_process(_delta: float) -> void:
	handle_camera_rotation()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("debug_quit"):
		get_tree().quit()
	elif event.is_action_released("debug_restart"):
		get_tree().reload_current_scene()
	elif event.is_action_released("debug_full_screen"):
		var is_full_screen: bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if is_full_screen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)	
	
	if is_dead:
		return
	# Accumulate mouse input for camera pivot rotation.
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_input.x += event.relative.x * mouse_sensitivity_horizontal
		mouse_input.y += event.relative.y * mouse_sensitivity_vertical
	elif event.is_action_released("select_next_weapon"):
		weapon_manager.switch_to_next_weapon()
	elif event.is_action_released("select_previous_weapon"):
		weapon_manager.switch_to_previous_weapon()
	elif event.is_action_released("select_weapon0"):
		weapon_manager.switch_to_weapon_slot(0)
	elif event.is_action_released("select_weapon1"):
		weapon_manager.switch_to_weapon_slot(1)
	elif event.is_action_released("select_weapon2"):
		weapon_manager.switch_to_weapon_slot(2)
	elif event.is_action_released("select_weapon3"):
		weapon_manager.switch_to_weapon_slot(3)
	elif event.is_action_released("select_weapon4"):
		weapon_manager.switch_to_weapon_slot(4)
	elif event.is_action_released("select_weapon5"):
		weapon_manager.switch_to_weapon_slot(5)
	elif event.is_action_released("select_weapon6"):
		weapon_manager.switch_to_weapon_slot(6)
	elif event.is_action_released("select_weapon7"):
		weapon_manager.switch_to_weapon_slot(7)
	elif event.is_action_released("select_weapon8"):
		weapon_manager.switch_to_weapon_slot(8)
	elif event.is_action_released("select_weapon9"):
		weapon_manager.switch_to_weapon_slot(9)
	elif event.is_action_released("jump"):
		character_mover.jump()
	elif event.is_action_released("debug_quit"):
		get_tree().quit()
	elif event.is_action_released("debug_restart"):
		get_tree().reload_current_scene()
	elif event.is_action_released("debug_full_screen"):
		var is_full_screen: bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if is_full_screen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


## Set the 3D movement direction and apply it to the [CharacterMover].
func set_movement_direction() -> void:
	# Do not consider movement direction of dead characters.
	if is_dead:
		return
	# Get movement input and set the new movement direction on the character mover.
	movement_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var rotated_movement_input: Vector2 = movement_input.rotated(-camera_pivot.global_transform.basis.get_euler().y)
	character_mover.set_movement_direction(transform.basis * Vector3(rotated_movement_input.x, 0.0, rotated_movement_input.y).normalized())


## Handle the player's camera rotation based on mouse input.
func handle_camera_rotation() -> void:
	if is_dead:
		return
	# Reset camera pivot rotation.
	camera_pivot.transform.basis = Basis.IDENTITY
	# Clamp mouse input pitch.
	mouse_input.y = clamp(mouse_input.y, minimum_pitch, maximum_pitch)
	
	# Rotate camera pivot.
	if is_camera_x_axis_inverted:
		camera_pivot.rotate_object_local(Vector3.UP, mouse_input.x)
	else:
		camera_pivot.rotate_object_local(Vector3.UP, -mouse_input.x)
	
	if is_camera_y_axis_inverted:
		camera_pivot.rotate_object_local(Vector3.RIGHT, mouse_input.y)
	else:
		camera_pivot.rotate_object_local(Vector3.RIGHT, -mouse_input.y)
	
	# Reset orthogonal and axis lengths every frame to keep rotations accurate.
	camera_pivot.transform = camera_pivot.transform.orthonormalized()


## Handle the player's death.
func die() -> void:
	is_dead = true
	character_mover.movement_direction = Vector3.ZERO


## Respond to the health manager signaling that the character should die.
func _on_health_manager_died() -> void:
	die()
