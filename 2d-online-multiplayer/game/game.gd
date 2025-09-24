class_name Game
extends Node2D
## The main game scene, containing all of the gameplay.

## The [Player] scene.
var player_scene: PackedScene = preload("uid://c5bg2otktm48b")
## The basic [Enemy] scene.
var enemy_scene: PackedScene = preload("uid://ps4kh5bv46ja")

## The spawner used to synchronize new [Player] instances.
@onready var player_spawner: MultiplayerSpawner = %PlayerSpawner
## The node used to contain [Player] instances.
@onready var players: Node = %Players
@onready var bullets: Node = %Bullets
@onready var enemies: Node = %Enemies
@onready var player_one_spawn_point: Marker2D = %PlayerOneSpawnPoint
@onready var player_two_spawn_point: Marker2D = %PlayerTwoSpawnPoint
@onready var enemy_spawn_point: Marker2D = %EnemySpawnPoint


func _ready() -> void:
	# Use a custom spawn to add new players as they connect and initialize.
	player_spawner.spawn_function = func(data: Variant) -> Player:
		var player := player_scene.instantiate() as Player
		if data.peer_id == 1:
			player.global_position = player_one_spawn_point.global_position
		else:
			player.global_position = player_two_spawn_point.global_position
		player.name = str(data.peer_id)
		player.set_multiplayer_authority(data.peer_id)
		player.bullet_created.connect(_on_bullet_created)
		return player
	peer_ready.rpc_id(1)
	
	if multiplayer.is_server():
		enemies.add_child(Enemy.new_enemy(enemy_spawn_point.global_position), true)


## Spawn a new player with the remote peer's ID.
@rpc("any_peer", "call_local", "reliable")
func peer_ready() -> void:
	var sender_id: int = multiplayer.get_remote_sender_id()
	player_spawner.spawn({"peer_id": sender_id})


## Respond to request to create a bullet at given position with given direction.
func _on_bullet_created(pos: Vector2, direction: Vector2) -> void:
	var bullet: Bullet = Bullet.new_bullet(pos, direction)
	bullets.add_child(bullet, true)
