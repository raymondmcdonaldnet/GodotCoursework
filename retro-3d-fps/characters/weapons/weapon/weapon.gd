class_name Weapon
extends Node3D
## An equippable weapon.

## The mesh to use in the [MeshInstance3D].
@export var mesh: Mesh

## The weapon's mesh instance.
@onready var mesh_instance_3d: MeshInstance3D = %MeshInstance3D


func _ready() -> void:
	mesh_instance_3d.mesh = mesh


## Set the weapon as active or inactive.
func set_active(is_active: bool = true) -> void:
	if is_active:
		show()
	else:
		hide()
