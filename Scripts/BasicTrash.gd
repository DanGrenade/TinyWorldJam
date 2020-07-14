extends KinematicBody2D

var gravity_node
var original_parent

export var grab_position = Vector2(120, -80)

export var max_distance = 5000

enum {state_falling, state_stationary, state_held, state_floating}
var current_state = state_falling

export var fall_speed = 500
var velocity = Vector2()

signal Trash_Hit

func spawn(target, location):
	global_position = location
	gravity_node = target
	
	velocity = (gravity_node.global_position - global_position).normalized() * fall_speed
	global_rotation = (position - gravity_node.global_position).angle() + (PI/2)
	
	original_parent = get_parent()
	pass

func _physics_process(delta):
	if current_state == state_falling:
		
		var collision_data = move_and_collide(velocity * delta)
		#If the below triggers, we've hit the player. Bounce off of them!
		if collision_data:
			if collision_data.collider.has_method("hit"):
				collision_data.collider.hit()
				current_state = state_floating
				velocity = velocity.bounce(collision_data.normal)
				move_and_collide(collision_data.remainder.bounce(collision_data.normal))
				pass
			pass
		else:
			if $RayCast2D_Left.is_colliding():
				check_hit($RayCast2D_Left.get_collider(), $RayCast2D_Left.get_collision_point())
				pass
			elif $RayCast2D_Right.is_colliding():
				check_hit($RayCast2D_Right.get_collider(), $RayCast2D_Right.get_collision_point())
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

func check_hit(collision_object, collision_point):
	gravity_node.garbage_hit(collision_point)
	queue_free()
	pass
