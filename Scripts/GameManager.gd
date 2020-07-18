extends Node2D

signal switch_game_state_signal(pause_state)

enum {state_start, state_playing, state_escape, state_fail}
var current_state = state_start

func _ready():
	stop_game()
	pass

func _process(delta):
	if Input.is_action_pressed("pause_game"):
		print(current_state)
		if current_state == state_playing:
			stop_game()
			$Start_Menu.visible = true
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
	$Audio.play_confirm_sfx()




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
	$CanvasLayer/GameOver.visible = true
	$CanvasLayer/GameOver.give_focus()
	
	$Audio.play_menu_bg()
	pass


func _on_Alien_Ship_ship_hit():
	$Camera2D.shaking = true
	$Camera2D.current_shake = $Camera2D.max_shake
	$Camera2D.do_shake()
	$Alien_Ship/CollisionShape2D.disabled = true
	$Audio.play_explosion_sfx()
	$Alien_Ship/AnimationPlayer.play("Damaged")
	yield($Alien_Ship/AnimationPlayer, "animation_finished")
	game_over()
	pass


func _on_PlayerCharacter_player_death():
	game_over()
	pass 


func _on_GameOver_Replay_Signal():
	get_tree().reload_current_scene()	
	pass 
