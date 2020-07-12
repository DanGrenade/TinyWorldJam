extends KinematicBody2D

var gravity_node

enum {state_falling, state_stationary, state_held}
var current_state = state_falling

export var fall_speed = 200
var velocity = Vector2()

func spawn(target, location):
	global_position = location
	gravity_node = target
	
	velocity = (gravity_node.global_position - global_position).normalized() * fall_speed
	global_rotation = (position - gravity_node.position).angle() + (PI/2)
	
	pass

func _physics_process(delta):
	if current_state == state_falling:
		
		move_and_collide(velocity * delta)
		
		if $RayCast2D_Left.is_colliding():
			check_hit($RayCast2D_Left.get_collider(), delta)
			pass
		elif $RayCast2D_Right.is_colliding():
			check_hit($RayCast2D_Right.get_collider(), delta)
			pass
		pass
	pass

func check_hit(collision_object, delta):
	current_state = state_stationary
	global_rotation = (position - gravity_node.position).angle() + (PI/2)
	move_and_collide(velocity * delta)
	$RayCast2D_Left.enabled = false
	$RayCast2D_Right.enabled = false
	collision_layer = 1
	pass
