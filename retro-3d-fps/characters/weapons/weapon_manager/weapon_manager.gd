class_name WeaponManager
extends Node
## The component used to manage the character's weapons.

# TODO: Automatically build and update array of weapons at runtime.

## The character's weapon indices.
@export var weapons: Array[Weapon]

## The character's weapons (by index) and whether they are unlocked.
var weapons_unlocked: Dictionary
## The current active weapon slot.
var current_weapon_slot: int = 0
## The current weapon equipped.
var current_weapon_equipped: Weapon


func _ready() -> void:
	disable_all_weapons()
	for i in range(weapons.size()):
		weapons_unlocked[i] = false


## Set all weapons to inactive.
func disable_all_weapons() -> void:
	for weapon in weapons:
		weapon.set_active(false)


## Switch to previous weapon with modulo index arithmetic.
func switch_to_previous_weapon() -> void:
	for i in range(1, weapons.size()):
		var wrapped_index: int = wrapi(current_weapon_slot - i, 0, weapons.size())
		if switch_to_weapon_slot(wrapped_index):
			break


## Switch to next weapon with modulo index arithmetic.
func switch_to_next_weapon() -> void:
	for i in range(1, weapons.size()):
		var wrapped_index: int = wrapi(current_weapon_slot + i, 0, weapons.size())
		if switch_to_weapon_slot(wrapped_index):
			break


## Switch to a given weapon slot if possible and report success.
func switch_to_weapon_slot(slot_index: int) -> bool:
	if slot_index >= weapons.size() or slot_index < 0:
		return false
	if weapons_unlocked.size() == 0 or weapons_unlocked[slot_index]:
		return false
	
	disable_all_weapons()
	current_weapon_slot = slot_index
	current_weapon_equipped = weapons[slot_index]
	current_weapon_equipped.set_active(true)
	return true
