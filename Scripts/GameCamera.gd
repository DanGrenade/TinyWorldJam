extends Camera2D

export var player_follow_path = NodePath()
var player_follow_node

var shaking = false
export var max_shake = 0.3
export var shake_reduction = 1
var current_shake

func _ready():
	player_follow_node = get_node(player_follow_path)
	pass

func _process(delta):
	
	if shaking:
		current_shake = move_toward(current_shake, 0, shake_reduction * delta)
		if current_shake == 0:
			offset = Vector2.ZERO
			shaking = false
			pass
		else:
			do_shake()
			pass
		pass
	# global_rotation = player_follow_node.global_rotation
	
	pass

func do_shake():
	offset_h = rand_range(-current_shake, current_shake)
	offset_v = rand_range(-current_shake, current_shake)
	
	pass

func _on_PlayerCharacter_player_hit():
	shaking = true
	current_shake = max_shake
	do_shake()
	
	pass 
