class_name Bullet
extends Node2D

const SPEED: int = 600

static var my_scene: PackedScene = preload("uid://bpbr8yyqb3cfs")
var movement_direction := Vector2.RIGHT


func _physics_process(delta: float) -> void:
	global_position += movement_direction * SPEED * delta


## Return a new Bullet instance.
static func new_bullet(pos: Vector2, direction: Vector2) -> Bullet:
	var bullet := my_scene.instantiate() as Bullet
	bullet.global_position = pos
	bullet.movement_direction = direction
	bullet.rotation = direction.angle()
	return bullet
