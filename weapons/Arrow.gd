extends Sprite

var direction:Vector2

onready var hitbox_collision:CollisionShape2D = get_node("Hitbox/CollisionShape2D")


func shoot(pos:Vector2, dir:Vector2) -> void:
	position = pos
	direction = dir
	rotation = dir.angle() + PI/2
	set_physics_process(true)
	
	
func _physics_process(delta:float) -> void:
	position += direction * 500 * delta



func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Hitbox_attack_interrupted(body:CollisionObject2D) -> void:
	set_physics_process(false)
	hitbox_collision.set_deferred("disabled", true)
	
	if body == null:
		return
	
	call_deferred("_reparent", body)
	
	
func _reparent(new_parent:Node2D) -> void:
	get_parent().remove_child(self)
	new_parent.add_child(self)
	self.set_owner(new_parent)
	global_position = Vector2(50, 50)
