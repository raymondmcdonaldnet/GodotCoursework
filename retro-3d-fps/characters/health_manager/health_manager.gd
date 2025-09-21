class_name HealthManager
extends Node
## The component used to manage the character's health.

## Emitted when the character should die.
signal died
## Emitted when the character should be gibbed.
signal gibbed
## Emitted when the character receives healing.
signal healed
## Emitted when the character receives damage.
signal damaged
## Emitted when the character's health changes.
signal health_changed(current_health: int, max_health: int)

## The max health for the associated character.
@export var max_health: int = 100
## When the character's health drops to this threshold, they should be gibbed.
@export var gib_health_threshold: int = -10
## Whether to print verbose debug messages for this object.
@export var debug_is_verbose: bool = false

## The current health of the associated character.
@onready var current_health: int = max_health


func _ready() -> void:
	# Emit initial health.
	health_changed.emit(current_health, max_health)
	if debug_is_verbose:
		print("Starting health: %d/%d" % [current_health, max_health])


## Hurt the character associated with the health manager.
func hurt(damage_data: DamageData) -> void:
	# Don't hurt dead characters.
	if current_health <= 0:
		return
	# Apply damage, check gibbing, check death, and emit signals.
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


## Apply healing to the character associated with the health manager.
func heal(amount: int) -> void:
	# Do not heal dead characters.
	if current_health <= 0:
		return
	# Apply healing and emit signals.
	current_health = clamp(current_health + amount, 0, max_health)
	healed.emit()
	health_changed.emit(current_health, max_health)
	if debug_is_verbose:
		print("Healed for: %d" % amount)
		print("New health: %d" % current_health)
