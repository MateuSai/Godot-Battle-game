extends Node2D
class_name Weapon, "res://assets/kenney_scribbledungeons/PNG/Default (64px)/Items/weapon_sword.png"

onready var hands:Node2D = get_node("Node2D/Hands")
onready var animation_player:AnimationPlayer = get_node("AnimationPlayer")


func change_hand_texture(hand_texture) -> void:
	for hand in hands.get_children():
		hand.texture = hand_texture
		
		
func attack() -> void:
	animation_player.play("attack")


func _on_Hitbox_attack_interrupted():
	animation_player.play_backwards("attack")
