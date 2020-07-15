extends KinematicBody2D

export var float_adjustment = 1
export var float_speed = 1.5
export var ship_speed = 10
var velocity = Vector2()

var max_distance = 1300

export var planet_string = NodePath()
var planet_node

func _ready():
	planet_node = get_node(planet_string)
	
	velocity.x = ship_speed
	pass

func _process(delta):
	$ufo.global_rotation = (position - planet_node.position).angle() + (1.5 * PI/2)
	pass

func _physics_process(delta):
	
	velocity.y = sin(OS.get_unix_time() * float_speed) * float_adjustment
	
	var gravity_based_velocity = velocity.rotated((position - planet_node.position).angle() - (PI/2))
	
	move_and_collide(gravity_based_velocity)
	
	if position.distance_to(planet_node.position) > max_distance:
		position = position.move_toward(planet_node.position, position.distance_to(planet_node.position) - max_distance)
		pass
	
	pass
