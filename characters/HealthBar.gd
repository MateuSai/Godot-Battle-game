extends TextureProgress

onready var character:Character = get_parent()

onready var health_tween:Tween = get_node("HealthTween")
onready var hide_tween:Tween = get_node("HideTween")
onready var hide_delay_timer:Timer = get_node("HideDelayTimer")


func _init() -> void:
	modulate.a = 0.0


func _on_Character_hp_changed(new_hp:int) -> void:
	var __ = hide_tween.stop_all()
	assert(__)
	modulate.a = 1.0
	
	__ = health_tween.interpolate_property(self, "value", value, (float(new_hp) / character.max_hp) * 100, 0.8)
	assert(__)
	__ = health_tween.start()
	assert(__)


func _on_HealthTween_tween_all_completed() -> void:
	hide_delay_timer.start()


func _on_HideDelayTimer_timeout() -> void:
	_hide()
	
	
func _hide() -> void:
	var __ = hide_tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.0), 0.5)
	assert(__)
	__ = hide_tween.start()
	assert(__)
