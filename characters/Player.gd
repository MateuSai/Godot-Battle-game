extends Character
class_name Player

enum Controls {AI, MouseKeyboard, Gamepad}

var controls:int


func initialize(pos:Vector2, character_color:int, cont:int = 0) -> void:
	.initialize(pos, character_color, cont)
	controls = cont


func _ready() -> void:
	pick_weapon(preload("res://weapons/Sword.tscn").instance())
	#pick_weapon(preload("res://weapons/Sword.tscn").instance())
	#pick_weapon(preload("res://weapons/LongSword.tscn").instance())
	#pick_weapon(preload("res://weapons/Crossbow.tscn").instance())
	pick_weapon(preload("res://weapons/CurvedShield.tscn").instance())


func _get_input() -> void:
	var extra_text_end_action:String = "_controller" if controls == Controls.Gamepad else ""
	
	mov_direction = Input.get_vector("ui_left" + extra_text_end_action, "ui_right" + extra_text_end_action, "ui_up" + extra_text_end_action, "ui_down" + extra_text_end_action)
	
	if Input.is_action_just_pressed("ui_attack" + extra_text_end_action):
		right_hand.attack()
	elif right_hand.has_shield() and Input.is_action_just_released("ui_attack" + extra_text_end_action):
		right_hand.put_away_shield()
	if Input.is_action_just_pressed("ui_attack_left" + extra_text_end_action):
		left_hand.attack()
	elif left_hand.has_shield() and Input.is_action_just_released("ui_attack_left" + extra_text_end_action):
		left_hand.put_away_shield()
		
	if Input.is_action_just_pressed("ui_dash" + extra_text_end_action):
		dash()
	if (Input.is_action_just_pressed("ui_throw" + extra_text_end_action)):
		right_hand.throw_weapon(face_direction.normalized())
	
	
func _process(_delta:float) -> void:
	_get_input()
	
	if controls == Controls.MouseKeyboard:
		face_direction = (get_global_mouse_position() - position).normalized()
	else:
		if mov_direction != Vector2.ZERO:
			face_direction = mov_direction
