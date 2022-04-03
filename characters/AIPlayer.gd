extends Character

var steer_force:float = 0.1
var look_ahead:int = 100
var num_rays:int = 8

var ray_directions:PoolVector2Array = []
var interest:Array = []
var danger:Array = []

var chosen_dir:Vector2 = Vector2.ZERO

const WANDER_CIRCLE_RADIUS:int = 8
const WANDER_RANDOMNESS:float = 0.2
var wander_angle:float = 0
var wandering:bool = true

var enclosure_zone:Rect2 = Rect2(25, 25, 1230, 670)

var characters_in_range:Array = []
var target:Character = null setget set_target
var target_in_range:bool = false

onready var game:Node2D = get_tree().get_current_scene()

onready var search_target_cooldown_timer:Timer = get_node("SearchTargetCooldownTimer")
onready var attack_cooldown_timer:Timer = get_node("AttackCooldownTimer")
onready var attack_delay_timer:Timer = get_node("AttackDelayTimer")


func _init() -> void:
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle:float = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
		interest[i] = 0.0
		danger[i] = 0.0
		
	speed = 200


func _ready() -> void:
	pick_weapon(preload("res://weapons/Sword.tscn").instance())
	self.target = _get_closest_enemy()
	
	
func _draw() -> void:
	for i in num_rays:
		draw_line(Vector2.ZERO, ray_directions[i].rotated(rotation) * interest[i] * look_ahead, Color.green, 8)
		draw_line(Vector2.ZERO, ray_directions[i].rotated(rotation) * danger[i] * look_ahead, Color.red, 8)
	
	
func _physics_process(_delta:float) -> void:
	_set_interest()
	_set_danger()
	_choose_direction()
	face_direction = mov_direction
	update()
	
	
func _set_interest() -> void:
	if target:
		var path:PoolVector2Array = game.get_nav_path(position, target.position)
		var path_direction:Vector2 = path[1] - position
		for i in num_rays:
			var d:float = ray_directions[i].rotated(rotation).dot(path_direction.normalized())
			interest[i] = max(0, d)
	else:
		_set_interest_wander()
		
		
func _set_interest_wander() -> void:
	var steering:Vector2 = _wander_steering()
	steering += _enclosure_steering()
	steering = steering
	
	for i in num_rays:
		var d:float = ray_directions[i].rotated(rotation).dot(steering.normalized())
		interest[i] = max(0, d)
		
		
func _set_danger() -> void:
	var space_state:Physics2DDirectSpaceState = get_world_2d().direct_space_state
	for i in num_rays:
		var result:Dictionary = space_state.intersect_ray(position, position + ray_directions[i].rotated(rotation) * look_ahead, [self], 11, true, true)
		danger[i] = 1.0 if result else 0.0
		
		
func _choose_direction() -> void:
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
		
	mov_direction = Vector2.ZERO
	for i in num_rays:
		mov_direction += ray_directions[i] * interest[i]
	mov_direction = mov_direction.normalized()
	
	
func _seek_steering(vector_to_target: Vector2) -> Vector2:
	var desired_velocity: Vector2 = vector_to_target.normalized() * speed
	
	return desired_velocity - velocity
	
	
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
	
	
func _get_closest_enemy() -> Character:
	if characters_in_range.size() == 0:
		return null
		
	var closest_character:Character = characters_in_range[characters_in_range.size() - 1]
	
	for i in range(characters_in_range.size() - 2, -1, -1):
		var character:Character = characters_in_range[i]
		if character == null:
			characters_in_range.remove(i)
			
		if (character.position - position).length() < (closest_character.position - position).length():
			target = character
	
	return closest_character
	
	
func set_target(new_target:Character) -> void:
	target = new_target
	
	search_target_cooldown_timer.start()
	while target == null:
		target = _get_closest_enemy()
		yield(search_target_cooldown_timer, "timeout")
		
	search_target_cooldown_timer.stop()
	
	print("while ended, target is " + target.name)


func _on_CharacterDetector_body_entered(body:Character) -> void:
	if body != self:
		characters_in_range.append(body)


func _on_CharacterDetector_body_exited(body:Character) -> void:
	characters_in_range.erase(body)
	
	if body == target:
		self.target = null


func _on_AttackRange_body_entered(body:Character) -> void:
	if body == self:
		return
		
	target_in_range = true
	attack_cooldown_timer.start()
	while target_in_range:
		attack_delay_timer.start()
		yield(attack_delay_timer, "timeout")
		right_hand.attack()
		yield(attack_cooldown_timer, "timeout")
		
	attack_cooldown_timer.stop()


func _on_AttackRange_body_exited(_body:Character) -> void:
	target_in_range = false
