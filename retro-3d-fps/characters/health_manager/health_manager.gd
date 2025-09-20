class_name HealthManager
extends Node

signal died
signal healed
signal damaged
signal gibbed
signal health_changed(current_health: int, max_health: int)

@export var max_health: int = 100
@export var gib_health_threshold: int = -10
@export var debug_is_verbose: bool = false

@onready var current_health: int = max_health


func _ready() -> void:
	health_changed.emit(current_health, max_health)
	if debug_is_verbose:
		print("Starting health: %d/%d" % [current_health, max_health])


func hurt(damage_data: DamageData) -> void:
	if current_health <= 0:
		return
	current_health -= damage_data.amount
	if current_health <= gib_health_threshold:
		gibbed.emit()
	if current_health <= 0:
		died.emit()
	else:
		damaged.emit()
	health_changed.emit(current_health, max_health)
	if debug_is_verbose:
		print("Damaged for: %d." % damage_data.amount)
		print("New health: %d" % current_health)


func heal(amount: int) -> void:
	if current_health <= 0:
		return
	current_health = clamp(current_health + amount, 0, max_health)
	healed.emit()
	health_changed.emit(current_health, max_health)
	if debug_is_verbose:
		print("Healed for: %d" % amount)
		print("New health: %d" % current_health)
