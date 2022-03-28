extends Node2D


func _ready() -> void:
	var player:Character = preload("res://characters/Player.tscn").instance()
	player.initialize(Vector2(200, 200), Character.CharacterColor.Purple, Character.Controls.Gamepad)
	add_child(player)
	
	var character:Character = preload("res://characters/Character.tscn").instance()
	character.initialize(Vector2(800, 500), Character.CharacterColor.Purple)
	add_child(character)
