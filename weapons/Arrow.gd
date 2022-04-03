extends Sprite
class_name Arrow

var direction:Vector2

var collided:bool = false

onready var hitbox_collision:CollisionShape2D = get_node("Hitbox/CollisionShape2D")


func shoot(pos:Vector2, dir:Vector2) -> void:
	position = pos
	direction = dir
	rotation = dir.angle() + PI/2
	set_physics_process(true)
	
	
func _physics_process(delta:float) -> void:
	position += direction * 500 * delta



func _on_VisibilityNotifier2D_screen_exited() -> void:
	if not collided:
		queue_free()


func _on_Hitbox_attack_interrupted(body:CollisionObject2D) -> void:
	set_physics_process(false)
	hitbox_collision.set_deferred("disabled", true)
	
	if body == null: # collided with a tile
		return
	
	call_deferred("_reparent", body)
	
	
func _reparent(new_parent:Node2D) -> void:
	collided = true
	get_parent().remove_child(self)
	new_parent.add_child(self)
	self.set_owner(new_parent)
	global_position = position
	global_rotation = rotation
