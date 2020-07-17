extends KinematicBody2D


var game_stopped = false

signal player_hit
signal player_jump
signal player_interact
export var max_health = 3
var current_health
signal player_death

var holding = false
var holding_trash = false

var velocity = Vector2()
var gravity_based_velocity = Vector2()

export var gravity_body_path = NodePath()
var gravity_body
var grounded = false
export var gravity = 30
export var jumpVelocity = 900

var xInput
export var xAccel = 50
export var max_x_speed = 500
export var x_deccel_speed = 50

func _ready():
	gravity_body = get_node(gravity_body_path)
	
	game_initialize()
	pass

func game_initialize():
	current_health = max_health
	pass

func _process(delta):
	if game_stopped: return
	
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
	
	if Input.is_action_just_pressed("box_grab"):
		emit_signal("player_interact")
		if holding && holding_trash == false:
			if $BombPlace.get_child_count() == 0:
				holding = false
				pass
			pass
		
		if holding == false:
			if $BombCheck.get_overlapping_bodies():
				var bomb = $BombCheck.get_overlapping_bodies().front()
				holding = true
				holding_trash = false
				bomb.pickup($BombPlace)
				
				pass
			elif gravity_body.Check_Grab(rotation + (2 * PI / 12)):
				$trash_placeholder2.visible = true
				holding = true
				holding_trash = true
				pass
			pass
		else:
			if holding_trash == false:
				$BombPlace.get_child(0).place(global_position)
				holding = false
				pass
			else:
				gravity_body.drop_trash(rotation + (2 * PI / 12))
				$trash_placeholder2.visible = false
				holding = false
				pass
	
	#Flip sprite based on movement direction
	if velocity.x > 0.05:
		if $Sprite.flip_h == true:
			$Sprite.flip_h = false
			$trash_placeholder2.position.x *= -1
			$BombCheck.position.x *= -1
			$BombPlace.position.x *= -1
			pass
		pass
	elif velocity.x < -0.05:
		if $Sprite.flip_h != true:
			$Sprite.flip_h = true
			$trash_placeholder2.position.x *= -1
			$BombCheck.position.x *= -1
			$BombPlace.position.x *= -1
		pass
		
	#Change animation based on state
	#Note: May want to shift this control to a separate node if animation becomes more complex
	if abs(velocity.x) > 0.1:
		$Sprite/AnimationPlayer.play("Run")
		pass
	else:
		$Sprite/AnimationPlayer.play("Stationary")
		pass
	
		
	pass

func _physics_process(delta):
	if game_stopped: return
	
	if not grounded:
		# If we landed on an object, we're grounded.
		if velocity.y < 0 and ($RayCast2D_Left.is_colliding() or $RayCast2D_Right.is_colliding()):
			grounded = true
			velocity.y = 0
			pass
		# Otherwise, apply gravity
		else:
			velocity.y -= gravity
			#emit_signal("player_jump")
			pass
	else:
		if !$RayCast2D_Left.is_colliding() and !$RayCast2D_Right.is_colliding():
			grounded = false
			pass
		pass
	
	
	gravity_based_velocity = velocity.rotated((position - gravity_body.position).angle() - (PI/2))
	
	move_and_slide(gravity_based_velocity)
	pass

func hit():
	current_health - 1
	if current_health == 0:
		emit_signal("player_death")
		pass
	
	emit_signal("player_hit")
	
	pass 


func _on_GameManager_switch_game_state_signal(pause_state):
	game_stopped = pause_state
	pass
