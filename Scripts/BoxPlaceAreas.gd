extends Node2D


func Find_Place_Position():
	if $LowerArea.get_overlapping_bodies().size() == 0:
		return $LowerArea.global_position
	elif $UpperArea.get_overlapping_bodies().size() == 0:
		return $UpperArea.global_position
	pass
