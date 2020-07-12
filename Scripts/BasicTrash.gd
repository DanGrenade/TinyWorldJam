extends KinematicBody2D

var gravity_node

export var max_distance = 5000

enum {state_falling, state_stationary, state_held, state_floating}
var current_state = state_falling

export var fall_speed = 500
var velocity = Vector2()

func spawn(target, location):
	global_position = location
	gravity_node = target
	
	velocity = (gravity_node.global_position - global_position).normalized() * fall_speed
	global_rotation = (position - gravity_node.position).angle() + (PI/2)
	
	pass

func _physics_process(delta):
	if current_state == state_falling:
		
		var collision_data = move_and_collide(velocity * delta)
		#If the below triggers, we've hit the player. Bounce off of them!
		if collision_data:
			if collision_data.collider.has_method("hit"):
				current_state = state_floating
				velocity = velocity.bounce(collision_data.normal)
				move_and_collide(collision_data.remainder.bounce(collision_data.normal))
				collision_data.collider.hit()
				pass
			pass
		else:
			if $RayCast2D_Left.is_colliding():
				check_hit($RayCast2D_Left.get_collider(), delta)
				pass
			elif $RayCast2D_Right.is_colliding():
				check_hit($RayCast2D_Right.get_collider(), delta)
				pass
			pass
		pass
	
	if current_state == state_floating:
		move_and_slide(velocity)
		if global_position.distance_to(gravity_node.position) > max_distance:
			queue_free()
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