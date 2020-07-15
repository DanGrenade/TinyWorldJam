extends StaticBody2D

var stacks = [Array(), Array(), Array(), Array(), Array(), Array()]


func garbage_hit(collision_point):
	
	collision_point = convert_position_to_index(collision_point)
	
	place_trash(collision_point)
	
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
	
func convert_position_to_index(positioner):
	positioner = (positioner - position).angle() + (120 * (PI / 180))
	
	
	positioner /= ((2 * PI) / 6)
	if positioner < 0: 
		positioner += 6
	
	return floor(positioner) as int
	
func explode(explosion_position):
	explosion_position = convert_position_to_index(explosion_position)
	
	for pile in stacks[explosion_position]:
		pile.queue_free()
		pass
	stacks[explosion_position].clear()
	
	pass
