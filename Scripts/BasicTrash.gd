extends KinematicBody2D

var gravity_node

enum {state_falling, state_stationary, state_held}
var current_state = state_falling

export var fall_speed = 40
var velocity = Vector2()

func spawn(target, location):
	global_position = location
	gravity_node = target
	
	velocity = (gravity_node.global_position - global_position).normalized() * fall_speed
	
	pass

func _process(delta):
	if current_state == state_falling:
		move_and_slide(velocity)
		pass
	pass
