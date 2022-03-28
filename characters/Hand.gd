extends Node2D
class_name Hand, "res://assets/kenney_scribbledungeons/PNG/Default (64px)/Characters/green_hand.png"

var weapon:Weapon

export var is_left:bool = false

signal change_hitbox_disabled(disabled)

onready var weapon_container:Node2D = get_node("Pivot")
onready var sprite:Sprite = weapon_container.get_node("Sprite")
onready var animation_player:AnimationPlayer = get_node("AnimationPlayer")


func equip_weapon(new_weapon:Weapon) -> void:
	weapon = new_weapon
	if is_left:
		weapon.scale.x = -1
	
	var __ = weapon.connect("attack_interrupted", self, "_on_attack_interrupted")
	assert(not __)
	__ = connect("change_hitbox_disabled", weapon, "_change_hitbox_disabled")
	assert(not __)
	
	weapon_container.add_child(weapon)
	weapon_container.move_child(weapon, 0)
	
	
func has_weapon() -> bool:
	return weapon != null
	
	
func throw_weapon(dir:Vector2) -> void:
	if weapon == null:
		return
		
	weapon.disconnect("attack_interrupted", self, "_on_attack_interrupted")
	disconnect("change_hitbox_disabled", weapon, "_change_hitbox_disabled")
	
	weapon_container.remove_child(weapon)
	weapon.rotation = weapon_container.global_rotation
	weapon.position = weapon_container.global_position
	get_tree().get_current_scene().add_child(weapon)
	weapon.throw(dir, 800)
	weapon = null
	
	
func attack() -> void:
	if weapon == null:
		return
	
	animation_player.play("sword_attack")
	
	
func _on_attack_interrupted() -> void:
	animation_player.play_backwards("sword_attack")
	
	
func change_hitbox_disabled(disabled:bool) -> void:
	emit_signal("change_hitbox_disabled", disabled)
