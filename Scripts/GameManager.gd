extends Node2D

signal switch_game_state_signal(pause_state)

var game_time = 0

enum {state_start, state_playing, state_pause, state_fail}
var current_state = state_start

func _ready():
	stop_game()
	pass

func _process(delta):
	if current_state == state_playing:
		game_time += delta
		$Game_Time.update_time(game_time)
		pass
	
	if Input.is_action_just_pressed("pause_game"):
		if current_state == state_playing:
			stop_game()
			current_state = state_pause
			$Start_Menu.visible = true
			pass
		elif current_state == state_pause:
			continue_game()
			$Start_Menu.visible = false
			current_state = state_playing
			pass
		pass
	pass

func stop_game():
	emit_signal("switch_game_state_signal", true)

	pass

func continue_game():
	emit_signal("switch_game_state_signal", false)
	$Audio.play_confirm_sfx()
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
	current_state = state_fail
	$GarbageSpawner.visible = false
	$GameOver.visible = true
	$GameOver.give_focus()
	
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
