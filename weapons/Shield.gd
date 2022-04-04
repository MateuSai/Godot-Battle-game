extends Weapon
class_name Shield, "res://assets/kenney_scribbledungeons/PNG/Default (64px)/Items/shield_curved.png"

signal defense_broken()

onready var protection_collision:CollisionShape2D = get_node("ProtectionArea/CollisionShape2D")


func _ready() -> void:
	_change_protection_disabled(true)


func _change_protection_disabled(disabled:bool) -> void:
	protection_collision.disabled = disabled
	
	
func break_defense() -> void:
	emit_signal("defense_broken")

