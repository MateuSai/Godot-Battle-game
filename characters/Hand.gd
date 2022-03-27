extends Node2D
class_name Hand, "res://assets/kenney_scribbledungeons/PNG/Default (64px)/Characters/green_hand.png"

var weapon:Weapon

export var is_left:bool = false


func equip_weapon(new_weapon:Weapon, hand_texture:Texture) -> void:
	weapon = new_weapon
	if is_left:
		weapon.scale.x = -1
	add_child(weapon)
	weapon.change_hand_texture(hand_texture)
	move_child(weapon, 0)
	
	
func attack() -> void:
	if weapon == null:
		return
	
	weapon.attack()
