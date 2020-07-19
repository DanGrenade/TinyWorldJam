extends RichTextLabel


func update_time(new_time):
	new_time = new_time as int
	
	bbcode_text = "[right]" + (new_time as String) + "[/right]"
	pass
