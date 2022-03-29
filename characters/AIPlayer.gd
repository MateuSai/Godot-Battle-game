extends Character

const WANDER_CIRCLE_RADIUS:int = 8
const WANDER_RANDOMNESS:float = 0.2
var wander_angle:float = 0

var enclosure_zone:Rect2 = Rect2(16, 16, 1264, 704)

var target:Character = null


func _process(_delta:float) -> void:
	mov_direction = wander()
	
	
func enclosure_steering() -> Vector2:
	var desired_velocity: Vector2 = Vector2.ZERO
	
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
	
	
func wander() -> Vector2:
	wander_angle = rand_range(wander_angle - WANDER_RANDOMNESS, wander_angle + WANDER_RANDOMNESS)
	
	var vector_to_cicle: Vector2 = velocity.normalized() * speed
	var desired_velocity: Vector2 = vector_to_cicle + Vector2(WANDER_CIRCLE_RADIUS, 0).rotated(wander_angle)
	
	return (desired_velocity - velocity).normalized()

