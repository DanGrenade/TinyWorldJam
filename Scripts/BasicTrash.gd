extends KinematicBody2D

var game_paused = false

var gravity_node
var original_parent

var particles = preload("res://Scenes/BoxParticles.tscn")

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
	global_rotation = (global_position - gravity_node.global_position).angle() + (PI/2)
	
	original_parent = get_parent()
	original_parent.get_parent().connect("switch_game_state_signal", self, "_on_GameManager_switch_game_state_signal")
	pass

func _physics_process(delta):
	if game_paused: return
	
	if current_state == state_falling:
		velocity = (gravity_node.global_position - global_position).normalized() * fall_speed
		var collision_data = move_and_collide(velocity * delta)
		#If the below triggers, we've hit the player. Bounce off of them!
		if collision_data && collision_data.normal.dot(velocity) < -0.3 && collision_data.collider.has_method("hit"):
			collision_data.collider.hit()
			current_state = state_floating
			velocity = -velocity
			move_and_collide(collision_data.remainder.bounce(collision_data.normal))
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
	
	var particle_instance = particles.instance()
	original_parent.add_child(particle_instance)
	particle_instance.global_position = global_position
	particle_instance.rotation = rotation
	particle_instance.emitting = true
	
	queue_free()
	pass
	
func _on_GameManager_switch_game_state_signal(pause_state):
	game_paused = pause_state
	pass
