class_name Bullet
extends Node2D

## The speed the bullet moves at each frame.
const SPEED: int = 600

## The scene used to instantiate new bullets.
static var my_scene: PackedScene = preload("uid://bpbr8yyqb3cfs")
## The direction the bullet will move in each frame.
var movement_direction := Vector2.RIGHT


func _physics_process(delta: float) -> void:
	global_position += movement_direction * SPEED * delta


## Return a new Bullet instance.
static func new_bullet(pos: Vector2, direction: Vector2) -> Bullet:
	var bullet := my_scene.instantiate() as Bullet
	bullet.global_position = pos
	bullet.movement_direction = direction
	bullet.global_rotation = direction.angle()
	return bullet
