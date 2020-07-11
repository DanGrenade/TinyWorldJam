extends KinematicBody2D

var velocity = Vector2()
var gravity_based_velocity = Vector2()

export var gravity_body_path = NodePath()
var gravity_body
export var ground_raycast_path = NodePath()
var ground_raycast
var grounded = false
export var gravity = 9.8
export var jumpVelocity = 300

var xInput
export var xAccel = 50
export var max_x_speed = 500
export var x_deccel_speed = 50

func _ready():
	gravity_body = get_node(gravity_body_path)
	ground_raycast = get_node(ground_raycast_path)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = (position - gravity_body.position).angle() + (PI/2)
	
	if grounded:
		# Jump
		if Input.is_action_just_pressed("jump"):
			velocity.y = jumpVelocity
			grounded = false
			pass
		pass
	
	#Get x input
	xInput = 0
	if Input.is_action_pressed("move_left"):
		xInput += 1
		pass
	if Input.is_action_pressed("move_right"):
		xInput -= 1
		pass
	
	#Apply x input
	if xInput != 0:
		velocity.x += xInput * xAccel
		
		if abs(velocity.x) > max_x_speed:
			if velocity.x > 0:
				velocity.x = max_x_speed
			else:
				velocity.x = -max_x_speed
			
			pass
		
		pass
	#If no x input, deccel
	else:
		velocity.x = move_toward(velocity.x, 0, x_deccel_speed)
		pass
	
	if velocity.x > 0.05:
		$Sprite.flip_h = false
		pass
	elif velocity.x < -0.05:
		$Sprite.flip_h = true
		pass
		
	if abs(velocity.x) > 0.1:
		$Sprite/AnimationPlayer.play("Run")
		pass
	else:
		$Sprite/AnimationPlayer.play("Stationary")
		pass
	
		
	pass

func _physics_process(delta):
	
	if not grounded:
		# If we landed on an object, we're grounded.
		if velocity.y < 0 and ground_raycast.is_colliding():
			grounded = true
			velocity.y = 0
			pass
		# Otherwise, apply gravity
		else:
			velocity.y -= gravity
			pass
	
	gravity_based_velocity = velocity.rotated((position - gravity_body.position).angle() - (PI/2))
	
	move_and_slide(gravity_based_velocity)
	pass
