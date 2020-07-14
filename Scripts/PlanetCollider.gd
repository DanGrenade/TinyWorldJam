extends StaticBody2D

var stacks = [Array(), Array(), Array(), Array(), Array(), Array()]


func garbage_hit(collision_point):
	var collision_positioner = (collision_point - position).angle() + (120 * (PI / 180))
	
	
	collision_positioner /= ((2 * PI) / 6)
	if collision_positioner < 0: 
		collision_positioner += 6
	
	collision_positioner = floor(collision_positioner) as int
	
	place_trash(collision_positioner)
	
	pass
	
func drop_trash(rotation):
	rotation = convert_rotation_to_index(rotation)
	place_trash(rotation)	
	pass

func place_trash(index):
	if stacks[index].size() + 1 <= 4:
		match stacks[index].size() + 1:
			1:
				stacks[index].append(preload("res://Scenes/Trash_Pile1.tscn").instance())
			2:
				stacks[index].append(preload("res://Scenes/Trash_Pile2.tscn").instance())
			3:
				stacks[index].append(preload("res://Scenes/Trash_Pile3.tscn").instance())
			4:
				stacks[index].append(preload("res://Scenes/Trash_Pile4.tscn").instance())
		stacks[index].back().rotation_degrees = index * 60
		add_child(stacks[index].back())
		pass
	pass

func Check_Grab(rotation):
	rotation = convert_rotation_to_index(rotation)
	
	if stacks[rotation].size() > 0:
		stacks[rotation].back().queue_free()
		stacks[rotation].pop_back()
		
		return true
	else: return false

func convert_rotation_to_index(rotation):
	if rotation < 0: rotation += 2 * PI
	return (rotation / (2 * PI / 6)) as int
	
