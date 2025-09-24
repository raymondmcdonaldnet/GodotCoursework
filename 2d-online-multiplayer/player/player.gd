class_name Player
extends CharacterBody2D
## The player character.

## Emitted when host player goes to create a bullet. [Game] handles creating bullets.
signal bullet_created(pos: Vector2, direction: Vector2)

## Store the player's movement input and synchronize it instead of position to 
## help prevent cheating.
var movement_input := Vector2.ZERO
## The direction the player is aiming at.
var aim_vector := Vector2.RIGHT
## The [Bullet] scene.
var bullet_scene: PackedScene = preload("uid://bpbr8yyqb3cfs")

@onready var weapon_root: Node2D = %WeaponRoot


func _ready() -> void:
	# Input is handled in _process(), so only check it on authority (this peer).
	set_process(is_multiplayer_authority())
	# Movement is applied in _physics_process(), so only do so on server.
	set_physics_process(multiplayer.is_server())


func _process(_delta: float) -> void:
	# Should only run on multiplayer authority (this peer). Get movement input.
	movement_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	aim_vector = weapon_root.global_position.direction_to(weapon_root.get_global_mouse_position())


func _physics_process(_delta: float) -> void:
	# Should only run on the server. Apply movement to self, then everyone else.
	apply_movement()
	apply_movement_to_all_peers()
	apply_aiming()
	apply_aiming_to_all_peers()


func _unhandled_input(event: InputEvent) -> void:
	# Only handle input on the multiplayer authority.
	if not is_multiplayer_authority():
		return
	
	if event.is_action_released("attack"):
		create_bullet.rpc_id(1, global_position, aim_vector)


## Instruct all peers to set their velocity and then move.
func apply_movement_to_all_peers() -> void:
	for peer_id: int in multiplayer.get_peers():
		apply_movement.rpc_id(peer_id)


## Instruct a specific peer to set their velocity and then move.
@rpc("any_peer", "call_remote", "unreliable")
func apply_movement() -> void:
	velocity = movement_input * 100.0
	move_and_slide()


## Instruct all peers to aim their gun toward the aim vector.
func apply_aiming_to_all_peers() -> void:
	for peer_id: int in multiplayer.get_peers():
		apply_aiming.rpc_id(peer_id)


## Instruct a specific peer to aim their gun toward the aim vector.
@rpc("any_peer", "call_remote", "unreliable")
func apply_aiming() -> void:
	weapon_root.look_at(weapon_root.global_position + aim_vector)


## Instruct the host to emit the signal the [Game] uses to instantiate bullets.
@rpc("any_peer", "call_local", "reliable")
func create_bullet(pos: Vector2, direction: Vector2) -> void:
	bullet_created.emit(pos, direction)
