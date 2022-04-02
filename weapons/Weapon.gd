extends Node2D
class_name Weapon, "res://assets/kenney_scribbledungeons/PNG/Default (64px)/Items/weapon_sword.png"

const FRICTION:float = 0.05

var speed:int
var direction:Vector2

enum WeaponName {Sword, LongSword}
export(WeaponName) var weapon_name

onready var pick_area_collision_shape:CollisionShape2D = get_node("PickArea/CollisionShape2D")


func _ready() -> void:
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


func _on_PickArea_body_entered(body:PhysicsBody2D) -> void:
	pick_area_collision_shape.set_deferred("disabled", true)
	get_parent().call_deferred("remove_child", self)
	position = Vector2.ZERO
	rotation = 0
	body.call_deferred("pick_weapon", self)
