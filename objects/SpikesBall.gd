extends RigidBody2D

const DIAMETER:int = 32


func take_damage(_damage:int, dir:Vector2, impulse:int) -> void:
	apply_impulse(-dir * (DIAMETER/2.0), dir * impulse)

