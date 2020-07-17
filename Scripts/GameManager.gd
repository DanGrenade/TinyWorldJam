extends Node2D

signal switch_game_state_signal(pause_state)

enum {state_start, state_playing, state_escape, state_fail}
var current_state = state_start

func _ready():
	stop_game()
	pass

func _process(delta):
	if Input.is_action_pressed("pause_game"):
		if current_state == state_playing:
			stop_game()
			pass
		elif current_state == state_escape:
			continue_game()
			pass
		pass
	pass

func stop_game():
	emit_signal("switch_game_state_signal", true)
	pass

func continue_game():
	emit_signal("switch_game_state_signal", false)
	pass


func _on_Start_Menu_Start_Button_Pressed():
	current_state = state_playing
	continue_game()
	pass


func _on_Start_Menu_Continue_Button_Pressed():
	current_state = state_playing
	continue_game()	
	pass

func game_over():
	stop_game()
	$GameOver.visible = true
	$GameOver.give_focus()
	pass


func _on_Alien_Ship_ship_hit():
	game_over()
	pass


func _on_PlayerCharacter_player_death():
	game_over()
	pass 


func _on_GameOver_Replay_Signal():
	get_tree().reload_current_scene()	
	pass 
