class_name Game
extends Node2D
## The main game scene, containing all of the gameplay.

## The [Player] scene.
var player_scene: PackedScene = preload("uid://c5bg2otktm48b")

## The spawner used to synchronize new [Player] instances.
@onready var player_spawner: MultiplayerSpawner = %PlayerSpawner
## The node used to contain [Player] instances.
@onready var players: Node = %Players
@onready var bullets: Node = %Bullets


func _ready() -> void:
	# Use a custom spawn to add new players as they connect and initialize.
	player_spawner.spawn_function = func(data: Variant) -> Player:
		var player := player_scene.instantiate() as Player
		player.name = str(data.peer_id)
		player.set_multiplayer_authority(data.peer_id)
		player.bullet_created.connect(_on_bullet_created)
		return player
	peer_ready.rpc_id(1)


## Spawn a new player with the remote peer's ID.
@rpc("any_peer", "call_local", "reliable")
func peer_ready() -> void:
	var sender_id: int = multiplayer.get_remote_sender_id()
	player_spawner.spawn({"peer_id": sender_id})


## Respond to request to create a bullet at given position with given direction.
func _on_bullet_created(pos: Vector2, direction: Vector2) -> void:
	var bullet: Bullet = Bullet.new_bullet(pos, direction)
	bullets.add_child(bullet, true)
