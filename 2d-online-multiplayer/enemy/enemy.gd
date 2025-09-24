class_name Enemy
extends CharacterBody2D
## Basic enemy character.

var current_health: int = 5
static var my_scene: PackedScene = preload("uid://ps4kh5bv46ja")


func die() -> void:
	queue_free()


func handle_hit() -> void:
	current_health -= 1
	if current_health <= 0:
		die()


static func new_enemy(pos: Vector2) -> Enemy:
	var enemy := my_scene.instantiate() as Enemy
	enemy.global_position = pos
	return enemy


func _on_bullet_detector_area_entered(area: Area2D) -> void:
	# Only handle collision on host for correct MultiplayerSpawner behavior.
	if not multiplayer.is_server():
		return
	
	if area.owner is Bullet:
		var bullet := area.owner as Bullet
		bullet.register_collision()
		handle_hit()
