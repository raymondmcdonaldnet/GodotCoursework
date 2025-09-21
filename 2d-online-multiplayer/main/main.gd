class_name Main
extends Node2D
## The main scene which contains everything else in the game.

var main_menu_scene: PackedScene = preload("uid://br7bxrmr3qrp0")
var game_scene: PackedScene = preload("uid://hyftnjv0hous")

## The container for the game's various scenes.
@onready var scenes: Node = %Scenes


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	load_main_menu_scene()


func load_main_menu_scene() -> void:
	var main_menu := main_menu_scene.instantiate() as MainMenu
	main_menu.game_started.connect(_on_game_started)
	scenes.add_child(main_menu, true)


func unload_main_menu_scene() -> void:
	var main_menu := scenes.get_child(0) as MainMenu
	if main_menu:
		main_menu.game_started.disconnect(_on_game_started)
		main_menu.queue_free()


func load_game_scene() -> void:
	var game := game_scene.instantiate() as Game
	scenes.add_child(game, true)


func unload_game_scene() -> void:
	var game := scenes.get_child(0) as Game
	if game:
		game.queue_free()


func _on_peer_connected(id: int) -> void:
	print("Peer %d connected!" % id)
	print("My peer id: %d" % multiplayer.get_unique_id())


func _on_peer_disconnected(id: int) -> void:
	print("Peer %d disconnected!" % id)


func _on_connected_to_server() -> void:
	pass


func _on_game_started() -> void:
	# Servers and clients should all unload the main menu.
	unload_main_menu_scene()
	# Clients should wait to connect to server and let server load Game scene.
	if not multiplayer.is_server():
		await multiplayer.connected_to_server
	else:
		load_game_scene()
