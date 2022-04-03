extends Area2D
class_name Hitbox

export var damage:int = 1
export var knockback_force:int = 550

var body_inside:bool = false

signal attack_interrupted(body)

onready var collision_shape:CollisionShape2D = get_child(0)
onready var timer:Timer = Timer.new()


func _init() -> void:
	var __ = connect("body_entered", self, "_on_body_entered")
	__ = connect("body_exited", self, "_on_body_exited")
	__ = connect("area_entered", self, "_on_area_entered")
	
	
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
	
	
func _on_area_entered(area:Area2D) -> void:
	_collide(area)
	
	
func _collide(body:CollisionObject2D) -> void:
	if body == null: # collided with a tile
		emit_signal("attack_interrupted", body)
	else:
		if body.get_parent() is Weapon and body.get_parent().character == get_parent().character:
			return
		elif not body.has_method("take_damage"):
			emit_signal("attack_interrupted", body)
			var knockback_direction:Vector2 = _get_knockback_dir(body)
			body.get_parent().apply_knockback(knockback_direction, knockback_force)
		else:
			var knockback_direction:Vector2 = _get_knockback_dir(body)
			body.take_damage(damage, knockback_direction, knockback_force)
		
		
func _get_knockback_dir(body:CollisionObject2D) -> Vector2:
	return (body.position - global_position).normalized()
