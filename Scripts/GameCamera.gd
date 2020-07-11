extends Camera2D

export var player_follow_path = NodePath()
var player_follow_node

func _ready():
	player_follow_node = get_node(player_follow_path)
	pass

func _process(delta):
	
	
	# global_rotation = player_follow_node.global_rotation
	
	pass
