extends Node

export var gravity_node_path = NodePath()
var gravity_node

export var start_distance = 1600

func _ready():
	gravity_node = get_node(gravity_node_path)
	pass
	
func _process(delta):
	
	if(Input.is_key_pressed(KEY_Z)):
		spawn_trash()
		pass
	pass

func spawn_trash():
	var trash = preload("res://Scenes/BasicTrash.tscn").instance()
	trash.spawn(gravity_node, Vector2.UP.rotated(rand_range(0, 2 * PI)) * start_distance)
	
	add_child(trash)
	
	
	
	pass
