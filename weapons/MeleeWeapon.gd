extends Weapon
class_name MeleeWeapon

signal attack_interrupted()

onready var hitbox:CollisionShape2D = get_node_or_null("Hitbox/CollisionShape2D")


func _ready() -> void:
	_change_hitbox_disabled(true)
	
	
func _stop_and_enable_collect() -> void:
	_change_hitbox_disabled(true)
	._stop_and_enable_collect()
	
	
func throw(dir:Vector2, impulse:int) -> void:
	_change_hitbox_disabled(false)
	.throw(dir, impulse)


func _on_Hitbox_attack_interrupted(_body:CollisionObject2D) -> void:
	if is_physics_processing():
		call_deferred("_stop_and_enable_collect")
	else:
		emit_signal("attack_interrupted")


func _change_hitbox_disabled(disabled:bool) -> void:
	hitbox.disabled = disabled
