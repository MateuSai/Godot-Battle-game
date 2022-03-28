extends KinematicBody2D
class_name Character, "res://assets/kenney_scribbledungeons/PNG/Default (64px)/Characters/green_character.png"

enum Controls {AI, MouseKeyboard, Gamepad}

var controls:int

var hp:int = 3 setget set_hp

var acceleration:float = 0.35
var friction:float = 0.1
var speed:int = 300

var mov_direction:Vector2 = Vector2.ZERO
var face_direction:Vector2 = Vector2.ZERO
var velocity:Vector2 = Vector2.ZERO

var dash_force:int = 2000

enum CharacterColor {Green, Purple}

var texture:Texture
var hand_texture:Texture

onready var sprite:Sprite = get_node("Sprite")
onready var hands:Node2D = get_node("Hands")
onready var left_hand:Hand = hands.get_node("LeftHand")
onready var right_hand:Hand = hands.get_node("RightHand")
onready var animation_player:AnimationPlayer = get_node("AnimationPlayer")
onready var dash_timer:Timer = get_node("DashTimer")


func initialize(pos:Vector2, character_color:int, cont:int = 0) -> void:
	position = pos
	controls = cont
	
	var color:String = CharacterColor.keys()[character_color].to_lower()
	texture = load("res://assets/kenney_scribbledungeons/PNG/Default (64px)/Characters/" + color + "_character.png")
	hand_texture = load("res://assets/kenney_scribbledungeons/PNG/Default (64px)/Characters/" + color + "_hand.png")
	
	
func _ready() -> void:
	sprite.texture = texture
	
	for hand in hands.get_children():
		hand.sprite.texture = hand_texture


func _process(_delta:float) -> void:
	hands.rotation = face_direction.angle() + PI/2


func _physics_process(_delta:float) -> void:
	if (mov_direction != Vector2.ZERO):
		velocity = velocity.linear_interpolate(mov_direction * speed, acceleration)
	
	velocity = move_and_slide(velocity)
	
	velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	
	
func take_damage(damage:int, knockback_direction:Vector2, knockback_force:int) -> void:
	animation_player.play("hurt")
	velocity += knockback_direction * knockback_force
	self.hp -= damage
	
	
func pick_weapon(weapon:Weapon) -> void:
	if not right_hand.has_weapon():
		right_hand.equip_weapon(weapon)
	elif not left_hand.has_weapon():
		left_hand.equip_weapon(weapon)
	
	
func dash() -> void:
	if mov_direction == Vector2.ZERO or dash_timer.time_left > 0:
		return
		
	velocity += mov_direction * dash_force
	
	dash_timer.start()
	
	
func set_hp(new_value:int) -> void:
	hp = new_value
	if hp <= 0:
		queue_free()
