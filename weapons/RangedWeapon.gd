extends Weapon
class_name RangedWeapon, "res://assets/kenney_scribbledungeons/PNG/Default (64px)/Items/weapon_bow_arrow.png"

const ARROW_SCENE:PackedScene = preload("res://weapons/Arrow.tscn")


func shoot() -> void:
	var arrow:Sprite = ARROW_SCENE.instance()
	get_tree().get_current_scene().add_child(arrow)
	arrow.shoot(global_position, Vector2.UP.rotated(global_rotation))

