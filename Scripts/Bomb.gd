extends KinematicBody2D

var game_paused

export var drop_velocity = 5
var gravity_node
var alien

var velocity

var parent_node

enum {state_falling, state_stationary, state_held}
var current_state = state_falling

func initialize(planet_node, alien_node):
	gravity_node = planet_node
	alien = alien_node
	
	parent_node = get_parent()
	parent_node.get_parent().connect("switch_game_state_signal", self, "_on_GameManager_switch_game_state_signal")
	
	
	drop_bomb()
	pass

func drop_bomb():
	$bomb/AnimationPlayer.play("Idle")
	global_position = alien.global_position	
	current_state = state_falling
	if state_held:
		get_parent().remove_child(self)
		parent_node.add_child(self)
		pass
	
	global_rotation = (global_position - gravity_node.global_position).angle() + (PI/2)
	pass

func _physics_process(delta):
	if game_paused: return
	
	
	if current_state == state_held:  global_rotation = (global_position - gravity_node.global_position).angle() + (PI/2)
	
	velocity = (gravity_node.global_position - global_position).normalized() * drop_velocity
	
	if current_state != state_held:
		var collision_data = move_and_collide(velocity)
		if current_state == state_falling && collision_data:
			current_state = state_stationary
			$bomb/AnimationPlayer.play("Prepare_explosion")
			$ExplosionTimer.start()
			pass
		pass
	pass

func pickup(placement_node):
	$bomb/AnimationPlayer.play("Prepare_explosion")
	if $ExplosionTimer.is_stopped(): $ExplosionTimer.start()
	
	get_parent().remove_child(self)
	current_state = state_held
	placement_node.add_child(self)
	global_position = placement_node.global_position
	
	pass

func place(position):
	
	current_state = state_stationary
	$bomb/AnimationPlayer.play("Idle")
	get_parent().remove_child(self)
	parent_node.add_child(self)
	
	global_position = position.move_toward(gravity_node.global_position, 80)
	
	pass


func _on_ExplosionTimer_timeout():
	gravity_node.explode(position)
	$bomb/AnimationPlayer.play("Explode")
	yield($bomb/AnimationPlayer, "animation_finished")
	drop_bomb()
	$AudioStreamPlayer2D.play()

	
	pass
	
func _on_GameManager_switch_game_state_signal(pause_state):
	game_paused = pause_state
	if game_paused:
		$bomb/AnimationPlayer.stop(false)
		$ExplosionTimer.paused = true
		pass
	else: 
		$bomb/AnimationPlayer.play()
		$ExplosionTimer.paused = false
		pass
	pass
