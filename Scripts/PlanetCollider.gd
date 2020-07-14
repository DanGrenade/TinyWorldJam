extends StaticBody2D

var stacks = [Array(), Array(), Array(), Array(), Array(), Array()]


func garbage_hit(collision_point):
	var collision_positioner = (collision_point - position).angle() + (120 * (PI / 180))
	
	
	collision_positioner /= ((2 * PI) / 6)
	if collision_positioner < 0: 
		collision_positioner += 6
	
	collision_positioner = floor(collision_positioner) as int
	
	if stacks[collision_positioner].size() + 1 <= 4:
		match stacks[collision_positioner].size() + 1:
			1:
				stacks[collision_positioner].append(preload("res://Scenes/Trash_Pile1.tscn").instance())
			2:
				stacks[collision_positioner].append(preload("res://Scenes/Trash_Pile2.tscn").instance())
			3:
				stacks[collision_positioner].append(preload("res://Scenes/Trash_Pile3.tscn").instance())
			4:
				stacks[collision_positioner].append(preload("res://Scenes/Trash_Pile4.tscn").instance())
		stacks[collision_positioner].back().rotation_degrees = collision_positioner * 60
		add_child(stacks[collision_positioner].back())
		pass
	
	pass
