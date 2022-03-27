extends Character


func _ready() -> void:
	right_hand.equip_weapon(preload("res://weapons/Sword.tscn").instance(), hand_texture)
	#left_hand.equip_weapon(preload("res://weapons/Sword.tscn").instance(), hand_texture)


func _get_input() -> void:
	mov_direction.x = Input.get_axis("ui_left", "ui_right")
	mov_direction.y = Input.get_axis("ui_up", "ui_down")
	
	if Input.is_action_just_pressed("ui_attack"):
		right_hand.attack()
		left_hand.attack()
	
	
func _process(_delta:float) -> void:
	_get_input()
	face_direction = (get_global_mouse_position() - position).normalized()
