extends KinematicBody2D

signal ship_hit

var game_paused = false

export var float_adjustment = 1
export var float_speed = 1.5
export var ship_speed = 10
var velocity = Vector2()

var max_distance = 1300

export var planet_string = NodePath()
var planet_node

func _ready():
	$AnimationPlayer.play("Patrol")
	planet_node = get_node(planet_string)
	
	velocity.x = ship_speed
	pass

func _process(delta):
	if game_paused: return
	
	$ufo.global_rotation = (position - planet_node.position).angle() + (1.5 * PI/2)
	pass

func _physics_process(delta):
	if game_paused: return
	
	velocity.y = sin(OS.get_unix_time() * float_speed) * float_adjustment
	
	var gravity_based_velocity = velocity.rotated((position - planet_node.position).angle() - (PI/2))
	
	var collision = move_and_collide(gravity_based_velocity)
	if collision: emit_signal("ship_hit")
	
	if position.distance_to(planet_node.position) > max_distance:
		position = position.move_toward(planet_node.position, position.distance_to(planet_node.position) - max_distance)
		pass
	
	pass


func _on_GameManager_switch_game_state_signal(pause_state):
	game_paused = pause_state
	pass 
