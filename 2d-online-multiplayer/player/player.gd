class_name Player
extends CharacterBody2D
## The player character.

## Store the player's movement input and synchronize it instead of position to 
## help prevent cheating.
var movement_input := Vector2.ZERO


func _ready() -> void:
	# Input is handled in _process(), so only check it on authority (this peer).
	set_process(is_multiplayer_authority())
	# Movement is applied in _physics_process(), so only do so on server.
	set_physics_process(multiplayer.is_server())


func _process(_delta: float) -> void:
	# Should only run on multiplayer authority (this peer). Get movement input.
	movement_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _physics_process(_delta: float) -> void:
	# Should only run on the server. Apply movement to self, then everyone else.
	apply_movement()
	apply_movement_to_all_peers()


## Instruct all peers to set their velocity and then move.
func apply_movement_to_all_peers() -> void:
	for peer_id: int in multiplayer.get_peers():
		apply_movement.rpc_id(peer_id)


## Instruct a specific peer to set their velocity and then move.
@rpc("any_peer", "call_remote", "unreliable")
func apply_movement() -> void:
	velocity = movement_input * 100.0
	move_and_slide()
	movement_input = Vector2.ZERO
