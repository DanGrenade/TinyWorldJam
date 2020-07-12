extends Node

export var gravity_node_path = NodePath()
var gravity_node

export var start_distance = 2200


func _ready():
	gravity_node = get_node(gravity_node_path)
	pass

func spawn_trash():
	var trash = preload("res://Scenes/BasicTrash.tscn").instance()
	trash.spawn(gravity_node, Vector2.UP.rotated(rand_range(0, 2 * PI)) * start_distance)
	
	add_child(trash)
	
	pass

func _on_Timer_timeout():
	spawn_trash()
	pass # Replace with function body.
