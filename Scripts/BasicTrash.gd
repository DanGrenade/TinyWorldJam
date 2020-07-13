extends KinematicBody2D

var gravity_node
var original_parent

export var grab_position = Vector2(120, -80)

export var max_distance = 5000

enum {state_falling, state_stationary, state_held, state_floating}
var current_state = state_falling

export var fall_speed = 500
var velocity = Vector2()

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
	setup_stationary()
	pass
	
func setup_stationary():
	current_state = state_stationary
	
	collision_layer = 2
	$CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = false
	global_rotation = (position - gravity_node.position).angle() + (PI/2)
	move_and_collide(velocity)
	$RayCast2D_Left.enabled = false
	$RayCast2D_Right.enabled = false
	pass

func place(new_position):
	$CollisionShape2D.disabled = false
	get_parent().remove_child(self)
	original_parent.add_child(self)
	
	position = new_position
	
	velocity = (gravity_node.global_position - global_position).normalized() * fall_speed
	
	setup_stationary()
	pass

func grab(player):
	$CollisionShape2D.disabled = true
	
	get_parent().remove_child(self)
	player.add_child(self)
	
	position = grab_position
	rotation = 0
	
	pass
