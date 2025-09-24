class_name Enemy
extends CharacterBody2D
## Basic enemy character.


func _on_bullet_detector_area_entered(area: Area2D) -> void:
	# Only handle collision on host for correct MultiplayerSpawner behavior.
	if not multiplayer.is_server():
		return
	
	if area.owner is Bullet:
		var bullet := area.owner as Bullet
		bullet.register_collision()
