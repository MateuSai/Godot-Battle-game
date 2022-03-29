extends Character

const WANDER_CIRCLE_RADIUS:int = 8
const WANDER_RANDOMNESS:float = 0.2
var wander_angle:float = 0
var wandering:bool = true

var enclosure_zone:Rect2 = Rect2(25, 25, 1230, 670)

var max_steering:float = 15
var avoid_force:int = 1000

var target:Character = null

onready var raycasts:Node2D = get_node("Raycasts")


func _physics_process(_delta:float) -> void:
	var steering: Vector2 = Vector2.ZERO
	
	if wandering:
		steering += _enclosure_steering()
		steering += _wander_steering()
	else:
		var vector_to_target: Vector2 = Vector2.ZERO
		steering += _seek_steering(vector_to_target)
			
	steering += _avoid_obstacles_steering()
	steering = steering.clamped(max_steering)
	
	velocity += steering
	velocity = velocity.clamped(speed)
	
	face_direction = velocity.normalized()
	
	
func _seek_steering(vector_to_target: Vector2) -> Vector2:
	var desired_velocity: Vector2 = vector_to_target.normalized() * speed
	
	return desired_velocity - velocity
	
	
func _avoid_obstacles_steering() -> Vector2:
	raycasts.rotation = velocity.angle()
	
	for raycast in raycasts.get_children():
		raycast.cast_to.x = velocity.length()
		if raycast.is_colliding():
			var obstacle:Node2D = raycast.get_collider()
			return (position + velocity - obstacle.position).normalized() * avoid_force
			
	return Vector2.ZERO
	
	
func _enclosure_steering() -> Vector2:
	var desired_velocity:Vector2 = Vector2.ZERO
	
	if position.x < enclosure_zone.position.x:
		desired_velocity.x += 1
	elif position.x > enclosure_zone.position.x + enclosure_zone.size.x:
		desired_velocity.x -= 1
	if position.y < enclosure_zone.position.y:
		desired_velocity.y += 1
	elif position.y > enclosure_zone.position.y + enclosure_zone.size.y:
		desired_velocity.y -= 1
		
	desired_velocity = desired_velocity.normalized() * speed
	if desired_velocity != Vector2.ZERO:
		wander_angle = desired_velocity.angle()
		return desired_velocity - velocity
	else:
		return Vector2.ZERO
	
	
func _wander_steering() -> Vector2:
	wander_angle = rand_range(wander_angle - WANDER_RANDOMNESS, wander_angle + WANDER_RANDOMNESS)
	
	var vector_to_cicle: Vector2 = velocity.normalized() * speed
	var desired_velocity: Vector2 = vector_to_cicle + Vector2(WANDER_CIRCLE_RADIUS, 0).rotated(wander_angle)
	
	return desired_velocity - velocity

