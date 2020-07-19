extends RichTextLabel


func update_time(new_time):
	new_time = new_time as int
	
	var score = new_time as String
	while score.length() < 3:
		score = score.insert(0, "0")
		pass
	
	bbcode_text = "Score: " + score
	pass
