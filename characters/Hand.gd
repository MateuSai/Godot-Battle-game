extends Node2D
class_name Hand, "res://assets/kenney_scribbledungeons/PNG/Default (64px)/Characters/green_hand.png"

var weapon:Weapon

export var is_left:bool = false

signal change_hitbox_disabled(disabled)

onready var pivot:Node2D = get_node("Pivot")
onready var pivot2:Node2D = get_node("Pivot/Pivot2")
onready var sprite:Sprite = pivot2.get_node("Sprite")
onready var animation_player:AnimationPlayer = get_node("AnimationPlayer")


func equip_weapon(new_weapon:Weapon) -> void:
	weapon = new_weapon
	if is_left:
		weapon.scale.x = -1
	
	if weapon is MeleeWeapon:
		var __ = weapon.connect("attack_interrupted", self, "_on_attack_interrupted")
		assert(not __)
		__ = connect("change_hitbox_disabled", weapon, "_change_hitbox_disabled")
		assert(not __)
	
	pivot2.add_child(weapon)
	pivot2.move_child(weapon, 0)
	
	
func has_weapon() -> bool:
	return weapon != null
	
	
func has_shield() -> bool:
	return has_weapon() and weapon.weapon_name == Weapon.WeaponName.CurvedShield
	
	
func get_attack_duration() -> float:
	return animation_player.current_animation_length
	
	
func throw_weapon(dir:Vector2) -> void:
	if weapon == null:
		return
	
	if weapon is MeleeWeapon:
		weapon.disconnect("attack_interrupted", self, "_on_attack_interrupted")
		disconnect("change_hitbox_disabled", weapon, "_change_hitbox_disabled")
	
	pivot2.remove_child(weapon)
	weapon.rotation = pivot2.global_rotation
	weapon.position = pivot2.global_position
	get_tree().get_current_scene().add_child(weapon)
	weapon.throw(dir, 800)
	weapon = null
	
	
func attack() -> void:
	if weapon == null:
		return
	
	match weapon.weapon_name:
		Weapon.WeaponName.Sword:
			animation_player.play("sword_attack")
		Weapon.WeaponName.LongSword:
			animation_player.play("long_sword_attack")
		Weapon.WeaponName.Crossbow:
			_shoot()
		Weapon.WeaponName.CurvedShield:
			animation_player.play("cover")
			
			
func _shoot() -> void:
	weapon.shoot()
	
	
func _on_attack_interrupted() -> void:
	match weapon.weapon_name:
		Weapon.WeaponName.Sword:
			animation_player.play_backwards("sword_attack")
		Weapon.WeaponName.LongSword:
			animation_player.play_backwards("long_sword_attack")
		Weapon.WeaponName.CurvedShield:
			animation_player.play_backwards("cover")
			
			
func put_away_shield() -> void:
	_on_attack_interrupted()
	
	
func change_hitbox_disabled(disabled:bool) -> void:
	emit_signal("change_hitbox_disabled", disabled)
