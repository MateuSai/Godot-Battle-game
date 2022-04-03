extends Node2D
class_name Weapon, "res://assets/kenney_scribbledungeons/PNG/Default (64px)/Items/weapon_sword.png"

const FRICTION:float = 0.05

var speed:int
var direction:Vector2

var initial_rotation:float

enum WeaponName {Sword, LongSword, Crossbow, CurvedShield}
export(WeaponName) var weapon_name

onready var character:KinematicBody2D = get_node("../../../../..")

onready var pick_area_collision_shape:CollisionShape2D = get_node("PickArea/CollisionShape2D")


func _enter_tree() -> void:
	character = get_node_or_null("../../../../..")


func _ready() -> void:
	initial_rotation = rotation
	set_physics_process(false);


func _physics_process(delta:float) -> void:
	position += direction * speed * delta
	speed = lerp(speed, 0, FRICTION)
	if speed <= 1:
		_stop_and_enable_collect()
		
		
func _stop_and_enable_collect() -> void:
	pick_area_collision_shape.disabled = false
	set_physics_process(false)
	
	
func throw(dir:Vector2, impulse:int) -> void:
	direction = dir
	speed = impulse
	set_physics_process(true)
	
	
func apply_knockback(dir:Vector2, impulse:int) -> void:
	character.take_damage(0, dir, impulse)


func _on_PickArea_body_entered(body:PhysicsBody2D) -> void:
	pick_area_collision_shape.set_deferred("disabled", true)
	get_parent().call_deferred("remove_child", self)
	position = Vector2.ZERO
	rotation = initial_rotation
	body.call_deferred("pick_weapon", self)
