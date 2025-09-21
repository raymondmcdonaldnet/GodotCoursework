class_name MainMenu
extends Control
## The game's main menu screen.

signal game_started

const IP_ADDRESS: String = "127.0.0.1"
const PORT: int = 42069


func _on_host_button_pressed() -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	game_started.emit()


func _on_join_button_pressed() -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	game_started.emit()
