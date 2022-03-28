extends Area2D
class_name Hitbox

export var damage:int = 1
var knockback_direction:Vector2 = Vector2.ZERO
export var knockback_force:int = 450

var body_inside:bool = false

signal attack_interrupted()

onready var collision_shape:CollisionShape2D = get_child(0)
onready var timer:Timer = Timer.new()


func _init() -> void:
	var __ = connect("body_entered", self, "_on_body_entered")
	__ = connect("body_exited", self, "_on_body_exited")
	
	
func _ready() -> void:
	assert(collision_shape != null)
	timer.wait_time = 1
	add_child(timer)
	
	
func _on_body_entered(body:PhysicsBody2D) -> void:
	body_inside = true
	timer.start()
	while body_inside:
		_collide(body)
		yield(timer, "timeout")
	
	
func _on_body_exited(_body:PhysicsBody2D) -> void:
	body_inside = false
	timer.stop()
	
	
func _collide(body:PhysicsBody2D) -> void:
	if body == null or not body.has_method("take_damage"):
		emit_signal("attack_interrupted")
	else:
		knockback_direction = (body.position - global_position).normalized()
		body.take_damage(damage, knockback_direction, knockback_force)
