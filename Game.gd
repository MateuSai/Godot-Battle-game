extends Node2D

var count:int = 0

onready var player_container:Node2D = get_node("Players")
onready var count_down_timer:Timer = get_node("CountDownTimer")
onready var count_down_label:Label = get_node("CanvasLayer/CountDownLabel")


func _ready() -> void:
	var player:Character = preload("res://characters/Player.tscn").instance()
	player.initialize(Vector2(200, 200), Character.CharacterColor.Green, Player.Controls.MouseKeyboard)
	player_container.add_child(player)
	
	var player2:Character = preload("res://characters/Player.tscn").instance()
	player2.initialize(Vector2(800, 500), Character.CharacterColor.Purple, Player.Controls.Gamepad)
	player_container.add_child(player2)
	
	
#	var player3:Character = preload("res://characters/AIPlayer.tscn").instance()
#	player3.initialize(Vector2(900, 550), Character.CharacterColor.Purple)
#	player_container.add_child(player3)
	
	for character in player_container.get_children():
		character.set_can_move(false)


func _on_CountDown_timeout() -> void:
	count -= 1
	
	if count < 0:
		count_down_timer.stop()
		count_down_label.queue_free()
		for character in player_container.get_children():
			character.set_can_move(true)
	
	count_down_label.text = str(count)
