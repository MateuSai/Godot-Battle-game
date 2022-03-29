extends Node2D


func _ready() -> void:
	var player:Character = preload("res://characters/Player.tscn").instance()
	player.initialize(Vector2(200, 200), Character.CharacterColor.Green, Character.Controls.MouseKeyboard)
	add_child(player)
	
	var player2:Character = preload("res://characters/Player.tscn").instance()
	player2.initialize(Vector2(800, 500), Character.CharacterColor.Purple, Character.Controls.Gamepad)
	add_child(player2)
	
	
	var player3:Character = preload("res://characters/AIPlayer.tscn").instance()
	player3.initialize(Vector2(900, 550), Character.CharacterColor.Purple)
	add_child(player3)
