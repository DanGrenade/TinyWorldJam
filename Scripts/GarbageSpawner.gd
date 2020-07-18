extends Node

export var gravity_node_path = NodePath()
var gravity_node
export var alien_node_path = NodePath()
var alien_node

export var start_distance = 2200


func _ready():
	randomize()
	gravity_node = get_node(gravity_node_path)
	alien_node = get_node(alien_node_path)
	
	var bomb = preload("res://Scenes/Bomb.tscn").instance()
	add_child(bomb)
	bomb.initialize(gravity_node, alien_node)
	pass

func spawn_trash():
	var trash = preload("res://Scenes/BasicTrash.tscn").instance()
	add_child(trash)
	trash.spawn(gravity_node, Vector2.UP.rotated(rand_range(0, 2 * PI)) * start_distance)
	
	pass

func _on_Timer_timeout():
	spawn_trash()
	pass 


func _on_GameManager_switch_game_state_signal(pause_state):
	$Timer.paused = pause_state
	pass
